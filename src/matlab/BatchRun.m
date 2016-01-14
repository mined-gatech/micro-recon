%ReconH = SetupReconMultiRes(E(1:3), 3, [9 9 9], 1:3, [150 150 150], 16);
%RunIt
%S_star3 = S_star;
%save ../../results/grf21_result.mat S_star3
%DestroyReconMultiRes(ReconH)
ReconH = SetupReconMultiRes(E(1:9), 3, [9 9 9], 1:9, [150 150 150], 16);
RunIt
S_star9 = S_star;
load ../../results/grf21_result.mat; 
save ../../results/grf21_result.mat S_star3 S_star9
