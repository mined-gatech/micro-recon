function [G D] = GetNBStats(S, NB_SIZE)
 
    HALF_NB_SIZE = floor(NB_SIZE/2);

    [G D] = twopointnp2(S);
    %G = round(G .* D);
    
    cx = ceil(size(G,1)/2);
    cy = ceil(size(G,2)/2);
    
    G = G(cx-HALF_NB_SIZE:cx+HALF_NB_SIZE, cy-HALF_NB_SIZE:cy+HALF_NB_SIZE);
    D = D(cx-HALF_NB_SIZE:cx+HALF_NB_SIZE, cy-HALF_NB_SIZE:cy+HALF_NB_SIZE);