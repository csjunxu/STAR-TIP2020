function score = DE(Im)
% DE (Discrete Entropy) 
% C. E. Shannon, "A mathematical theory of communication," 
% Bell Syst. Tech. J., vol. 27, pp. 623-656, Oct. 1948.

% Z. Ye, H. Mohamadian, and Y. Ye, “Discrete entropy and relative entropy
% study on nonlinear clustering of underwater and arial images,” in Proc.
% IEEE Int. Conf. Control Appl., Oct. 2007, pp. 318–323.

% -------------------------------------------------------------------------
% Input variables
%   Im  : input gray scale image, single channel.
% -------------------------------------------------------------------------

if size(Im, 3) == 3
    Im = rgb2gray(Im);
end
[R, C] = size(Im);
%% Quality measures

h_in = zeros(256,1);

for j=1:R
    for i=1:C
        ref = Im(j,i);
        
        h_in(ref+1,1) = h_in(ref+1,1) + 1;
    end
end
clear ref

p_in = h_in/sum(h_in);
tmp_sum = 0;
for k=1:256
    if p_in(k,1) == 0
        continue
    else
        tmp_sum = tmp_sum - p_in(k,1)*log2(p_in(k,1));
    end
end

score = tmp_sum;
clear tmp_sum

