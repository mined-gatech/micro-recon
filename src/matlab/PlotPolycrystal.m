function [cmap] = PlotPolycrystal(Snew, ANG_MAP)

    % Map to angles\GSH coeffcients to arbitrary colors
    R = ANG_MAP(:,1);
    G = ANG_MAP(:,2);
    B = ANG_MAP(:,3);
    R = (R-min(R(:))) ./ (max(R(:)-min(R(:))));
    G = (G-min(G(:))) ./ (max(G(:)-min(G(:))));
    B = (B-min(B(:))) ./ (max(B(:)-min(B(:))));

    cmap = [R G B];

    subplot(1,2,1)
    MID = ceil(size(Snew)/2);
    slice(Snew, [1 size(Snew,1)], [1 size(Snew,2)], [1 size(Snew,3)]); 
    axis equal; axis tight; shading flat; box on; 
    %colormap('gray'); caxis([0 1]); 
    colormap(cmap); caxis([1 size(ANG_MAP,1)]);
    %freezeColors;
    axis off;
    colorbar('off')
    subplot(1,2,2);
    slice(Snew, MID(1), MID(2), MID(3)); 
    axis equal; axis tight; shading flat; box on; 
    colorbar('off')
    %colormap('gray'); caxis([0 1]);
    colormap(cmap); caxis([1 size(ANG_MAP,1)]);
    %freezeColors;
    axis off;

    drawnow;

end
