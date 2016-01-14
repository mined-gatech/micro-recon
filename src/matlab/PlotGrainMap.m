function [] = PlotGrainMap(S)

    rng(1);
    cmap = rand(3000, 3);
    
    imagesc(S); colormap(cmap); caxis([0 3000]);
    
end