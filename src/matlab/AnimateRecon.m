function [] = AnimateRecon(S_iters, filename)

    figure;

    nFrames = size(S_iters, 4);
    vidObj = VideoWriter(filename);
    vidObj.Quality = 100;
    vidObj.FrameRate = 10;
    open(vidObj);

    for ii=1:size(S_iters, 4)
        Snew = S_iters(:, :, :, ii);
        subplot(1,2,1)
        MID = ceil(size(Snew)/2);
        slice(Snew, [1 size(Snew,1)], [1 size(Snew,2)], [1 size(Snew,3)]); axis equal; axis tight; shading flat; box on; caxis([0 1]); colormap('gray');
        freezeColors;
        axis off;
        subplot(1,2,2);
        slice(Snew, MID(1), MID(2), MID(3)); axis equal; axis tight; shading flat; colormap('gray'); box on; caxis([0 1]);
        freezeColors;
        axis off;
        drawnow;
        writeVideo(vidObj, getframe(gcf));
    end

    close(gcf)

    %# save as AVI file, and open it using system video player
    close(vidObj);
    implay(filename);

end
