function [] = AnalyzeIterationBW(Recon, S)

    h.fig = figure;
    h.Recon = Recon;
    h.S = S;

    NB_SIZE = Recon.NB_SIZE;
    HALF_NB_SIZE = floor(Recon.NB_SIZE/2);

    % Current voxel location we are inspecting
    xx=22;yy=22;zz=22;
    h.locText = uicontrol('Style','text','Position',[80 80 200 30],...
          'String',sprintf('%d %d %d', xx, yy, zz));

    function [] = PlotAll(h)
        set(h.locText, 'String', sprintf('%d %d %d', xx, yy, zz))

        Xnbi = h.Recon.NNB_Table(xx, yy, zz, 1);
        Ynbi = h.Recon.NNB_Table(xx, yy, zz, 2);
        Znbi = h.Recon.NNB_Table(xx, yy, zz, 3);

        if(Xnbi ~= -1) 
                XexNB = reshape(h.Recon.Exemplar_NBs{1}(Xnbi, :), [NB_SIZE NB_SIZE]); 
                XsNB = squeeze(h.S(xx-HALF_NB_SIZE:xx+HALF_NB_SIZE,yy-HALF_NB_SIZE:yy+HALF_NB_SIZE,zz));
        end
        if(Ynbi ~= -1) 
            YexNB = reshape(h.Recon.Exemplar_NBs{2}(Ynbi, :), [NB_SIZE NB_SIZE]); 
            YsNB = squeeze(h.S(xx,yy-HALF_NB_SIZE:yy+HALF_NB_SIZE,zz-HALF_NB_SIZE:zz+HALF_NB_SIZE));
        end
        if(Znbi ~= -1) 
            ZexNB = reshape(h.Recon.Exemplar_NBs{3}(Znbi, :), [NB_SIZE NB_SIZE]); 
            ZsNB = squeeze(h.S(xx-HALF_NB_SIZE:xx+HALF_NB_SIZE,yy,zz-HALF_NB_SIZE:zz+HALF_NB_SIZE));
        end

        subplot(3,2,1); cla;
        subplot(3,2,2); cla;
        subplot(3,2,3); cla;
        subplot(3,2,4); cla;
        subplot(3,2,5); cla;
        subplot(3,2,6); cla;

        if(Xnbi ~= -1)
            subplot(3,2,1); imagesc(XsNB); axis equal; axis tight; colormap('gray'); caxis([0 1]);
            subplot(3,2,2); imagesc(XexNB); axis equal; axis tight; colormap('gray'); caxis([0 1]);
        end
        if(Ynbi ~= -1)
            subplot(3,2,3); imagesc(YsNB); axis equal; axis tight;  colormap('gray'); caxis([0 1]);
            subplot(3,2,4); imagesc(YexNB); axis equal; axis tight;  colormap('gray'); caxis([0 1]);
        end
        if(Znbi ~= -1)
            subplot(3,2,5); imagesc(ZsNB); axis equal; axis tight;  colormap('gray'); caxis([0 1]);
            subplot(3,2,6); imagesc(ZexNB); axis equal; axis tight;  colormap('gray'); caxis([0 1]);
        end
 
        drawnow;

    end 

    function [] = keyDownListener(src, event, h)

        switch event.Key
          case 'a'
            xx = xx - 1;
            if(xx < 1)
                xx = 1;
            end
          case 'd'
            xx = xx + 1;
            if(xx > size(S,1))
                xx = size(S,1);
            end
          case 's'
            yy = yy - 1;
            if(yy < 1)
                yy = 1;
            end
          case 'w'
            yy = yy + 1;
            if(yy > size(S,2))
                yy = size(S,2);
            end
          case 'f'
            zz = zz - 1;
            if(zz < 1)
                zz = 1;
            end
          case 'r'
            zz = zz + 1;
            if(zz > size(S,3))
                zz = size(S,3);
            end

        end

        PlotAll(h);
    end

    PlotAll(h)

    set(h.fig,'KeyPressFcn',{@keyDownListener, h})

end
