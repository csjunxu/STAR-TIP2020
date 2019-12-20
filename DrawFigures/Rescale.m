clear;
scale = [256, 256];
ii = 100;
Original_image_dir  =    '../Priors/';
fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);
for i=1:im_num
    Im = im2double(imread(fullfile(Original_image_dir, im_dir(i).name)));
    [hh, ww, cc] = size(Im);
    ll = min(hh,ww);
    image = imresize(Im(1:ll,ii:ll+ii-1,:), scale);
    imname = ['rs' im_dir(i).name];
    imwrite(image,imname,'png');
end