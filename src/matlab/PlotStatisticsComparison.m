function [] = PlotStatisticsComparison(WT, WTM, ds, S_star3, S_star9)
    
    figure;
    hist(ds, 30);

    G3 = twopointnp3(S_star3);
    G9 = twopointnp3(S_star9);

    d3 = mean( (WTM(:) - G3(:)).^2 ); 
    d9 = mean( (WTM(:) - G9(:)).^2 ); 

    d3
    d9

    hold on;
    ylim=get(gca,'ylim');

    line([d3 d3], ylim, 'Color','r');
    line([d9 d9], ylim, 'Color','g');

    set(gca, 'FontSize', 16);

end
