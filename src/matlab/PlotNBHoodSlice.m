function [] = PlotNBHoodSlice(index)

index = 9;

cmap = lines(9);

[x y z] = meshgrid(1:44,1:44,1:44);

startm = zeros(44,44,44); 
nbOffsets = MakeNBOffsets(45); 
L = repmat([22 22 22], [size(nbOffsets{1}, 1), 1]) + nbOffsets{index};
L = L(sum(L > 0,2)==3 & sum(L <= size(startm,1),2)==3, :); 
Lidx = sub2ind(size(startm), L(:,1), L(:,2), L(:,3)); 
M = zeros(size(startm)); M(Lidx) = 1; 
p = patch(isosurface(x,y,z,M,0.0)); 
isonormals(x,y,z,M,p)
axis equal; axis tight; 
xlim([1 44]); ylim([1 44]); zlim([1 44]); box on; 
set(p, 'FaceColor', cmap(index, :), 'EdgeColor', 'none');
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca, 'ZTick', []);

view(150,30); 
camlight; lighting gouraud; 

end