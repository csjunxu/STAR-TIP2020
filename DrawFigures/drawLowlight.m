im = '3';
h  = 80;
w  = 90;
s  = 40;
f  = 3;
lr = 1;
scale = [256, 256];
ii = 100;

dataset = 'LowLight'; %night (30) cloudy (12) %'LowLight'; % 2, 10
%% input
image = imread(['/home/csjunxu/Paper/Enhancement/Dataset/Images_' dataset '/' im '.bmp']);
[hh, ww, cc] = size(image);
ll = min(hh,ww);
image = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( image, h,w,s, f,lr);
imname = sprintf('%s_%s.png','rs',im);
imwrite(outputimage,imname,'png');

%% NPE TIP2013
image = imread(['/home/csjunxu/Paper/Enhancement/Results_' dataset '/NPE_TIP2013/NPE_TIP2013_' im '.jpg']);
image = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( image, h,w,s, f,lr);
imname = sprintf('%s_%s_NPE.png','rs',im);
imwrite(outputimage,imname,'png');

%% WVM CVPR2016
image = imread(['/home/csjunxu/Paper/Enhancement/Results_' dataset '/WVM_CVPR2016/WVM_CVPR2016_' im '.jpg']);
image = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( image, h,w,s, f,lr);
imname = sprintf('%s_%s_WVM.png','rs',im);
imwrite(outputimage,imname,'png');

%% JieP ICCV 2017
image = imread(['/home/csjunxu/Paper/Enhancement/Results_' dataset '/JieP_ICCV2017/JieP_ICCV2017_' im '.jpg']);
image = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( image, h,w,s, f,lr);
imname = sprintf('%s_%s_JieP.png','rs',im);
imwrite(outputimage,imname,'png');

%% LIME TIP2017
% ours
image = imread(['/home/csjunxu/Paper/Enhancement/Results_' dataset '/LIME_TIP2017/LIME_TIP2017_' im '.jpg']);
image = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( image, h,w,s, f,lr);
imname = sprintf('%s_%s_LIME.png','rs',im);
imwrite(outputimage,imname,'png');

%% STAR
image = imread(['STAR_' im '.png']);
image = imresize(image(1:ll,ii:ll+ii-1,:), scale);
[ outputimage ] = boxandresize( image, h,w,s, f,lr);
imname = sprintf('%s_%s_STAR.png','rs',im);
imwrite(outputimage,imname,'png');


