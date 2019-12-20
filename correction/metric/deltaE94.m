function de94 = deltaE94(lab1, lab2, k)
%
% de94 = deltaE94(lab1, lab2, k)
%
% The CIE94 color difference formula.
% K is a 3 vector, in the form [kL, kC, kH]. k =[1 1 1] for the basis
%   conditions (uniform surround field with L*=50, 1000lx illuminance,
%   homogeneous stimulus >4 degree visual angle, color difference between
%   0-5 CIELAB units). In the textile industry kL is commonly set to 2.
%   Default k is [1 1 1];
%
% Note that if the CIELAB difference between the two colors is substantial
% (greater than 5), then this formula does not apply.
%
% Based on formulae quoted in Berns' paper in Color Research and
% Application, Vol 21(6), 459-472.
%
% Xuemei Zhang  12/8/95
% Last modified 4/15/98

if (nargin<3)
 k = [1 1 1];
end

m = size(lab1);
if (m(2)~=3)
  lab1 = reshape(lab1, prod(m)/3, 3);
  lab2 = reshape(lab2, prod(m)/3, 3);  
end

% Compute Chroma Cab and Hue Hab differences
Cab1 = sqrt(lab1(:,2).*lab1(:,2) + lab1(:,3).*lab1(:,3));
Cab2 = sqrt(lab2(:,2).*lab2(:,2) + lab2(:,3).*lab2(:,3));
deltaC = Cab1 - Cab2;
clear Cab2;
deltaL = lab1(:,1) - lab2(:,1);
e = (lab1 - lab2).^2;
deltaE = sqrt(e(:,1) + e(:,2) + e(:,3));
deltaH = sqrt(deltaE.*deltaE - deltaL.*deltaL -deltaC.*deltaC);

% Computes the weighting functions. Cab is the chroma coordinate
% of the standard. Now this means the deltaV values are not
% symmetric (difference from A to B is different from difference
% of B and A). Keep this in mind. For now, I assume lab1 is the
% standard.
% in the report. 
sL = 1 + 0 * Cab1;
sC = 1 + 0.045*Cab1;
sH = 1 + 0.015*Cab1;
s = [sL sC sH];
clear Cab1;

% Now computes deltaV
e = [deltaL deltaC deltaH] ./ s * inv(diag(k));
e = e.*e;
de94 = sqrt(e(:,1)+e(:,2)+e(:,3));

if (m(2)~=3)
  m(length(m)) = m(length(m))/3;
  de94 = reshape(d, m);
end


