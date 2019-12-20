function gauss = gauss2(halfWidthY, widthY, halfWidthX, widthX)
% gauss2(halfWidthY, widthY, halfWidthX, widthX)
%	Returns a 2D Gaussian matrix.  The gaussian sums to one.
%	The halfwidth must be greater than one.
%
% 
% The halfwidth specifies the width of the gaussian between the points
% where it obtains half of its maximum value.  The width indicates the
% gaussians width in pixels.
%
% Rick Anthony
% 8/24/93


if(nargin < 3)
    halfWidthX = halfWidthY;
    widthX = widthY;
end

alphaX = 2*sqrt(log(2))/(halfWidthX-1);
alphaY = 2*sqrt(log(2))/(halfWidthY-1);

%x = meshdom((1:widthX)-round(widthX/2), 1:widthY);
%y = meshdom((1:widthY)-round(widthY/2), 1:widthX)';
[x y] = meshgrid((1:widthX)-round(widthX/2),(1:widthY)-round(widthY/2));
r = sqrt(alphaX*alphaX*x.*x + alphaY*alphaY*y.*y);

gauss = exp(-r.*r);
gauss = gauss/sum(sum(gauss));
