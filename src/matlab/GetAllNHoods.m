function [NB_Hoods NB_Lookup NB_Stats PixelWeightTable] = GetAllNHoods(I, NB_SIZE, periodicity, keep_all)

if(nargin <= 2)
    periodicity = 0;
end

if(nargin <= 3)
    keep_all = 0;
end

if(periodicity == 1)
    stat_func = @twopoint2;
    ii_bound = size(I,1);
    jj_bound = size(I,2);
else
    stat_func = @twopointnp2;
    ii_bound = size(I,1)-NB_SIZE+1;
    jj_bound = size(I,2)-NB_SIZE+1;
end

if(periodicity == 0)
    NUM_NEIGHBORHOODS = prod(ii_bound*jj_bound);
elseif(periodicity == 1)
    NUM_NEIGHBORHOODS = numel(I);
end

% Go through image and get all the neighborhoods in the exemplar
NB_Hoods = zeros(NUM_NEIGHBORHOODS, NB_SIZE^ndims(I));
NB_Lookup = zeros(NUM_NEIGHBORHOODS, ndims(I));

if(nargout > 2)
    NB_Stats = zeros(size(NB_Hoods));
end

if(nargout > 3)
    PixelWeightTable = zeros(size(I));
end

ll = 1;

if(ndims(I) == 2)
    for jj=1:jj_bound
        for ii=1:ii_bound
            ii_t_range = ii:ii+NB_SIZE-1;
            jj_t_range = jj:jj+NB_SIZE-1;
                
            % Make the template periodic if it goes outside the image
            %ii_t_range = mod(ii_t_range-1, size(I, 1)) + 1;
            %jj_t_range = mod(jj_t_range-1, size(I, 2)) + 1;
            
            if(nargout > 3)
                PixelWeightTable(ii_t_range, jj_t_range) = PixelWeightTable(ii_t_range, jj_t_range) + 1;
            end
            
            tmp = I(ii_t_range, jj_t_range);
            if(nargout > 2)
                tmp_stats = stat_func(tmp);
                NB_Stats(ll, :) = tmp_stats(:);
            end
            
            NB_Hoods(ll, :) = tmp(:);
            NB_Lookup(ll, :) = [ii jj];
            ll = ll + 1;
        end
    end
end

if(~keep_all)
    if(nargout > 2)
        [NB_Stats II] = unique(NB_Stats, 'rows'); NB_Hoods=NB_Hoods(II, :); NB_Lookup=NB_Lookup(II, :);
     else
        [NB_Hoods II] = unique(NB_Hoods, 'rows'); NB_Lookup=NB_Lookup(II, :);
    end
end
    