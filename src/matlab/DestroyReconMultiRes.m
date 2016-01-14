function [] = DestroyReconMultiRes(ReconHierarchy)

    for ii=1:size(ReconHierarchy, 1)
        DestroyRecon(ReconHierarchy{ii});
    end
    
