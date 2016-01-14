

Ix = SMALL_M(:, :, 20);
Iy = SMALL_M(:, :, 50);
Iz = SMALL_M(:, :, 100);

Ix2 = GetEdgesCircShift2D(squeeze(Ix)');
Iy2 = GetEdgesCircShift2D(squeeze(Iy)');
Iz2 = GetEdgesCircShift2D(squeeze(Iz)');

Ix2 = imdilate(Ix2, ones(2,2));
Iy2 = imdilate(Iy2, ones(2,2));
Iz2 = imdilate(Iz2, ones(2,2));

Ix = Ix2(5:196,5:196);
Iy = Iy2(5:196,5:196);
Iz = Iz2(5:196,5:196);

subplot(1,3,1); imshow(Ix); subplot(1,3,2); imshow(Iy); subplot(1,3,3); imshow(Iz);
