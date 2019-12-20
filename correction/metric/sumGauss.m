function g = sumGauss(params, dimension)
% g = sumGauss(params, dimension)
%
% Returns a matrix that is a weighted sum of several Gaussians.
% params is in the form [width, halfwidth1, weight1, halfwidth2, weight2, ...
%     halfwidth3, weight3, ...]
% dimension specifies whether the required sum of gaussians is 1-D or 2-D.
%     demension =1, 1-D; dimension = 2, 2-D. Defaults to 1.
%
% Functions called: gauss, gauss2
%
% Xuemei Zhang 10/24/95
% Last Modified 1/28/95

if (nargin<2)
  dimension = 1;
end

width = params(1);

numG = (length(params)-1)/2;

if (dimension==2)
  g = zeros(width, width);
else
  g = zeros(1, width);
end

for i=1:numG
  halfwidth = params(2*i);
  weight = params(2*i+1);
  if (dimension==2)
    g0 = gauss2(halfwidth, params(1), halfwidth, params(1));
  else
    g0 = gauss(halfwidth, params(1));
  end
  g = g + weight * g0;
end

