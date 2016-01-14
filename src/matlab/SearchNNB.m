function [Recon] = SearchNNB(S, Recon, useWeights)

    if(nargin < 3)
        useWeights = 0;
    end

    if(max(S(:)) >= 2 && ~isfield(Recon, 'AngMap'))
        Sgrain = S;
        S = GetEdgesCircShift(S);
    end

    for ExIndex=1:size(Recon.E, 1)
        nbOffsets = squeeze(Recon.nbOffsets(ExIndex, :, :));
        [NB_queries isPeriodic] = Extract3DNeighborhoods(S, nbOffsets, Recon.NUM_CORES);
        
        % If there is an angle map the we need to convert the indexed image to
        % actual values
        if(isfield(Recon, 'AngMap'))
            ANG_MAP = Recon.AngMap;
            tmp = zeros(size(NB_queries, 1), 3*size(NB_queries, 2));
            for ii=1:size(ANG_MAP, 2)
                idx_start = (ii-1)*size(NB_queries, 2)+1;
                tmp(:, idx_start:(idx_start+size(NB_queries,2)-1)) = reshape(ANG_MAP(NB_queries, ii), size(NB_queries));
            end
            NB_queries = tmp;
        end

        Xnnidx = [];
        if(useWeights)
            tmp = zeros(size(NB_queries,1), size(NB_queries,2)+1);
            tmp(:, 1:end-1) = NB_queries;
            NB_queries = tmp;
        
            NB_db = zeros(size(Recon.Exemplar_NBs{ExIndex},1), size(Recon.Exemplar_NBs{ExIndex},2)+1);
            if(isfield(Recon, 'Exemplar_NBs_Edges'))
                NB_db(:, 1:end-1) = Recon.Exemplar_NBs_Edges{ExIndex};
            else
                NB_db(:, 1:end-1) = Recon.Exemplar_NBs{ExIndex};
            end
                
            NB_db(:, end) = Recon.NBWeights{ExIndex};
                
            [Xnnidx] = flann_search(NB_db', NB_queries', 1, Recon.Exemplar_Params{ExIndex});
        else
            if(isfield(Recon, 'NB_NumGrains') && ~isfield(Recon, 'AngMap'))
                [NB_queries_grain isPeriodic GrainList] = Extract3DNeighborhoods(Sgrain, nbOffsets, Recon.NUM_CORES);
                
                % Convert the grain list to a uint16. It takes up much less space
                GrainList = uint16(GrainList);

                % Get the number of grains
                NumGrains = sum(GrainList > 0, 2);

                % Truncate the grain list, this gets rid of zeros.
                GrainList = GrainList(:, 1:max(NumGrains));

                [Xnnidx] = flann_search(Recon.Exemplar_Index{ExIndex}, [NB_queries NumGrains*1000]', 1, Recon.Exemplar_Params{ExIndex});
            else
                [Xnnidx] = flann_search(Recon.Exemplar_Index{ExIndex}, NB_queries', 1, Recon.Exemplar_Params{ExIndex});
            end
        end

        qq = 1;
        for ii=1:size(S,1)
            for jj=1:size(S,2)
                for kk=1:size(S,3)
                    Recon.NNB_Table(ii, jj, kk, ExIndex) = Xnnidx(qq);
                    if(isPeriodic(qq))
                        Recon.NNB_Table(ii, jj, kk, ExIndex) = -1;
                    end
                    qq = qq + 1;
                end
            end
        end
    end

end
