function [np_error p_error CUT] = Run2PTConverge(A, NB_SIZE)

HALF_NB_SIZE = floor(NB_SIZE/2);


center = ceil(NB_SIZE/2);
D = zeros(NB_SIZE);
D(center, center) = 1;
D = round(bwdist(D)); 


[NB_Hoods NB_Lookup NB_Stats] = GetAllNHoods(A, NB_SIZE, 0, 1);
[NB_Hoods NB_Lookup NB_Stats_P] = GetAllNHoods(A, NB_SIZE, 1, 1);
c = ceil(size(A)/2);
G = twopointnp2(A); CUT = G(c(1)-HALF_NB_SIZE:c(1)+HALF_NB_SIZE, c(2)-HALF_NB_SIZE:c(2)+HALF_NB_SIZE);

EA = mean(NB_Stats)';
EA_P = mean(NB_Stats_P)';

cutT = 1;
np_error = rms(CUT(D == cutT) - EA(D == cutT));
p_error = rms(CUT(D == cutT) - EA_P(D == cutT));
fprintf(1, 'Non-Periodic-Error=%f\tPeriodic-Error=%f\n', np_error, p_error); 
