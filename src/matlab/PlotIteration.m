% This function is called at each iteration to SolidOptimization
% to plot the current results.
function [] = PlotIteration(Recon, S, Snew, useWeights, H)

    % Check to make sure that Snew is not all of one value. This
    % will cause slice to error
    if(max(Snew(:)) ~= min(Snew(:)))

        subplot(2,2,1);
        MID = ceil(size(Snew)/2);
        slice(Snew, [1 size(Snew,1)], [1 size(Snew,2)], [1 size(Snew,3)]); 
        axis equal; axis tight; shading flat; box on; 
        colormap('gray'); caxis([0 1]); 
        freezeColors;
        axis off;
        subplot(2,2,2);
        slice(Snew, MID(1), MID(2), MID(3)); 
        axis equal; axis tight; shading flat; box on; 
        colormap('gray'); caxis([0 1]);
        freezeColors;
        axis off;

    end

    subplot(2,2,3);
    Shist = histc(Snew(:), 0:(1/16):1);
    Ehist = histc(Recon.E{1}(:), 0:(1/16):1);
    Shist = Shist ./ sum(Shist);
    Ehist = Ehist ./ sum(Ehist);
   
    hold off;
    plot(0:(1/16):1, Shist, '-r', 'DisplayName', 'Sample');
    hold on;
    plot(0:(1/16):1, Ehist, '-b', 'DisplayName', 'Exemplar');

    subplot(2,2,4);
    T = Recon.SourceTable(:, :, :, 1);  
    T = T(:)+1;
    P = zeros(size(Recon.E{1}));
    for zz=1:length(T)
        P(T(zz)) = P(T(zz)) + 1;
    end

    P(P == 0) = NaN;
    %imagesc(weight_table); colorbar; colormap('jet');
    
    if(useWeights)
        H = H(1:end-Recon.NB_SIZE, 1:end-Recon.NB_SIZE);
        H(H == Recon.NB_SIZE) = NaN;
        pcolor(flipud(H)); shading flat; colorbar; colormap('jet');
        H2 = H(:);
        H2 = H2(~isnan(H2));
        caxis([mean(H2(:))-3*std(H2(:)) mean(H2(:))+3*std(H2(:))])
    else
        pcolor(flipud(P)); shading flat; colormap('jet'); colorbar; axis equal; axis tight;
    end

    drawnow;

end
