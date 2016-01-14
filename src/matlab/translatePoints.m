function P2 = translatePoints(P1, t)

P2 = P1;

for ii=1:size(P2, 1)
   P2(ii, :) = P2(ii, :) + t; 
end