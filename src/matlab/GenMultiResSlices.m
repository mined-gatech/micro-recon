function MR_Exyz = GenMultiResSlices(M, NUM_LEVELS)

    M = permute(M,[2 1 3]);
    sizeM = size(M);
    sizeM = sizeM(1:2);
    for ii=1:NUM_LEVELS
        if(ii > 1)
            MR_Exyz{ii} = GenSlices(M, sizeM);
        else
            MR_Exyz{ii} = GenSlices(M);
        end
        sizeM = round(sizeM / 2);
    end
    
    % Rarrange the cell becuase I wrote the code backwards.
    % The first cell level should be the exemplars and the next
    % should be the resolution.
    NUM_SLICES = length(MR_Exyz{1});
    NM = cell(NUM_SLICES,1);
    for ii=1:NUM_SLICES
        NM{ii} = cell(NUM_LEVELS, 1);
        for jj=1:NUM_LEVELS
            NM{ii}{jj} = MR_Exyz{jj}{ii}; 
        end
    end

    MR_Exyz = NM;  

end
