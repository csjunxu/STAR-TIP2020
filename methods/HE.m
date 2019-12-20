function [ x, pdf ] = HE( src_data, bit_depth )

% -------------------------------------------------------------------------
% An implementation of "Histogram Equalization."
% -------------------------------------------------------------------------
% Input variables
%   src_data : can be either 1D histogram or gray scale image. This script
%   automatically detects based on its dimension.
%   bit_depth: Also, you can specify bit depth, e.g. 2^8=256.
%
% Output variables
%   x    : Output transformation function.
%   pdf  : Probability mass function of input pixel intensities, or
%   equivalently normalized histogram vector.
% 
% -------------------------------------------------------------------------
%                           written by Chulwoo Lee, chulwoo@mcl.korea.ac.kr


if nargin < 2
    bit_depth = 8;
end


[R, C] = size(src_data);
if R==1 || C==1
    hist_in = src_data;
else
    in_Y = src_data;
    
    hist_in = zeros(256,1);

    for j=1:R
        for i=1:C
            ref = in_Y(j,i);

            hist_in(ref+1,1) = hist_in(ref+1,1) + 1;
        end
    end
    clear ref
end


%% HE
pdf = hist_in / sum(hist_in);

cdf = zeros(length(hist_in),1);     cdf(1,1) = pdf(1,1);
for t = 2:length(hist_in)
    cdf(t,1) = cdf(t-1,1) + pdf(t,1);
end

x = (2^bit_depth-1)*cdf;


end

