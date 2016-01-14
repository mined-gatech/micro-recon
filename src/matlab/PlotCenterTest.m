figure; 
    subplot(2,3,1); 
    pcolor(squeeze(S_start(:, :, 11))); 
    shading flat; 
    subplot(2,3,4); pcolor(squeeze(Recon.NNB_Table(:, :, 11, 1))); shading flat;
    
    subplot(2,3,2); 
    pcolor(squeeze(S_start(:, 11, :))); 
    shading flat; 
    subplot(2,3,5); pcolor(squeeze(Recon.NNB_Table(:, 11, :, 3))); shading flat
   
    subplot(2,3,3); 
    pcolor(squeeze(S_start(11, :, :))); 
    shading flat; 
    subplot(2,3,6); pcolor(squeeze(Recon.NNB_Table(11, :, :, 2))); shading flat
