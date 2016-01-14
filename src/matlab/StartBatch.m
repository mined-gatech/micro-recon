%I = imread('~/work/samples/recon_survey/ceramics.bmp'); 
%I = double(rgb2gray(I)) / 255; E{1} = I; E{2} = I; E{3} = I;
I = imread('~/work/samples/recon_survey/carbonate.bmp'); I = double(I) / 255; E{1} = I; E{2} = I; E{3} = I;

ReconH = SetupReconMultiRes(E(1:3), 3, [5 11 5], 1:3, [306 306 306], 16);

RunIt
save -v7.3 ../../results/carbonate_results.mat S_star ReconH
quit;
