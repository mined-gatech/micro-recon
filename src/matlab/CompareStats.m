function [] = CompareStats(E, S, NB_SIZE)

E_Stats = GetNBStats(E, NB_SIZE);
S_Stats = GetNBStats(S, NB_SIZE);

subplot(1,2,1);
imagesc(E_Stats); axis equal; axis tight;
colorbar;
title(sprintf('Exemplar (error = %g)', norm(E_Stats(:) - S_Stats(:))));
caxis([min([E_Stats(:)' S_Stats(:)']) max([E_Stats(:)' S_Stats(:)'])]);

subplot(1,2,2);
imagesc(S_Stats); axis equal; axis tight;
title(sprintf('Recon (error = %g)', norm(E_Stats(:) - S_Stats(:))));
colorbar;
caxis([min([E_Stats(:)' S_Stats(:)']) max([E_Stats(:)' S_Stats(:)'])]);
