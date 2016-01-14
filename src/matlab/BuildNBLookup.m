function NB_Map = BuildNBLookup(NB_SIZE, ImageSize)

    HALF_NB_SIZE = floor(NB_SIZE/2);
         
    if(length(ImageSize) == 2)
        NB_Map = zeros(ImageSize(1), ImageSize(2), NB_SIZE^2);  
        for ii=1:ImageSize(1)
            for jj=1:ImageSize(2)
                % Get the indices for the neighborhood
                ii_t_range = (ii-HALF_NB_SIZE:ii+HALF_NB_SIZE);
                jj_t_range = (jj-HALF_NB_SIZE:jj+HALF_NB_SIZE);
                
                % Make the template periodic if it goes outside the image
                ii_t_range = mod(ii_t_range-1, ImageSize(1)) + 1;
                jj_t_range = mod(jj_t_range-1, ImageSize(2)) + 1;
        
                pp=1;
                for jj_t=jj_t_range
                    for ii_t=ii_t_range
                         NB_Map(ii, jj, pp) = sub2ind(ImageSize, ii_t, jj_t);
                         pp = pp + 1;
                    end
                end
                
            end
        end

    elseif(ndims(I) == 3)
        
    end

    
end
