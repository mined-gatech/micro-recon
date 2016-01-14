function RS = SetupRecon(E, NB_SIZE, NB_INDICIES, RECON_SIZE, NUM_CORES, ANG_MAP)

if(nargin < 5)
    error('Need at least five arguments!\n\n\tSetupRecon(E, NB_SIZE, NB_INDICIES, RECON_SIZE, NUM_CORES, [ANG_MAP])');
end

if(RECON_SIZE(2) == 1)
    RECON_SIZE = [RECON_SIZE 1];
end

RS.NUM_CORES = NUM_CORES;

RS.NB_SIZE = NB_SIZE;
HALF_NB_SIZE = floor(NB_SIZE/2);
    
if(iscell(E))
    RS.E = E;
else
   RS.E = cell(1, 1);
   RS.E{1} = E;
end

if(length(NB_INDICIES) ~= length(E))
    error('Number of exemplars needs to be the same as length of neighborhood indices!');
end


RS.RECON_SIZE = RECON_SIZE;
RS.Exemplar_NBs = cell(length(E), 1);
RS.Exemplar_Index = cell(length(E), 1);
RS.Exemplar_Params = cell(length(E), 1);
RS.Exemplar_NBLookup = cell(length(E),1);
RS.NB_ExemplarLookup = cell(length(E),1);
RS.Exemplar_KCTable = cell(length(E),1);
RS.Optimum_Locs = cell(length(E), 1);

% If the user passed in angle map for the images. Then store it
isAngMap = nargin > 5;

if(isAngMap)
    RS.AngMap = ANG_MAP;
end

% If the exemplars passed in are non-binary images then we will
% treat them as a grain map. We will store neighborhoods for
% both the grain boundaries and the grain map itself.
if(max(E{1}(:)) > 1)
    RS.Exemplar_NBs_Edges = cell(length(E), 1);
    RS.E_Edges = E;
    for ii=1:length(E)
        RS.E_Edges{ii} = GetEdgesCircShift2D(E{ii});
    end
    RS.NB_GrainList = cell(length(E), 1);
    RS.NB_NumGrains = cell(length(E), 1);
end

% Get the neighborhoods offsets for this neighborhood size.
% Use the standard list.
nbOffsets = MakeNBOffsets(NB_SIZE);
nbOffsets = nbOffsets(NB_INDICIES);
RS.nbOffsets = zeros([length(NB_INDICIES), size(nbOffsets{1})]);
for ii=1:length(NB_INDICIES)
    RS.nbOffsets(ii, :) = nbOffsets{ii}(:);
end

% NNB Index Parameters
build_params.cores = RS.NUM_CORES;

build_params.algorithm = 'kdtree';
build_params.trees = 8;
build_params.checks = 131;

%build_params.algorithm = 'kmeans';
%build_params.trees = 4;
%build_params.checks = 100;

%build_params.algorithm = 'autotuned';
%build_params.target_precision = 0.8;
%build_params.build_weight = 0.8;
%build_params.memory_weight = 0;

fastUnique = @(x) find(accumarray(x(:,1)+1,1))-1;

