function B = GetEdgesCircShift2D(M)

Bx = circshift(M, [1 0]);
By = circshift(M, [0 1]);

B = zeros(size(M));

B = (Bx ~= M) | (By ~= M);

B(:,1) = (Bx(:,1) ~= M(:,1));
B(1,:) = (By(1,:) ~= M(1,:));

B(1,1) = 0;

B = double(B);
