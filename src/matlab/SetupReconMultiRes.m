function ReconHierarchy = SetupReconMultiRes(E, NUM_LEVELS, NB_SIZES, NB_INDICIES, FULL_RECON_SIZE, NUM_CORES, ANG_MAP)

% Add paths the the mex files if they aren't there. We will need it.
add_paths;

ReconHierarchy = cell(NUM_LEVELS, 1);

if(~iscell(E))
    T = cell(1,1);
    T{1} = E;
    E = T;
end

% If the cell array has cell arrays in it, assume the user has passed in
% all the downsampled images so we don't have to compute them. This allows
% the user to construct their own downsampling algorithm if they want.
NUM_EXEMPLARS = length(E);
if(iscell(E{1}))
    P = E;
    NUM_LEVELS = length(P{1});
    ReconHierarchy = cell(NUM_LEVELS, 1);
else
    P = cell(NUM_EXEMPLARS, 1);
    for ii=1:NUM_EXEMPLARS
        P{ii} = BuildExemplarPyramid(E{ii});
    end
end

RECON_SIZE = FULL_RECON_SIZE;
for level=1:NUM_LEVELS
    fprintf(1, 'Level %d\n', level);
    
    Exyz = cell(NUM_EXEMPLARS,1);
    for ex=1:NUM_EXEMPLARS
        Exyz{ex} = P{ex}{level};
    end

    if(nargin == 7)
        ReconHierarchy{level} = SetupRecon(Exyz, NB_SIZES(level), NB_INDICIES, RECON_SIZE, NUM_CORES, ANG_MAP);
    else
        ReconHierarchy{level} = SetupRecon(Exyz, NB_SIZES(level), NB_INDICIES, RECON_SIZE, NUM_CORES);
    end

    RECON_SIZE = ceil(RECON_SIZE / 2);
end
