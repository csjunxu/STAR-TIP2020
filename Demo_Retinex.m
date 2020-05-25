% Retinex theory is a color perception model of human vision and is
% used to remove illumination effects in images. The primary goal
% of Retinex is to decompose the observed images into illumination
% and reflectance.

clc;clear;
%%% methods
addpath(genpath('methods'));
%%% choose test dataset  
datasets = {'Figure4', '35images', '200images'};
Testset = datasets{1}; % select test dataset
Test_dir = fullfile('C:\Users\csjunxu\Desktop\star\', Testset);
%%% read images
ext         =  {'*.jpg','*.jpeg','*.png','*.bmp'};
im_dir   =  [];
for i = 1 : length(ext)
    im_dir = cat(1,im_dir, dir(fullfile(Test_dir,ext{i})));
end
im_num = length(im_dir);

%%% save results
N=4;
name = regexp(im_dir(N).name, '\.', 'split');
Im=im2double( imread(fullfile(Test_dir, im_dir(N).name)) );
write_dir = '../STAR-Results/';
if ~isdir(write_dir)
    mkdir(write_dir);
end
imwrite(Im, [write_dir name{1} '.png'])

% Baseline
method = 'Baseline';
alpha = 0.001;
beta = 0.0001;
for pI = [1]
    for pR = [1]
        [I, R] = STAR(Im, alpha, beta, pI, pR);
        hsv = rgb2hsv(Im);
        subplot(2,2,1); imshow(I);  title('Illumination (Gray)');
        %imwrite(I, [write_dir name{1} '_I_Gray_' method '_pI' num2str(pI) '_pR' num2str(pR) '.png'])
        hsv(:,:,3) = I;
        subplot(2,2,2); imshow(hsv2rgb(hsv));  title('Illumination (RGB)');
        imwrite(hsv2rgb(hsv), [write_dir name{1} '_I_RGB_' method '_pI' num2str(pI) '_pR' num2str(pR) '.png'])
        subplot(2,2,3); imshow(I);  title('Reflectance (Gray)');
        %imwrite(R, [write_dir name{1} '_R_Gray_' method '_pI' num2str(pI) '_pR' num2str(pR) '.png'])
        hsv(:,:,3) = R;
        subplot(2,2,4); imshow(hsv2rgb(hsv));  title('Reflectance (RGB)');
        imwrite(hsv2rgb(hsv), [write_dir name{1} '_R_RGB_' method '_pI' num2str(pI) '_pR' num2str(pR) '.png'])
    end
end

% STAR
method = 'STAR';
alpha = 0.001;
beta = 0.0001;
for pI = [1.5]
    for pR = [0.5]
        [I, R] = STAR(Im, alpha, beta, pI, pR);
        hsv = rgb2hsv(Im);
        subplot(2,2,1); imshow(I);  title('Illumination (Gray)');
        %imwrite(I, [write_dir name{1} '_I_Gray_' method '_pI' num2str(pI) '_pR' num2str(pR) '.png'])
        hsv(:,:,3) = I;
        subplot(2,2,2); imshow(hsv2rgb(hsv));  title('Illumination (RGB)');
        imwrite(hsv2rgb(hsv), [write_dir name{1} '_I_RGB_' method '_pI' num2str(pI) '_pR' num2str(pR) '.png'])
        subplot(2,2,3); imshow(I);  title('Reflectance (Gray)');
        %imwrite(R, [write_dir name{1} '_R_Gray_' method '_pI' num2str(pI) '_pR' num2str(pR) '.png'])
        hsv(:,:,3) = R;
        subplot(2,2,4); imshow(hsv2rgb(hsv));  title('Reflectance (RGB)');
        imwrite(hsv2rgb(hsv), [write_dir name{1} '_R_RGB_' method '_pI' num2str(pI) '_pR' num2str(pR) '.png'])
    end
end

% JIEP ICCV2017
method = 'JieP';
[I, R] = jiep(Im);
hsv = rgb2hsv(Im);
subplot(2,2,1); imshow(I);  title('Illumination (Gray)');
imwrite(I, [write_dir name{1} '_I_Gray_' method '.png'])
hsv(:,:,3) = I;
subplot(2,2,2); imshow(hsv2rgb(hsv));  title('Illumination (RGB)');
imwrite(hsv2rgb(hsv), [write_dir name{1} '_I_RGB_' method '.png'])
subplot(2,2,3); imshow(I);  title('Reflectance (Gray)');
imwrite(R, [write_dir name{1} '_R_Gray_' method '.png'])
hsv(:,:,3) = R;
subplot(2,2,4); imshow(hsv2rgb(hsv));  title('Reflectance (RGB)');
imwrite(hsv2rgb(hsv), [write_dir name{1} '_R_RGB_' method '.png'])
%subplot(2,2,1); imshow(Im);  title('Input');

% WVM CVPR2016
method = 'WVM';
Im = 255*Im;
if size(Im,3)>1
    HSV = rgb2hsv(Im);   % RGB space to HSV  space
    S = HSV(:,:,3);       % V layer
else
    S = Im;              % gray image
end
c_1 = 0.01; c_2 = 0.1; lambda = 1;     % set parameters
epsilon_stop = 1e-3;  % stopping criteria
[ R, I, epsilon_R, epsilon_L ] = WVM_CVPR2016( S, c_1, c_2, lambda, epsilon_stop );
Im = Im/255;
I = I/255;
hsv = rgb2hsv(Im);
subplot(2,2,1); imshow(I);  title('Illumination (Gray)');
imwrite(I, [write_dir name{1} '_I_Gray_' method '.png'])
hsv(:,:,3) = I;
subplot(2,2,2); imshow(hsv2rgb(hsv));  title('Illumination (RGB)');
imwrite(hsv2rgb(hsv), [write_dir name{1} '_I_RGB_' method '.png'])
subplot(2,2,3); imshow(I);  title('Reflectance (Gray)');
imwrite(R, [write_dir name{1} '_R_Gray_' method '.png'])
hsv(:,:,3) = R;
subplot(2,2,4); imshow(hsv2rgb(hsv));  title('Reflectance (RGB)');
imwrite(hsv2rgb(hsv), [write_dir name{1} '_R_RGB_' method '.png'])
%subplot(2,2,1); imshow(Im);  title('Input');
