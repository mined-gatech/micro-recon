function [] = Plot16Frames(S_iters)

kk = 1;
for ii=1:30
    subaxis(5,5,kk, 'Spacing', 0.02, 'Padding', 0.02, 'Margin', 0.02);
    pcolor(S_iters(:, :, 1, ii)); shading flat; axis equal; axis tight; axis off;
    title(sprintf('Iteration %d', ii), 'FontWeight', 'Bold');
    kk = kk + 1;
end