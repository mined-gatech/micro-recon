function [Sgrain S_iters Recon] = SolidOptimizationGrainMap(Recon, NUM_ITERATIONS, start, useWeights)
    
    HALF_NB_SIZE = floor(Recon.NB_SIZE/2);

    S = double(GetEdgesCircShift(start));
    Sgrain = start;

    if(nargin < 4)
        useWeights = 0;
    end

    % Given the following start microstructure. Lets calculate the starting
    % statistics.
    Recon.CurrentStats = cell(size(Recon.E, 1), 1);
    Recon.CurrentStatsNorm = cell(size(Recon.E, 1), 1);
    [G D] = twopointnp2(S);
    G = round(G .* D);
    [v maxI] = max(G(:)); 
    [cx cy] = ind2sub(size(G), maxI); 
    Recon.CurrentStats{1} = G(cx-HALF_NB_SIZE:cx+HALF_NB_SIZE, cy-HALF_NB_SIZE:cy+HALF_NB_SIZE);
    Recon.CurrentStatsNorm{1} = D(cx-HALF_NB_SIZE:cx+HALF_NB_SIZE, cy-HALF_NB_SIZE:cy+HALF_NB_SIZE);
    
    for ii=1:size(Recon.E)
        Recon.TexelWeights{ii} = ones(size(Recon.E{ii}));
        Recon.TexelWeights{ii}(Recon.E{ii} == 0) = 0.5;
    end

    if(useWeights)
        for ii=1:size(Recon.E)
            Recon.NBWeights{ii} = ones(1, size(Recon.Exemplar_NBs{ii},1)) * Recon.NB_SIZE;
        end
    end
    
    S_iters = zeros([size(S) NUM_ITERATIONS+1]);
    S_iters(:, :, :, 1) = S;

    elapsed_search = 0;
    elapsed_opt = 0;
    H = [];
    for ii=1:NUM_ITERATIONS
        fprintf(1, 'Iteration: %d\n', ii);

        tic;
        fprintf(1, '    Finding nearest neighbors ... ');
        Recon = SearchNNB(Sgrain, Recon, useWeights);
        elapsed_search = elapsed_search + toc;
        fprintf(1, 'Done: %f\n', toc);
            
        tic;
        fprintf(1, '    Optimizing solid ... ');
        [Snew Recon.TexelWeights Recon.SourceTable] = OptimizeSolidMEX(Sgrain, Recon);

        % Update the neighborhood weights
        if(useWeights)
            for pp=1:size(Recon.E, 1)
                H = zeros(size(Recon.E{pp})); 
                NBs = Recon.NNB_Table(:, :, :, pp); 
                NBs = NBs(:); 
                for kk=1:length(NBs) 
                    xy = Recon.NB_ExemplarLookup{pp}(NBs(kk), :); 
                    H(xy(1), xy(2)) = H(xy(1), xy(2)) + 1; 
                end
                H = H ./ sum(H(:));

                expected_weight = (length(NBs) / size(Recon.Exemplar_NBs{pp}, 1)) / length(NBs);
                
                diff_weights = H - expected_weight;
                diff_weights(diff_weights > 0) = 0;
                  
                weight_table = ones(size(diff_weights))*Recon.NB_SIZE;
                for kk=1:length(Recon.NBWeights{pp})
                    xy = Recon.NB_ExemplarLookup{pp}(kk, :);
                    Recon.NBWeights{pp}(kk) = Recon.NBWeights{pp}(kk) + diff_weights(xy(1), xy(2)) * 10;
                    if(Recon.NBWeights{pp}(kk) < 0)
                        Recon.NBWeights{pp}(kk) = 0;
                    end
                    weight_table(xy(1), xy(2)) = Recon.NBWeights{pp}(kk);
                end
                
            end
        end

        % If we are running a polycrsytal reconstruction
        if(max(Snew(:)) > 1.0)
            PlotIterationGrainMap(Recon, S, Snew, useWeights, H);            
        else
            PlotIteration(Recon, S, Snew, useWeights, H);
        end
       
        S_iters(:, :, :, ii+1) = Snew;

        % It converged!
        numChanged = (Snew(:) ~= Sgrain(:));
        percentChanged = 100*(sum(numChanged)/numel(S));

        fprintf(1, 'Done: %f, vf=%f, percentChange=%f\n', toc, mean(S(:)), percentChanged);

        Sgrain = Snew;
        S = GetEdgesCircShift(Sgrain);
      
        if( percentChanged < 1)
            fprintf(1, 'Done.\nIt converged!\n');
            S_iters = S_iters(:, :, :, 1:ii);
            break;
        end

        elapsed_opt = elapsed_opt + toc;

    end
    fprintf(1, '   Iterations: %d   SearchTime: %f secs   OptimTime: %f secs\n', ii, elapsed_search, elapsed_opt);

end
