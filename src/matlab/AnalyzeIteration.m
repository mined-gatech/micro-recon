function [] = AnalyzeIteration(Recon, Sgrain, S)

    h.fig = figure;
    h.Recon = Recon;
    h.Sgrain = Sgrain;
    h.S = S;
    EdgeOn = 0;

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
            if(EdgeOn)
                XexNB = reshape(h.Recon.Exemplar_NBs_Edges{1}(Xnbi, :), [13 13]); 
                XsNB = squeeze(h.S(xx-6:xx+6,yy-6:yy+6,zz));
            else
                XexNB = reshape(h.Recon.Exemplar_NBs{1}(Xnbi, :), [13 13]); 
                XsNB = squeeze(h.Sgrain(xx-6:xx+6,yy-6:yy+6,zz));
            end
        end
        if(Ynbi ~= -1) 
            if(EdgeOn)
                YexNB = reshape(h.Recon.Exemplar_NBs_Edges{2}(Ynbi, :), [13 13]); 
                YsNB = squeeze(h.S(xx,yy-6:yy+6,zz-6:zz+6));
            else
                YexNB = reshape(h.Recon.Exemplar_NBs{2}(Ynbi, :), [13 13]); 
                YsNB = squeeze(h.Sgrain(xx,yy-6:yy+6,zz-6:zz+6));
            end
        end
        if(Znbi ~= -1) 
            if(EdgeOn)
                ZexNB = reshape(h.Recon.Exemplar_NBs_Edges{3}(Znbi, :), [13 13]); 
                ZsNB = squeeze(h.S(xx-6:xx+6,yy,zz-6:zz+6));
            else
                ZexNB = reshape(h.Recon.Exemplar_NBs{3}(Znbi, :), [13 13]); 
                ZsNB = squeeze(h.Sgrain(xx-6:xx+6,yy,zz-6:zz+6));
            end
        end

        subplot(3,2,1); cla;
        subplot(3,2,2); cla;
        subplot(3,2,3); cla;
        subplot(3,2,4); cla;
        subplot(3,2,5); cla;
        subplot(3,2,6); cla;

        if(Xnbi ~= -1)
            subplot(3,2,1); imagesc(XsNB); axis equal; axis tight; caxis([0 3000]); rng(1); colormap(rand(3000,3)); 
            subplot(3,2,2); imagesc(XexNB); axis equal; axis tight; caxis([0 3000]); rng(1); colormap(rand(3000,3)); 
        end
        if(Ynbi ~= -1)
            subplot(3,2,3); imagesc(YsNB); axis equal; axis tight; caxis([0 3000]); rng(1); colormap(rand(3000,3)); 
            subplot(3,2,4); imagesc(YexNB); axis equal; axis tight; caxis([0 3000]); rng(1); colormap(rand(3000,3)); 
        end
        if(Znbi ~= -1)
            subplot(3,2,5); imagesc(ZsNB); axis equal; axis tight; caxis([0 3000]); rng(1); colormap(rand(3000,3)); 
            subplot(3,2,6); imagesc(ZexNB); axis equal; axis tight; caxis([0 3000]); rng(1); colormap(rand(3000,3)); 
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
            if(xx > size(Sgrain,1))
                xx = size(Sgrain,1);
            end
          case 's'
            yy = yy - 1;
            if(yy < 1)
                yy = 1;
            end
          case 'w'
            yy = yy + 1;
            if(yy > size(Sgrain,2))
                yy = size(Sgrain,2);
            end
          case 'f'
            zz = zz - 1;
            if(zz < 1)
                zz = 1;
            end
          case 'r'
            zz = zz + 1;
            if(zz > size(Sgrain,3))
                zz = size(Sgrain,3);
            end
          case 'b'
              EdgeOn = ~EdgeOn; 

        end

        PlotAll(h);
    end

    PlotAll(h)

    set(h.fig,'KeyPressFcn',{@keyDownListener, h})

end
