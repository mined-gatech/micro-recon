
NUM_LEVELS = size(ReconH,1);

FULL_RECON_SIZE = ReconH{1}.RECON_SIZE;
START_RECON_SIZE = ReconH{NUM_LEVELS}.RECON_SIZE;

%startm = S_star;
%startm = double(rand(START_RECON_SIZE) > 0.5);
%startm = M2;
%startm = StartGuess(ReconH{NUM_LEVELS}.E, START_RECON_SIZE);
%startm = GPReduce(M(1:150,1:150,1:150));
startm = double(rand(START_RECON_SIZE) > 0.5);
%startm = MakeMicro(START_RECON_SIZE, 5*5*5); startm = double(GetEdgesCircShift(startm));
%startm = MakeMicro(START_RECON_SIZE, 6*6*6); 
%U = unique(startm(:)); for ii=1:length(U) startm(U(ii) == startm) = randi(size(ANG_MAP,1), 1, 1); end

useWeights = 0;

S_star = startm;
MAX_ITERATIONS = [5 165 200];
ll = 1;
%S_iters = zeros([FULL_RECON_SIZE sum(MAX_ITERATIONS)]);

close all;

WeightScaleFactors = [10000 1000 1000];

if(useWeights)
    for ii=size(ReconH,1):-1:1
        if(isfield(ReconH{ii}, 'NBWeights'))
            ReconH{ii} = rmfield(ReconH{ii}, 'NBWeights');
        end
    end
    for ii=size(ReconH,1):-1:1
        ReconH{ii}.WeightScaleFactor = WeightScaleFactors(ii); 
    end
end

for ii=size(ReconH,1):-1:1

    % Don't use neighborhood weights at the highest resolution, it takes too long.
    if(ii == 1)
        useWeights = 0;
        %keyboard;
    end

    if(exist('ANG_MAP'))
        [S_star S_iters_tmp ReconH{ii}] = SolidOptimization(ReconH{ii}, MAX_ITERATIONS(ii), S_star, 0, ANG_MAP);
    else
        [S_star S_iters_tmp ReconH{ii}] = SolidOptimization(ReconH{ii}, MAX_ITERATIONS(ii), S_star, useWeights);
    end

    save(sprintf('S_star%d.mat', ii), 'S_star');

    save -v7.3 ReconTemp.mat S_star ReconH;

    if(ii > 1)
        
        % Resize all the iterations so we can plot them in a video later.
        fprintf(1, '\tResizing Iterations For Records\n');
%        for kk=1:size(S_iters_tmp, 4)
%            S_iters(:, :, :, ll) = mat2gray(resize(S_iters_tmp(:, :, :, kk), FULL_RECON_SIZE));
%            ll = ll + 1;
%        end
        
        % Upscale the volume. The size can be off by one so make sure it isn't.
        %S_star = mat2gray(GPExpand(S_star));
        nxSize = ReconH{ii-1}.RECON_SIZE;
        
        S_star = resize(S_star, nxSize, 'nearest');

        % If we are going to the final level next then we need to threshold
        % the input. Lets choose a threshold such that the volumen fraction
        % matches the exemplar.
        if(ii == 2)
            vf_to_match = 0;
            for zz=1:size(ReconH{1}.E, 1)
                T = ReconH{1}.E{zz};
                vf_to_match = vf_to_match + mean(T(:));
            end
            vf_to_match = vf_to_match / size(ReconH{1}.E, 1);

            S_star = ThresholdToVf(S_star, vf_to_match);
        end

        % Resize the Texel weights
        if(ii-1 > 0)
            for pp=1:size(ReconH{ii}.E, 1)
                ReconH{ii-1}.TexelWeights{pp} = resize(ReconH{ii}.TexelWeights{pp}, size(ReconH{ii-1}.E{pp}), 'nearest');
            end
        end

        % Ok, if we have a neighborhood weighting table, resize it as well and
        % use it as the input into the next level. 
        if(useWeights && ii-1 > 1)

            % The neighborhood weight table is not stored like an image but instead
            % a list. We need to make it an image so we can resize\interpolate spatially
            for pp=1:size(ReconH{ii}.E, 1)
                weight_table = zeros(size(ReconH{ii}.E{pp})-ReconH{ii}.NB_SIZE+1);
                
                % Reformat ReconH{ii}.NBWeights{pp} into an image.
                for kk=1:length(ReconH{ii}.NBWeights{pp})
                    % Get the x,y pixel location of this neighborhood in the exemplar
                    xy = ReconH{ii}.NB_ExemplarLookup{pp}(kk, :);

                    weight_table(xy(1), xy(2)) = ReconH{ii}.NBWeights{pp}(kk);
                end

                % Upsample the weight_table with simple nearest neighbor interpolation
                nx_Ex_Size = size(ReconH{ii-1}.E{pp})-ReconH{ii}.NB_SIZE+1;
                weight_table = resize(weight_table, nx_Ex_Size, 'nearest');
                
                ReconH{ii-1}.NBWeights{pp} = zeros(1, size(ReconH{ii-1}.Exemplar_NBs{pp},1));
                for kk=1:length(ReconH{ii-1}.NBWeights{pp})
                    xy = ReconH{ii-1}.NB_ExemplarLookup{pp}(kk, :);
                    ReconH{ii-1}.NBWeights{pp}(1, kk) = weight_table(xy(1), xy(2));   
                end

            end

        end


        %S_star = S_star(1:nxSize(1), 1:nxSize(2), 1:nxSize(3));

    end
    

end
 
save('S_final.mat', 'S_star');

%for kk=1:size(S_iters_tmp, 4)
%     S_iters(:, :, :, ll) = S_iters_tmp(:, :, :, kk);
%     ll = ll + 1;
%end
%S_iters = S_iters(:, :, :, 1:ll-1);

%implay(S_iters, 2);

