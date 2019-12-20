function result = visualAngle(numpixels, viewdist, dpi, va)
%
% result = visualAngle(numpixels, viewdist, dpi, va)
%
% Computes the visual angle corresponding to a displayed size on a monitor,
%   or computes any of numpixels, viewdist, dpi when others are given. 
% The unkown (to be computed) variable's value should be given as -1.
%   It's value will be computed according to other variable's values and 
%   returned as the result.
% If va is not given, it is taken as the unknown.
%
% For example:
%   visualAngle(20, 12, 72) will return the visual angle spanned by 
%         20 pixels on a 72dpi display at 12 inch viewing distance;
%   visualAngle(-1, 12, 72, 5) will return the number of pixels needed
%         to span 5 degrees visual angle on a 72dpi display at 12 inch 
%         viewing distance.
%
% Viewdist is in inches.
% Va is in degrees (of angle).
% Dpi is the dot-per-inch of the monitor. Defaults to 90.
%
% Xuemei Zhang  12/8/95
% Last modified 6/26/96

if (nargin<4)
  va = -1;
end
if (nargin<3)
  dpi = 90;
end

% Check to make sure there is only one unknown
pixOK = (numpixels<0 & length(numpixels)==1);
distOK = (viewdist<0 & length(viewdist)==1);
dpiOK = (dpi<0 & length(dpi)==1);
vaOK = (va<0 & length(va)==1);

check = sum([pixOK distOK dpiOK vaOK]);
if (check~=1) 
  error('Must have exactly one unknown (only one argument can be -1).');
end

% Let s be the size of the image in inches

if (vaOK | distOK)
  s = numpixels/dpi;     
  if (vaOK)
    result = atan(s/viewdist) * 180/pi;
  else
    result = s/tan(va * pi/180);
  end
else
  s = viewdist * tan(va*pi/180);
  if (pixOK)
    result = dpi * s;
  else
    result = numpixels/s;
  end
end

