function [] = Plot3DMicro(Snew)

    subplot(1,2,1)
    MID = ceil(size(Snew)/2);
    slice(Snew, [1 size(Snew,1)], [1 size(Snew,2)], [1 size(Snew,3)]); 
    axis equal; axis tight; shading flat; box on; 
    colormap('jet'); caxis([0 1]); 
    freezeColors;
    subplot(1,2,2);
    slice(Snew, MID(1), MID(2), MID(3)); 
    axis equal; axis tight; shading flat; box on; 
    colormap('jet'); caxis([0 1]);
    freezeColors;

end

