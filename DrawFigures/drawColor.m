im = 'books';
s  = 40;
f  = 3; 
lr = 2;
scale = [234 320];
% input  
im_dir = '../correction/img/';
image = imread([im_dir im '.png']);
image = imresize(image, scale);
%[ outputimage ] = boxandresize( image, h,w,s, f,lr);
imname = sprintf('%s_%s.png','resize',im);
imwrite(image,imname,'png');

%% error map
h  = 60;
w  = 280;
% ours
image = imread([im_dir im '_error_star.png']);
illuminance = imresize(image, scale);
[ outputimage ] = boxandresize( illuminance, h,w,s, f,lr);
imname = sprintf('%s_%s_error_star.png','resize',im);
imwrite(outputimage,imname,'png');

% JieP ICCV 2017
image = imread([im_dir im '_error_jiep.png']);
illuminance = imresize(image, scale);
[ outputimage ] = boxandresize( illuminance, h,w,s, f,lr);
imname = sprintf('%s_%s_error_jiep.png','resize',im);
imwrite(outputimage,imname,'png');

% WVM CVPR 2016
image = imread([im_dir im '_error_wvm.png']);
illuminance = imresize(image, scale);
[ outputimage ] = boxandresize( illuminance, h,w,s, f,lr);
imname = sprintf('%s_%s_error_wvm.png','resize',im);
imwrite(outputimage,imname,'png');

% SRIE TIP 2015
image = imread([im_dir im '_error_sire.png']);
illuminance = imresize(image, scale);
[ outputimage ] = boxandresize( illuminance, h,w,s, f,lr);
imname = sprintf('%s_%s_error_sire.png','resize',im);
imwrite(outputimage,imname,'png');