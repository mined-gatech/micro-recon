function [W Is]  = GetWindows2D(I, WIN_XSIZE, WIN_YSIZE, NUM_WINDOWS )
%GETWINDOWS2D Obtains a set of random windows of and input matrix.
%   This function creates a list of windows from a given matrix. The matrix
%   must be 2D.

% Seed the random number generator to a new value.
rand('twister',sum(100*clock))

ysize = size(I, 2);
xsize = size(I, 1);

% Allocate the space for the windows we are going to get
% from the image.
W = zeros(NUM_WINDOWS, WIN_XSIZE, WIN_YSIZE);

% We make space for the indices of the random windows as well.
Is = zeros(NUM_WINDOWS, 2);

for ii=1:NUM_WINDOWS

    % Choose a random point in the scan, this is the top left corner
    % of our random window.
    x = uint32( (rand() * (xsize - WIN_XSIZE - 1)) + 1);
    y = uint32( (rand() * (ysize - WIN_YSIZE - 1)) + 1);
   
    % Record the indices of the window
    Is(ii, :) = [x y];
    
    % Copy the data from the image to our matrix of windows. 
    W(ii, :, :) = I(x:(x+WIN_XSIZE-1), y:(y+WIN_YSIZE-1)); 
           
end
