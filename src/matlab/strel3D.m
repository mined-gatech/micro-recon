function [se] = strel3D(radius)
    [x,y,z] = ndgrid(-radius:radius);
    se = strel(sqrt(x.^2 + y.^2 + z.^2) <= radius);
end
