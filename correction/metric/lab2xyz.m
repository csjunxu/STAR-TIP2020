function xyz = lab2xyz(lab,whitepoint,exp)
%lab2xyz(lab,whitepoint,exp)
%
% Converts colors in CIEL*a*b* coordinates into XYZ coordinates.
%
% lab should be in the form [L-plane a-plane b-plane]
% whitepoint is a 3-vector of the xyz values of the white point.
%   If not given, use [95.05 100 108.88] as default (not recommended).
% exp is the exponent used in the CIELAB formula. Default is cube
%   root as used in standard CIELAB. If specified, use the number
%   as exponent. (note this exponent here should be the same
%   as the exponent used in xyz2lab.m)
%
% xyz is returned as [x-plane y-plane z-plane].
%
% Created by Brian Wandell
% Last modified 4/15/98 by Xuemei Zhang

if (nargin<3)
  exp = 1/3;
end
exp = 1/exp;

if (nargin<2)
  disp('Using XYZ values of normalized D65 (95.05, 100, 108.88) as white point.');
  disp('You should really provide your own white point data to ensure reasonable results.');
  whitepoint = [95.05 100 108.88];
end

if length(whitepoint) ~= 3,
  error('White point is not a three-vector');
end

m = size(lab);
lab = reshape(lab, prod(m)/3, 3);

Xn = whitepoint(1);
Yn = whitepoint(2);
Zn = whitepoint(3);

% Usual formula for Lstar.   (y = Y/Yn)
fy = (lab(:,1) + 16)/116;
y = fy .^ exp;

% Find out cases where (Y/Yn) is too small and use other formula
% Y/Yn = 0.008856 correspond to L=7.9996
yy = find(lab(:,1)<=7.9996);
y(yy) = lab(yy,1)/903.3;
fy(yy) = 7.787 * y(yy) + 16/116;

% find out fx, fz
fx = lab(:,2)/500 + fy;
fz = fy - lab(:,3)/200;

% find out x=X/Xn, z=Z/Zn
% when (X/Xn)<0.008856, fx<0.206893
% when (Z/Zn)<0.008856, fz<0.206893
xx = find(fx<.206893);
zz = find(fz<.206893);
x = fx.^exp;
z = fz.^exp;
x(xx) = (fx(xx)-16/116)/7.787;
z(zz) = (fz(zz)-16/116)/7.787;

xyz = [x*Xn y*Yn z*Zn];

% return xyz in appropriate shape
xyz = reshape(xyz, m);


