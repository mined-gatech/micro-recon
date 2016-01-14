subplot(1,2,1);
imagesc(reshape(NB_queries(ii, :), [13 13])); axis equal; axis tight;
subplot(1,2,2);
imagesc(reshape(Recon.Exemplar_NBs_Edges{1}(Xnnidx(ii), :), [13 13])); axis equal; axis tight;

