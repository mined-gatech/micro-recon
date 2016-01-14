function [WT WTM WTG ds vfs] = CalcStatDists(M, NUM_WINDOWS, WIN_SIZE)

    WT = GetWindows3D(M, WIN_SIZE, WIN_SIZE, WIN_SIZE, NUM_WINDOWS);
    WTG = zeros(NUM_WINDOWS, WIN_SIZE, WIN_SIZE, WIN_SIZE);
    WTM = zeros(WIN_SIZE,WIN_SIZE,WIN_SIZE); 
    for ii=1:size(WT,1) 
        WTG(ii, :, :, :) = twopointnp3(squeeze(WT(ii,:,:,:)));
        WTM = WTM + squeeze(WTG(ii, :, :, :)); 
    end; 
    WTM = WTM ./ size(WT,1);

    for ii=1:size(WT,1) 
        T = squeeze(WTG(ii,:,:,:));
        ds(ii) = mean( (WTM(:) - T(:) ).^2 );  
        vfs(ii) = mean(WT(ii, :));
    end

end
