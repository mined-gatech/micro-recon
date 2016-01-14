function [] = CompareByPCA(M, S_star, NUM_WINDOWS, WIN_SIZE, filename)

    fprintf(1, '\tCalculating stats for ensemble from ground truth ... ');
    [WT WTM WTG ds vfs] = CalcStatDists(M, NUM_WINDOWS, WIN_SIZE);
    fprintf(1, 'Done\n');

    % Flatten our array of statistics
    WTG = WTG(:, :)';

    % Mean center them
    WTG = WTG - repmat(WTM(:), [1 size(WTG,2)]);

    % Create a low rank approximation of WTG = U*S*V';
    [U S V] = pca_lowrank(WTG, 3);

    % Compute the top 3 pc's of WTG
    pcs = S*V';

    % Now lets get the reconstruction's ensemble, reuse some variables 
    % because these can be big.
    fprintf(1, '\tCalculating stats for ensemble from reconstruction ... ');
    [WT RWTM WTG ds vfs] = CalcStatDists(S_star, NUM_WINDOWS, WIN_SIZE);
    fprintf(1, 'Done\n');
    
    % Flatten and mean center like before. But use the same mean we utilized 
    % for the pca or the ground truth.
    WTG = WTG(:, :)';
    WTG = WTG - repmat(WTM(:), [1 size(WTG,2)]);

    % Project down into our pca basis we found before
    rpcs = U'*WTG;

    sz = WIN_SIZE;
    red = repmat([1 0 0], [NUM_WINDOWS 1]);
    pt_size = 0.7;

    figure;
    scatter3(pcs(1,:), pcs(2,:), pcs(3,:), 15, 'red', 'filled'); 
    %scatter3sph(pcs(1,:), pcs(2,:), pcs(3,:), 'size', pt_size, 'color', red, 'transp', 0.3); 
    grid on; 
    set(gca, 'FontSize', 15); xlabel('PC1'); ylabel('PC2'); zlabel('PC3');
    title(sprintf('Neighboorhood Size: %dx%dx%d', sz,sz,sz)) 
    hold on;  
    scatter3(rpcs(1,:), rpcs(2,:), rpcs(3,:), 15, 'blue', 'filled');
    blue = repmat([0 0 1], [NUM_WINDOWS 1]);
    %scatter3sph(rpcs(1,:), rpcs(2,:), rpcs(3,:), 'size', pt_size, 'color', blue, 'transp', 0.3); 
    grid on; 
    set(gca, 'FontSize', 15); xlabel('PC1'); ylabel('PC2'); zlabel('PC3');
    title(sprintf('Neighboorhood Size: %dx%dx%d', sz,sz,sz)) 

    if(nargin > 4)
        saveas(gcf, sprintf('%s.fig', filename));
        saveas(gcf, sprintf('%s.png', filename));
    end

end
