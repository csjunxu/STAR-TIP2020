function out_RGB = WAHE_TIP2009( in_RGB, g, Threshold )

% -------------------------------------------------------------------------
% An implementation of "Weighted Approximated Histogram Equalization."
%   T. Arici, S. Dikbas, and Y. Altunbasak, "A histogram modification
%   framework and its application for image contrast enhancement," IEEE
%   Trans. Image Process., vol. 18, no. 9, pp. 1921-1935, Sep. 2009.
%
% -------------------------------------------------------------------------
% Input variables
%   f        : Input gray scale image, single channel
%   g        : Level of Enhancement
%   Threshold: See the paper for details
%
% Output variables
%   x    : Output transformation function.
%   pdf  : Probability mass function of input pixel intensities, or
%   equivalently normalized histogram vector.
% 
% -------------------------------------------------------------------------
%                           written by Chulwoo Lee, chulwoo@mcl.korea.ac.kr


if nargin < 3
    Threshold = 2;
end

[R,C,~] = size(in_RGB);

[in_Y, in_U, in_V] = rgb2yuv(in_RGB(:,:,1), in_RGB(:,:,2), in_RGB(:,:,3));
in_Y = double(in_Y);


%% WAHE
kappa = 0;                      % initialize kappa
count = 0;                      % initialize count
h = zeros(256,1);
for m=1:R
    for n=3:C
        temp = in_Y(m,n) - in_Y(m,n-2);
        kappa = kappa + abs(temp);
        if abs(temp) > Threshold
            h(in_Y(m,n)+1) = h(in_Y(m,n)+1) + 1;
            count = count + 1;
        end
    end
end

kappa_star = 1/(1+g);
u = count/256;                  % uniform

% We do not apply B&W stretch.
h_tilda = zeros(256,1);
for n = 1:256
    h_tilda(n) = (1-kappa_star)*u + kappa_star * h(n);
end


%% reconstruct transformation function
pdf = h_tilda/sum(h_tilda);

cdf = zeros(length(h_tilda),1); cdf(1) = pdf(1);
for k=2:length(h_tilda)
    cdf(k) = cdf(k-1) + pdf(k);
end

x = 255*cdf;

%%
LDR_Y = zeros(R,C);
for j=1:R
    for i=1:C
        LDR_Y(j,i) = round( x(in_Y(j,i)+1,1) );
    end
end
out_RGB = yuv2rgb(LDR_Y, in_U, in_V);

end

function [ Y, U, V ] = rgb2yuv( R, G, B )

T = [0.2126 0.7152 0.0722; -0.1146 -0.3854 0.5; 0.5 -0.4542 -0.0468];

R = double(R);
G = double(G);
B = double(B);

Y = T(1,1) * R + T(1,2) * G + T(1,3) * B;
U = T(2,1) * R + T(2,2) * G + T(2,3) * B + 128;
V = T(3,1) * R + T(3,2) * G + T(3,3) * B + 128;

Y = uint8(round(Y));
U = uint8(round(U));
V = uint8(round(V));

end

function rgb = yuv2rgb(Y,U,V)

Y = double(Y);
U = double(U) - 128;
V = double(V) - 128;

T = inv([0.2126 0.7152 0.0722; -0.1146 -0.3854 0.5; 0.5 -0.4542 -0.0468]);
rgb = zeros(size(Y,1),size(Y,2),3);

rgb(:,:,1) = T(1,1) * Y + T(1,2) * U + T(1,3) * V;
rgb(:,:,2) = T(2,1) * Y + T(2,2) * U + T(2,3) * V;
rgb(:,:,3) = T(3,1) * Y + T(3,2) * U + T(3,3) * V;
rgb = uint8(round(rgb));

end



