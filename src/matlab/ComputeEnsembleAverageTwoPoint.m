function [WTM] = ComputeEnsembleAverageTwoPoint(M, NUM_WINS, WIN_SIZE)
    WTM = zeros(WIN_SIZE,WIN_SIZE,WIN_SIZE); 
    for ii=1:NUM_WINS 
        fprintf(1, '%d of %d\n', ii, NUM_WINS); 
        WTM = WTM + twopointnp3(squeeze(GetWindows3D(M,WIN_SIZE,WIN_SIZE,WIN_SIZE,1))); 
    end; 
    WTM = WTM ./ NUM_WINS;
end