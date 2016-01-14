function E = GetBoundariesMEX(Z)

B = regionboundariesmex(double(Z),4);

E = zeros(size(Z)); 
for ii=1:size(B, 1) 
    if(~isempty(B{ii})) 
        T = B{ii}; 
        for jj=1:size(T,1) 
            E(T(jj, 1), T(jj, 2)) = 1; 
        end; 
    end; 
end