for ii=1:length(E)
    fprintf(1, '\tGetting neighborhoods for exemplar %d of %d ...', ii, length(E));

    if(isfield(RS, 'NB_GrainList'))
        [NB_Hoods RS.NB_ExemplarLookup{ii} RS.NB_GrainList{ii}] = GetAllNHoodsMEX(RS.E{ii}, NB_SIZE);
        RS.NB_NumGrains{ii} = sum(RS.NB_GrainList{ii} > 0, 2);
        RS.NB_GrainList{ii} = uint16(RS.NB_GrainList{ii});
        RS.NB_GrainList{ii} = RS.NB_GrainList{ii}(:, 1:max(RS.NB_NumGrains{ii}));
    else
        [NB_Hoods RS.NB_ExemplarLookup{ii}] = GetAllNHoodsMEX(RS.E{ii}, NB_SIZE);
    end
    RS.Exemplar_NBs{ii} = NB_Hoods; 

    % If there is a grain boundary map. Then get the neighborhoods for this as well
    if(isfield(RS, 'E_Edges'))
        [RS.Exemplar_NBs_Edges{ii} RS.NB_ExemplarLookup{ii}] = GetAllNHoodsMEX(RS.E_Edges{ii}, NB_SIZE);
    end

    % If we have an angle map. Then the images are indexed and we need to convert
    % the neighborhoods to their actual angles. We will use the 6,7,8 GSH coeffcients
    % because they have indpendent information.
    if(isAngMap)
        tmp = zeros(size(NB_Hoods, 1), 3*size(NB_Hoods, 2));
        for ll=1:size(ANG_MAP, 2)
            idx_start = (ll-1)*size(NB_Hoods, 2)+1;
            tmp(:, idx_start:(idx_start+size(NB_Hoods,2)-1)) = reshape(ANG_MAP(NB_Hoods, ll), size(NB_Hoods));
        end
        RS.Exemplar_NBs{ii} = tmp;
    end

    % Make a map for the original exemplar image that tells where each
    % neighborhood is stored in the the neighborhood table
    RS.Exemplar_NBLookup{ii} = zeros(size(RS.E{ii}));
    for ll=1:size(RS.NB_ExemplarLookup{ii}, 1)
       RS.Exemplar_NBLookup{ii}(RS.NB_ExemplarLookup{ii}(ll, 1), RS.NB_ExemplarLookup{ii}(ll, 2)) = ll;  
    end
    
    fprintf(1, 'Done\n');

    % Build nearest neighbor query indices for these points.
    fprintf(1, '\tBuilding FLANN index for exemplar %d of %d ...', ii, length(E));
    RS.Exemplar_Params{ii} = build_params;
    tic;
    if(isfield(RS, 'Exemplar_NBs_Edges') && ~isAngMap)
        if(isfield(RS, 'NB_NumGrains'))
            [RS.Exemplar_Index{ii} RS.Exemplar_Params{ii}] = flann_build_index([RS.Exemplar_NBs_Edges{ii} RS.NB_NumGrains{ii}*1000]', build_params);
        else
            [RS.Exemplar_Index{ii} RS.Exemplar_Params{ii}] = flann_build_index(RS.Exemplar_NBs_Edges{ii}', build_params);
        end
    else
        [RS.Exemplar_Index{ii} RS.Exemplar_Params{ii}] = flann_build_index([RS.Exemplar_NBs{ii}]' , build_params);
    end
    
    elapsed_time = toc;
    fprintf(1, 'Done. Time to Build = %f seconds\n', elapsed_time);
    
    % Construct a k-coherence lookup table for all the neighborhoods. This table tells
    % us for each neighborhood what are the K nearest closest neighborhoods to it.
    %fprintf(1, '\tBuilding k-coherence table for exemplar %d of % ...', ii, length(E));
    %RS.K = K;
    %[RS.Exemplar_KCTable{ii}] = flann_search(RS.Exemplar_Index{ii}, RS.Exemplar_NBs{ii}', RS.K, RS.Exemplar_Params{ii});
    %fprintf(1, 'Done\n');

    % Save the index to a file
    %filename = sprintf('exemplar%d.flandx');
    %flann_save_index(RS.Exemplar_Index{ii}, RS.Exemplar_Index{ii});
end

% Setup the reconstruction change table. This tells us which
% neighborhoods have changed in the reconstruction over the last
% iteration. This allows us to only search for new matching
% neighborhoods on those that have changed.
RS.change_table = ones(RECON_SIZE);
    
% At each iteration we need to build a table that says for each voxel
% in the reconstruction where the best matching neighborhoods is in each
% exemplar.
RS.NNB_Table = zeros([RECON_SIZE length(E)]);

% Get the two point statistics of the exemplars
RS.Exemplar_Stats = cell(length(E), 1); 
RS.Exemplar_Stats_Norm = cell(length(E), 1); 
for ii=1:length(E)
%    fprintf(1, '\tGetting statistics for exemplar %d of %d ...', ii, length(E));
    [G D] = twopointnp2(RS.E{1});
    G = G .* D;
    [maxV maxI] = max(G(:)); [center(1) center(2)] = ind2sub(size(G), maxI);
    RS.Exemplar_Stats{ii} = G(center(1)-HALF_NB_SIZE:center(1)+HALF_NB_SIZE, ...
                                  center(2)-HALF_NB_SIZE:center(2)+HALF_NB_SIZE);
    RS.Exemplar_Stats_Norm{ii} = D(center(1)-HALF_NB_SIZE:center(1)+HALF_NB_SIZE, ...
                                  center(2)-HALF_NB_SIZE:center(2)+HALF_NB_SIZE);
%    fprintf(1, 'Done\n');
end


