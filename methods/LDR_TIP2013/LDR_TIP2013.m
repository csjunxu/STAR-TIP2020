function out_RGB = LDR_TIP2013( in_RGB, alpha, U )

% -------------------------------------------------------------------------
% An implementation of
%   C. Lee, C. Lee, and Chang-Su Kim, "Contrast enahancement based on
%   layered difference representation of 2D histograms," IEEE Trans.
%   Image Process., vol. 22, no. 12, pp. 5372-5384, Dec. 2013
%
% -------------------------------------------------------------------------
% Input variables (see the paper for details)
%   src_data : can be either 2D histogram or gray scale image. This script
%   automatically detects based on its dimension.
%   alpha    : controls the level of enhancement
%   U        : U matrix in Equation (31). If it is provided, we can save
%   the computation time.
%
% Output variables
%   x    : Output transformation function.
%
% -------------------------------------------------------------------------
%                           written by Chulwoo Lee, chulwoo@mcl.korea.ac.kr


if nargin < 3
    % Pre-computing
    U = zeros(255,255);
    tmp_k = 1:255;
    for layer=1:255
        U(:,layer) = min(tmp_k,256-layer) - max(tmp_k-layer,0);
    end
end

if nargin < 2
    alpha = 2.5;
end

[R,C,~] = size(in_RGB);

[in_Y, in_U, in_V] = rgb2yuv(in_RGB(:,:,1), in_RGB(:,:,2), in_RGB(:,:,3));
in_Y = double(in_Y);


if R==256 && C==256
    h2D_in = in_Y;
else
    % unordered 2D histogram acquisition
    h2D_in = zeros(256,256);
    
    for j=1:R
        for i=1:C
            ref = in_Y(j,i);
            
            if j~=R
                trg = in_Y(j+1,i);
                h2D_in(max(trg,ref)+1,min(trg,ref)+1) = h2D_in(max(trg,ref)+1,min(trg,ref)+1) + 1;
            end
            
            if i~=C
                trg = in_Y(j,i+1);
                h2D_in(max(trg,ref)+1,min(trg,ref)+1) = h2D_in(max(trg,ref)+1,min(trg,ref)+1) + 1;
            end
        end
    end
    clear ref trg
end


%% Intra-Layer Optimization
D = zeros(255,255);
s = zeros(255,1);


% iteration start
for layer = 1:255
    
    h_l = zeros(256-layer,1);
    
    tmp_idx = 1;
    for j=1+layer:256
        i=j-layer;
        
        h_l(tmp_idx,1) = log(h2D_in(j,i)+1);    % Equation (2)
        tmp_idx = tmp_idx+1;
    end
    clear tmp_idx
    
    s(layer,1) = sum(h_l);
    
    % if all elements in h_l is zero, then skip
    if s(layer,1) == 0
        continue
    end
    
    % Convolution
    m_l = conv(h_l, ones(layer,1));             % Equation (30)
    
    d_l = (m_l - min(m_l))./U(:,layer);         % Equation (33)
    
    if sum(d_l) == 0
        continue
    end
    D(:,layer) = d_l/sum(d_l);
    
end


%% Inter-Layer Aggregation
W = (s/max(s)).^alpha;                          % Equation (23)
d = D*W;                                        % Equation (24)


%% reconstruct transformation function
d = d/sum(d);       % normalization
tmp = zeros(256,1);
for k=1:255
    tmp(k+1) = tmp(k) + d(k);
end

x = 255*tmp;
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



