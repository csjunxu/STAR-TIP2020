function [d, lab1, lab2] = deltaLab(xyz1, xyz2, whitepoint, exp, k94)
% [d, lab1, lab2] = deltaLab(xyz1, xyz2, whitepoint, exp, k94)
%
% xyz should be in the form [x-plane y-plane z-plane].
% whitepoint is a 3-vector of the xyz values of the white point.
%   If not given, use [95.5 100 108.9] as default (not recommended).
%
% exp is the exponent used in the formula. Default is the 
%   cube root used in standard CIELAB. If specified, use the number
%   as exponent.
% k94 is a vector with 3 elements, specifying some viewing
%   parameters. If k94 is provided, compute delta E94 instead of the standard
%   delta E, using the numbers in k94 as the k parameter (see
%   deltaE94). If k94 is only one number, use the default k=[1 1 1].
%
% Functions called: xyz2lab, deltaE94.
%
% Xuemei Zhang 10/26/95
% Last modified 4/15/98

if (nargin<4)
  exp = 1/3;
end

if (nargin<3)
  disp('Using XYZ values of normalized D65 (95.05, 100, 108.88) as white point.');
  disp('You should really provide your own white point data to ensure reasonable results.');
  whitepoint = [95.05 100 108.88];
end

m = size(xyz1);
if (m(2)~=3)
  xyz1 = reshape(xyz1, prod(m)/3, 3);
  xyz2 = reshape(xyz2, prod(m)/3, 3);
end

lab1 = xyz2lab(xyz1, whitepoint, exp);
lab2 = xyz2lab(xyz2, whitepoint, exp);

if (nargin>4)
  if (length(k94)<3)
    k94 = [1 1 1];
  end
%  disp('Computing CIE94 Delta E ...');
  d = deltaE94(lab1, lab2, k94);
else
%  disp('Computing standard Delta E ...');
  d = (lab1-lab2)';
  d = sqrt(sum(d.*d));
end

if (m(2)~=3)
  if (nargout > 1)
    lab1 = reshape(lab1, m);
    lab2 = reshape(lab2, m);
  end
  m(length(m)) = m(length(m))/3;
  d = reshape(d, m);
end
