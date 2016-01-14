function [E] = GenNineSlices(M)

    if(max(size(M)) ~= min(size(M)))
        error('This function requires that the sample be a cube with equal dimensions');
    end

    if(mod(max(size(M)), 2) == 0)
        error('This function requires that the sample size be odd');
    end

    % These should all be the same, might fix it in the future.
    cx = round(size(M,1) / 2);
    cy = round(size(M,2) / 2);
    cz = round(size(M,3) / 2);

    E{1} = squeeze(M(:, :, cz));
    E{2} = squeeze(M(cx, :, :));
    E{3} = squeeze(M(:, cy, :));

    MAX_SIZE = max(size(M));
    
    nbO = MakeNBOffsets(MAX_SIZE);

    % The last six slices are not the three principal axes. These require special
    % attention.
    for ii=4:9
        xyz = nbO{ii};
        xyz = xyz + repmat([cx cy cz], size(xyz,1), 1);

        % Remove the out of bounds indices
        bad = sum(xyz <= 0, 2) | xyz(:,1) > size(M,1) | xyz(:,2) > size(M,2) | xyz(:,3) > size(M,3);
        xyz(bad, :) = [];

        % Convert our 3 index system to a linear index
        idx = sub2ind(size(M), xyz(:,1), xyz(:,2), xyz(:,3));

        % Get the values of M at all the locations
        vals = M(idx);
        
        % Reshape to be a 2D image
        E{ii} = reshape(vals, [MAX_SIZE MAX_SIZE]);

    end

end
