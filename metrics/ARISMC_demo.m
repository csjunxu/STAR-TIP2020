
%==========================================================================
% 1) Please cite the paper (K. Gu, G. Zhai, W. Lin, X. Yang, and W. Zhang, 
% "No-reference image sharpness assessment in autoregressive parameter space,"
% IEEE Trans. Image Process., vol. 24, no. 10, pp. 3218-3231, 2015.)
% 2) If any question, please contact me through guke.doctor@gmail.com; 
% gukesjtuee@gmail.com. 
% 3) Welcome to cooperation, and I am very willing to share my experience.
%==========================================================================

% clear;
% clc;

I = imread('img.png');
score = ARISMC(I);
score(1) % Luminance component only
score(2) % Luminance and chromatic components
