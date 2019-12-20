function lab = xyz2lab(xyz, whitepoint, exp)
% xyz2lab(xyz,whitepoint,exp)
%
% Converts colors in XYZ coordinates into CIEL*a*b* coordinates.
%
% xyz should be in the form [x-plane y-plane z-plane]
% whitepoint is a 3-vector of the xyz values of the white point.
%   If not given, use [95.05 100 108.88] as default (not recommended).
% exp is the exponent used in the formula. Default is the 
%   cube root used in standard CIELAB. If specified, use the number
%   as exponent.
%
% lab is returned as [L-plane a-plane b-plane].
%
% Formulae are taken from Wyszecki and Stiles, page 167.
%
% Created by Brian Wandell
% Last modified 4/15/96 by Xuemei Zhang

if (nargin<3)
  exp = 1/3;
end
if (nargin<2)
  disp('Using XYZ values of normalized D65 (95.05, 100, 108.88) as white point.');
  disp('You should really provide your own white point data to ensure reasonable results.');
  whitepoint = [95.05 100 108.88];
end

m = size(xyz);
xyz = reshape(xyz, prod(size(xyz))/3, 3);

if ( length(whitepoint)~=3 )
  error('whitepoint must be a three vector')
end

Xn = whitepoint(1); 
Yn = whitepoint(2); 
Zn = whitepoint(3);

x = xyz(:,1)/Xn;
y = xyz(:,2)/Yn;
z = xyz(:,3)/Zn;

% Find out points < 0.008856
xx = find(x <= 0.008856);
yy = find(y <= 0.008856);
zz = find(z <= 0.008856);

% allocate space
lab = zeros(size(xyz));

% compute L* values
% fx, fy, fz represent cases <= 0.008856
fy = y(yy);
y = y.^exp;
lab(:,1) = 116*y-16;
lab(yy, 1) = 903.3 * fy;

% compute a* b* values
fx = 7.787 * x(xx) + 16/116;
fy = 7.787 * fy + 16/116;
fz = 7.787 * z(zz) + 16/116;
x = x.^exp;
z = z.^exp;
x(xx) = fx;
y(yy) = fy;
z(zz) = fz;

lab(:,2) = 500 * (x - y);
lab(:,3) = 200 * (y - z);

% return lab in the appropriate shape
lab = reshape(lab, m);


