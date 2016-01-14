function [W Is]  = GetWindows3D( I, WIN_XSIZE, WIN_YSIZE, WIN_ZSIZE, NUM_WINDOWS )
%GETWINDOWS3D Obtains a set of random windows of an input matrix.
%   This function creates a list of windows from a given matrix. The matrix
%   must be 3D.

% Seed the random number generator to a new value.
rand('twister',sum(100*clock))

zsize = size(I, 3);
ysize = size(I, 2);
xsize = size(I, 1);

% Allocate the space for the windows we are going to get
% from the image.
W = zeros(NUM_WINDOWS, WIN_XSIZE, WIN_YSIZE, WIN_ZSIZE);

% We make space for the indices of the random windows as well.
Is = zeros(NUM_WINDOWS, 3);

for ii=1:NUM_WINDOWS

    % Choose a random point in the scan, this is the top left corner
    % of our random window.
    x = uint32( (rand() * (xsize - WIN_XSIZE - 1)) + 1);
    y = uint32( (rand() * (ysize - WIN_YSIZE - 1)) + 1);
    z = uint32( (rand() * (zsize - WIN_ZSIZE - 1)) + 1);
    if (xsize == WIN_XSIZE), x = 1; end
    if (ysize == WIN_YSIZE), y = 1; end
    if (zsize == WIN_ZSIZE), z = 1; end
    
    % Record the indices of the window
    Is(ii, :) = [x y z];
    
    % Copy the data from the image to our matrix of windows. 
    W(ii, :, :, :) = I(x:(x+WIN_XSIZE-1), y:(y+WIN_YSIZE-1), z:(z+WIN_ZSIZE-1)); 
           
end