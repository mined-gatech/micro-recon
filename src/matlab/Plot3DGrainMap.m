function [] = Plot3DGrainMap(M, plot_index, cmap)

% The user did not specify a color map
if(nargin ~= 3)
    cmap = rand(length(min(M(:)):max(M(:))), 3);
    %cmap = colormap('jet');
end

[x,y,z] = meshgrid(1:size(M,1), 1:size(M,2), 1:size(M,3));
slice(x,y,z,M,[size(M,1)/2],[size(M,2)/2],[size(M,3)/2]); colormap(cmap); 
shading flat;

box on;
axis equal; axis tight;


% If the user has specified a plot index than annotate the image with that
% number
if(nargin > 1)
    mTextBox = uicontrol('style','text');
    set(mTextBox,'String',sprintf('%d', plot_index));
    set(mTextBox,'Units','characters')
    set(mTextBox, 'FontSize', 14, 'FontWeight', 'Bold');
end

