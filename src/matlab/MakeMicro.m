function [V] = MakeMicro(sz, NUM_POINTS, isPeriodic)

if(nargin < 3)
    isPeriodic = false;
end

PAD = [10 10 10];

% Volume of pad region as a percentage of total volume
%vpad = (prod(sz+2*PAD) - prod(sz))/prod(sz+2*PAD);

% Now we only want to generate enough points to fill the unpadded region
%NUM_POINTS = round((1-vpad)*NUM_POINTS);


if(isPeriodic)


    centers = zeros(NUM_POINTS, 3);
    i4_sobol(3, 0);
    seed = randi(50000,1);
    for jj=1:NUM_POINTS
        [r seed] = i4_sobol(3, seed);
        centers(jj, :) = round(r.*(sz - 1)+sz) + 1;
    end

    
    % Now we have a set of grain centers. We want to make the microstructure
    % periodic so what we do is copy all the cubes to the surrounding vertical,
    % horizontal, and diagonal cubes and construct the voronoi tesselation on
    % this set of points. We will then simply extract the center.
    nhood = getneighbors(strel(ones(3,3,3)));
    ncenters = zeros(NUM_POINTS*size(nhood,1), 3);

    % For each of the 27 cube neighbors. Translate the points to that cube
    kk = 1;
    for ii=1:size(nhood, 1)
        ncenters(kk:kk+NUM_POINTS-1, :) = translatePoints(centers, nhood(ii, :).*sz);
        kk = kk + NUM_POINTS;
    end

    M = zeros(sz*3);
    site_map = zeros(sz*3);
    for ii=1:size(ncenters, 1)
       M(ncenters(ii, 1), ncenters(ii, 2), ncenters(ii, 3)) = 1; 
       site_map(ncenters(ii, 1), ncenters(ii, 2), ncenters(ii, 3)) = mod(ii, NUM_POINTS);
    end

    % Chop a lot of points off this because it is way bigger than needed
    stx = round(size(M,1)/2)-round(sz(1)/2)-PAD(1); 
    sty = round(size(M,2)/2)-round(sz(2)/2)-PAD(2); 
    stz = round(size(M,3)/2)-round(sz(3)/2)-PAD(3); 
    M = M(stx:stx+sz(1)+2*PAD(1), sty:sty+sz(2)+2*PAD(2), stz:stz+sz(3)+2*PAD(3)); 
    site_map = site_map(stx:stx+sz(1)+2*PAD(1), sty:sty+sz(2)+2*PAD(2), stz:stz+sz(3)+2*PAD(3)); 

    num_sites = sum(M(:));

    % Compute the voronoi diagram
    fprintf(1, 'Computing Voronoi Diagram (Dimemsions=[%d, %d, %d], NumSites=%d) ... ', size(M,1), size(M,2), size(M,3), num_sites);
    [D V] = bwdist(M);
    fprintf(1, 'Done.\n');

    V = double(V);

    % Renumbering pixels
    for ii=1:numel(V)
        V(ii) = site_map(V(ii)); 
    end

    % Cut out the center
    stx = round(size(M,1)/2)-round(sz(1)/2); 
    sty = round(size(M,2)/2)-round(sz(2)/2); 
    stz = round(size(M,3)/2)-round(sz(3)/2); 
    V = V(stx:stx+sz(1), sty:sty+sz(2), stz:stz+sz(3)); 
    site_map = site_map(stx:stx+sz(1), sty:sty+sz(2), stz:stz+sz(3)); 

    V = V + 1;

else

    
    centers = zeros(NUM_POINTS, 3);
    i4_sobol(3, 0);
    seed = randi(50000,1);
    for jj=1:NUM_POINTS
        [r seed] = i4_sobol(3, seed);
        centers(jj, :) = round(r.*(sz - 1)) + 1;
    end
    
    M = zeros(sz);
    site_map = zeros(sz);
    for ii=1:size(centers, 1)
       M(centers(ii, 1), centers(ii, 2), centers(ii, 3)) = 1; 
       site_map(centers(ii, 1), centers(ii, 2), centers(ii, 3)) = mod(ii, NUM_POINTS);
    end
    
    [D V] = bwdist(M);
    
    V = double(V);
    
    V = V + 1;
    
    ids = unique(V(:));
    
    B = -1;
    for ii=1:length(ids)
        val = ids(ii);
        allII = (V == val);
        V(allII) = repmat(B, [1, sum(allII(:))]);
        B = B - 1;
    end
    V = abs(V);

end
