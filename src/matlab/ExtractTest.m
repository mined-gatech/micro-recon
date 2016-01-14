function [NB_queriesX NB_queriesY NB_queriesZ] = ExtractTest(S, NB_SIZE)

    NB_queriesX = zeros(prod(size(S)), NB_SIZE^2);
    NB_queriesY = zeros(prod(size(S)), NB_SIZE^2);
    NB_queriesZ = zeros(prod(size(S)), NB_SIZE^2);

    HALF_NB_SIZE = floor(NB_SIZE/2);

    qq = 1;
    for ii=1:size(S,1)
        for jj=1:size(S,2)
            for kk=1:size(S,3)

                ii_t_range = (ii-HALF_NB_SIZE:ii+HALF_NB_SIZE);
                jj_t_range = (jj-HALF_NB_SIZE:jj+HALF_NB_SIZE);
                kk_t_range = (kk-HALF_NB_SIZE:kk+HALF_NB_SIZE);
                    
                % Make the template periodic if it goes outside the image
                ii_t_range = mod(ii_t_range-1, size(S, 1)) + 1;
                jj_t_range = mod(jj_t_range-1, size(S, 2)) + 1;
                kk_t_range = mod(kk_t_range-1, size(S, 3)) + 1;
        
                tmp = S(ii_t_range, jj_t_range, kk);
                NB_queriesX(qq, :) = tmp(:);
                tmp = S(ii, jj_t_range, kk_t_range);
                NB_queriesY(qq, :) = tmp(:);
                tmp = S(ii_t_range, jj, kk_t_range);
                NB_queriesZ(qq, :) = tmp(:);

                qq = qq + 1;
            end
        end
    end

 
