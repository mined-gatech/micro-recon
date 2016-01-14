function FZ_angles = RotateToCubicFZ(angles)

cs = symmetry('cubic');
ss = symmetry('triclinic');
o = orientation('Euler', angles(:,1), angles(:,2), angles(:,3), cs, ss);

FZ_angles = zeros(size(angles));

for ii=1:size(angles, 1)
   
    % Get symetrically equivalent angles
   [phi1,PHI,phi2] = Euler(symmetrise(o(ii)));
   sym_ors = [phi1 PHI phi2];
    
   PHI_lower_bound = acos(cos(phi2)./sqrt(1+cos(phi2).^2));
   
   phi1_check = phi1 > 0 & phi1 < 2*pi;
   phi2_check = phi2 >= 0 & phi2 <= pi/4;
   PHI_check = PHI >= PHI_lower_bound & PHI <= pi/2;
   
   all_checks = phi1_check & PHI_check & phi2_check;
   
   if(sum(all_checks) > 1)
       rad2deg(sym_ors(all_checks, :))  
   else
       FZ_angles(ii, :) = sym_ors(all_checks, :);
   end
   
end
