function score = EME(Im)
% EME (Measure of Enhancement): S. Again, B. Silver, and K. Panetta,
% "Transform coefficient histogram-based image enhancement algorithms using
% contrast entropy," IEEE Trans. Image Process., vol. 16, no. 3, pp.
% 741-758, Mar. 2007.
% -------------------------------------------------------------------------
% Input variables
%   Im  : input gray scale image, single channel.
%   w = 8 : window size for EME
% -------------------------------------------------------------------------
if size(Im, 3) == 3
    Im = rgb2gray(Im);
end
[R, C] = size(Im);
w = 8;      % window size for EME
tmp_sum = 0;
for j=1:R/w
    for i=1:C/w
        
        J = (j-1)*w + 1;
        I = (i-1)*w + 1;
        
        tmp_block = Im(J:J+w-1, I:I+w-1);
        
        block_max = max(tmp_block(:));
        block_min = min(tmp_block(:));
        
        if block_max ==  block_min
            continue
        else
            tmp_sum = tmp_sum + 20*log(block_max/(block_min+1e-4));
        end
    end
end

score = tmp_sum/(R*C)*w^2;

clear tmp_sum