function [G2] = UpdateStats(I, G1, xs, ys, vals)

    G2 = G1;
    szX = size(G2, 1);
    szY = size(G2, 2);
    cx=((szX-1)+mod((szX-1),2))/2;
    cy=((szY-1)+mod((szY-1),2))/2;
    cx = ceil(size(G2, 1) / 2);
    cy = ceil(size(G2, 2) / 2);

    
    for pp=1:length(vals)
        x = xs(pp);
        y = ys(pp);
        val = vals(pp);
        
        for ii=1:size(G2, 1)
            for jj=1:size(G2, 2)
                ti = cx + (ii - x);
                tj = cy + (jj - y);
                ti_sym = cx - (ii - x);
                tj_sym = cy - (jj - y);

                if(ti < 1 || ti > size(G2, 1) || tj < 1 || tj > size(G2, 2))
                    continue;
                end
                if(ti_sym < 1 || ti_sym > size(G2, 1) || tj_sym < 1 || tj_sym > size(G2, 2))
                    continue;
                end

                if(ti == cx && tj == cy)
                    G2(ti, tj) = G2(ti, tj) - I(x,y)^2 + val^2;
                else
                    G2(ti, tj) = G2(ti, tj) + I(ii,jj)*(val - I(x, y));
                    G2(ti_sym, tj_sym) = G2(ti_sym, tj_sym) + I(ii,jj)*(val - I(x, y));
                end

            end
        end
        
        I(x, y) = val;
    end
    %G2(cx, cy) = G2(cx, cy) - I(x, y)^2;
    %G2(cx, cy) = G2(cx, cy) + val^2;
    
    %G2 = G1 - I .* I(x, y);    
    %G2 = G2 + I .* val * 2;
   
%     I2 = I;
%     I2(x, y) = val;
%     G3 = twopointnp2(I2);
%     sum(abs(G2(:) - G3(:)))
%     
end