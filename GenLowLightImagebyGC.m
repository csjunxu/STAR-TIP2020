clc;clear;
% Please download the BSDS500 dataset at
% https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/resources.html#bsds500
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    P. Arbelaez, M. Maire, C. Fowlkes and J. Malik.
%    Contour Detection and Hierarchical Image Segmentation.
%    IEEE TPAMI, Vol. 33, No. 5, pp. 898-916, May 2011.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jun Xu, nankaimathxujun@gmail.com
%%% choose dataset
dirname = {'test', 'train', 'val'};

for d = 1:length(dirname)
    Test_dir  = fullfile('/home/csjunxu/Dataset/BSR/BSDS500/data/images', dirname{d});
    %%% read images
    ext         =  {'*.jpg','*.jpeg','*.JPG','*.png','*.bmp'};
    im_dir   =  [];
    for i = 1 : length(ext)
        im_dir = cat(1,im_dir, dir(fullfile(Test_dir,ext{i})));
    end
    im_num = length(im_dir);
    write_mat_dir = ['/home/csjunxu/Dataset/BSDS_LL/'];
    write_LL_dir = [write_mat_dir  'LowLightImages/'];
    write_I_dir = [write_mat_dir  'OriginalImages/'];
    if ~isdir(write_LL_dir)
        mkdir(write_LL_dir);
    end
    if ~isdir(write_I_dir)
        mkdir(write_I_dir);
    end
    gamma=2.2;
    for i = 1:im_num
        name = regexp(im_dir(i).name, '\.', 'split');
        Im=im2double( imread(fullfile(Test_dir, im_dir(i).name)) );
        if size(Im,3)==1
            V = Im;
        else
            hsv = rgb2hsv(Im);
            V = hsv(:,:,3);
        end
        V_gc = V.^(gamma); % gamma correction on the V channel
        hsv(:,:,3) = V_gc;
        Im_LL = hsv2rgb(hsv);
        % convert Im and eIm to uint8
        Im_LL = uint8(Im_LL*255);
        imwrite(Im, [write_I_dir name{1} '.jpg']);
        imwrite(Im_LL, [write_LL_dir name{1} '_LL.jpg']);
        fprintf([dirname{d} ',' num2str(i) '/' num2str(im_num) ',' name{1} ' is done.\n']);
    end
end