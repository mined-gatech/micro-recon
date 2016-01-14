load images/slices3.mat
Recon = SetupRecon(Exyz, 5, [1 2 3], [25 25 25], 1);
S = rand(25, 25, 25);
Recon = SearchNNB(S, Recon);
[Snew Recon.TexelWeights Recon.SourceTable] = OptimizeSolidMEX(S, Recon);
