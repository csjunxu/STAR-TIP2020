im = '8gray';
s  = 35;
f  = 3; 
lr = 1;
scale = 1/2;
% input    '/home/csjunxu/Paper/Enhancement/Dataset/Images_LowLight/'
image = imread([ im '.png']);
[hh, ww, cc] = size(image);
ll = min(hh,ww);
ii = 101; 
image = imresize(image(1:ll,ii:ll+ii-1,:), scale);
%[ outputimage ] = boxandresize( image, h,w,s, f,lr);
imname = sprintf('%s_%s.png','rs',im);
imwrite(image,imname,'png');

%% illumiance
h  = 160;
w  = 80;

% baseline
image = imread([im '_I_RGB_STAR_pI1.7_pR0.1.png']);
illuminance = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( illuminance, h,w,s, f,lr);
imname = sprintf('%s_%s_I_STAR.png','rs',im);
imwrite(outputimage,imname,'png');

% STAR
image = imread([im '_I_RGB_STAR_pI1.7_pR0.1.png']);
illuminance = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( illuminance, h,w,s, f,lr);
imname = sprintf('%s_%s_I_STAR.png','rs',im);
imwrite(outputimage,imname,'png');

% JieP ICCV 2017
image = imread([im '_I_RGB_JieP.png']);
illuminance = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( illuminance, h,w,s, f,lr);
imname = sprintf('%s_%s_I_JieP.png','rs',im);
imwrite(outputimage,imname,'png');

% WVM CVPR 2016
image = imread([im '_I_RGB_WVM.png']);
illuminance = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( illuminance, h,w,s, f,lr);
imname = sprintf('%s_%s_I_WVM.png','rs',im);
imwrite(outputimage,imname,'png');

%% reflectance
h  = 60;
w  = 50;

% baseline
image = imread([im '_I_RGB_STAR_pI1.7_pR0.1.png']);
illuminance = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( illuminance, h,w,s, f,lr);
imname = sprintf('%s_%s_I_STAR.png','rs',im);
imwrite(outputimage,imname,'png');

% STAR
image = imread([im '_R_RGB_STAR_pI1.7_pR0.1.png']);
reflectance = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( reflectance, h,w,s, f,lr);
imname = sprintf('%s_%s_R_STAR.png','rs',im);
imwrite(outputimage,imname,'png');

% JieP ICCV 2017
image = imread([im '_R_RGB_JieP.png']);
reflectance = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( reflectance, h,w,s, f,lr);
imname = sprintf('%s_%s_R_JieP.png','rs',im);
imwrite(outputimage,imname,'png');

% WVM CVPR 2016
image = imread([im '_R_RGB_WVM.png']);
reflectance = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( reflectance, h,w,s, f,lr);
imname = sprintf('%s_%s_R_WVM.png','rs',im);
imwrite(outputimage,imname,'png');

