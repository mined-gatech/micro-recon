function [Exyz] = GenSlices(M, sizeM)

    NUM_SLICES = 9;
    ss = 1;
    for ii=1:(size(M,3)/NUM_SLICES):size(M, 3);
        I = double(M(:, :, round(ii)));
        if(nargin > 1)
            I = imresize(I, sizeM, 'nearest');
        end
        %I = GetEdgesCircShift2D(I);
        Exyz{ss} = I;
        ss = ss + 1;
    end

end
