function B = GetEdgesCircShift(M)

Bx = circshift(M, [1 0 0]);
By = circshift(M, [0 1 0]);
Bz = circshift(M, [0 0 1]);

B = zeros(size(M));

B = (Bx ~= M) | (By ~= M) | (Bz ~= M);

% We need to do the faces as a special case or they will all be
% marked as edges.
B(:, :, 1) = (Bx(:, :, 1) ~= M(:, :, 1)) | (By(:, :, 1) ~= M(:, :, 1));
B(:, 1, :) = (Bx(:, 1, :) ~= M(:, 1, :)) | (Bz(:, 1, :) ~= M(:, 1, :));
B(1, :, :) = (By(1, :, :) ~= M(1, :, :)) | (Bz(1, :, :) ~= M(1, :, :));

B(:, 1, 1) = Bx(:, 1, 1) ~= M(:, 1, 1);
B(1, :, 1) = By(1, :, 1) ~= M(1, :, 1);
B(1, 1, :) = Bz(1, 1, :) ~= M(1, 1, :);

B(1,1,1) = false;

B = double(B);
