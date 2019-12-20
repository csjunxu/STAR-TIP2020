function score = PixDist(Im)
% PixDist: Z. Chen, B. R. Abidi, D. L. Page, and M. A. Abidi, "Gray-level
% grouping (GLG): An automatic method for optimized image contrast
% enhanceemnt-part I: The basic method," IEEE Trans. Image Process., vol.
% 15, no. 8, pp. 2290-2302, Aug. 2006.
% -------------------------------------------------------------------------
% Input variables
%   Im  : input gray scale image, single channel.
% -------------------------------------------------------------------------
if size(Im, 3) == 3
    Im = rgb2gray(Im);
end
[R, C] = size(Im);
h_in = zeros(256,1);

for j=1:R
    for i=1:C
        ref = Im(j,i);
        
        h_in(ref+1,1) = h_in(ref+1,1) + 1;
    end
end
clear ref

tmp_sum = 0;
for j=1:256
    for i=j:256
        tmp_sum = tmp_sum + h_in(j)*h_in(i)*(i-j);
    end
end

score = tmp_sum/(R*C*(R*C-1));