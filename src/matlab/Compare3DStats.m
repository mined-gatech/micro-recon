function [] = Compare3DStats(S3, S9, WTM)

    ROW_LABELS = {'X', 'Y', 'Z'};

    ax = -(size(S3,1)/2):((size(S3,1)/2)-1);
    
    G3 = twopointnp3(S3);
    G9 = twopointnp3(S9);

    
    CMAX = max([WTM(:)', G3(:)', G9(:)']); 
    CMIN = min([WTM(:)', G3(:)', G9(:)']); 
    CMIN = 0;

    M = 3;
    N = 3;
    args = {'Spacing', 0, 'PaddingBottom', 0.05, 'MarginTop', 0.1, 'MarginBottom', 0};
    figure;
    set(gcf, 'Position', [ 63    52   938   630]);
    subaxis(M, N, 1, args{:});
    for ii=1:3

        if(ii == 1)
            T = WTM(:,:,75);
            T3 = squeeze(G3(:, :, 75));
            T9 = squeeze(G9(:, :, 75));
        
        elseif(ii == 2)
            T = squeeze(WTM(:,75,:));
            T3 = squeeze(G3(:,75,:));
            T9 = squeeze(G9(:,75,:));
        
        else
            T = squeeze(WTM(75,:,:));
            T3 = squeeze(G3(75,:,:));
            T9 = squeeze(G9(75,:,:));     
        end

        subaxis(M, N, (ii-1)*N+1, args{:});
        Plot2Point(T, 1, 35, 35);
        %pcolor(ax, ax, T); 
        axis equal; axis tight; 
        shading flat; 
        set(gca, 'FontSize', 14, 'FontWeight', 'Bold');
        caxis([CMIN CMAX]);
        
        if(ii == 1)
           title('Sample', 'FontSize', 18, 'FontWeight', 'Bold');
        end

        ylabel(ROW_LABELS{ii}, 'FontSize', 18, 'FontWeight', 'Bold');
        
        subaxis(M, N, (ii-1)*N+2, args{:}); 
        Plot2Point(T3, 1, 35, 35);
        %pcolor(ax, ax, T3); 
        shading flat; 
        caxis([CMIN CMAX]); 
        set(gca, 'FontSize', 14, 'FontWeight', 'Bold');
        axis equal; axis tight;

        if(ii == 1)
           title({'Reconstruction','(3 Slices)'}, 'FontSize', 18, 'FontWeight', 'Bold');
        end
        
        subaxis(M, N, (ii-1)*N+3, args{:}); 
        Plot2Point(T9, 1, 35, 35);
        %pcolor(ax, ax, T9); 
        shading flat; 
        caxis([CMIN CMAX]); 
        set(gca, 'FontSize', 14, 'FontWeight', 'Bold');
        axis equal; axis tight;
        
        if(ii == 1)
           title({'Reconstruction','(9 Slices)'}, 'FontSize', 18, 'FontWeight', 'Bold');
        end

    end

    %colorbar('peer',gca,...
    %[0.842606149341142+.05 0.228028503562946 0.0131771595900439 0.562945368171023],...
    %'FontSize', 14, 'FontWeight', 'Bold');

    
end