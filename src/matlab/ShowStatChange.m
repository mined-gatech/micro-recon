function [] = ShowStatChange(Sold, Snew, NB_SIZE, CS)

    HALF_NB_SIZE = floor(NB_SIZE/2);

    [cx cy] = ind2sub(size(Snew), find(Snew ~= Sold));
    [cx cy]

    NBnew = Snew(cx-HALF_NB_SIZE:cx+HALF_NB_SIZE, cy-HALF_NB_SIZE:cy+HALF_NB_SIZE);
    NBold = Sold(cx-HALF_NB_SIZE:cx+HALF_NB_SIZE, cy-HALF_NB_SIZE:cy+HALF_NB_SIZE);
    
    subplot(2,2,1);
    imagesc(NBold); axis equal; axis tight;
    colorbar
    
    subplot(2,2,2);
    imagesc(NBnew); axis equal; axis tight;
    colorbar
    
    [oldStats TN] = GetNBStats(Sold, 7);
    [newStats TN] = GetNBStats(Snew, 7);
    
    subplot(2,2,3);
    T1 = oldStats-newStats;
    imagesc(T1);axis equal; axis tight;
    title('Old - New');
    colorbar;
    
    if(nargin > 3)
        T2 = oldStats - CS;
        caxis([min([T1(:)' T2(:)']) max([T1(:)' T2(:)'])]);
        subplot(2,2,4);
        imagesc(T2); axis equal; axis tight;
        colorbar
        caxis([min([T1(:)' T2(:)']) max([T1(:)' T2(:)'])]);
        title('Old - Current');
    end
    