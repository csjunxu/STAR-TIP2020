function result = scielab(sampPerDeg, image1, image2, whitepoint, imageformat,k)
% result = scielab(sampPerDeg, image1, image2, whitepoint, imageformat,k)
%
% Computes the S-CIELAB difference between two images.
%
% sampPerDeg -- input image resolution in samples per degree of visual angle.
%      (use the function visualAngle to determine SAMPPERDEG: pass numpixels=-1
%       and visualAngle=1);
% image1, image2 -- input images in XYZ or cone coordinate. These should
%                   be in the format [x-plane y-plane z-plane] if they are
%                   in XYZ coordinate, or [L-plane M-plane S-plane] if they
%                   are in cone coordinate. They can also be in a
%                   three-dimensional matrix of size [m n 3] if
%                   you are using Matlab version 5 and up.
% whitepoint -- white point for computing CIELAB values. If the images are
%               in XYZ format, whitepoint should be in the format
%               [x y z]. If the images are in LMS format, whitepoint should
%               also be in LMS format [l m s].
% imageformat -- specifies the format of the input images. Options are
%                'xyz': CIE1931 (2 degree) XYZ values (DEFAULT)
%                'xyz10': CIE1964 (10 degree) XYZ values
%                'lms': LMS cone coordinates, use XYZ2 to compute CIELAB.
%                'lms10': LMS cone coordinates, use XYZ10 to compute CIELAB.
% k  -- If this value is provided, use the CIE94 color difference
%                formula to compute delta E. If k is given as a 3
%                vector, use this as the k94 vector in the CIE94
%                calculation. Otherwise, use the default.
% 
% If all arguements are given, the s-cielab difference image is returned 
%     with entries representing deltaE values for each pixel location.
% If only sampPerDeg, image1 (and possibly imageformat) are specified, 
%     then return image1 after the spatial filtering operation, in the 
%     opponent representation [BW-plane RG-plane BY-plane]. For example:
%     result = scielab(sampPerDeg, image1, 'xyz2') will return the 
%     spatially filtered opponent representation of image1 as result,
%     assuming "image1" is provided in xyz1931 format.
%
% Functions called: changeColorSpace, cmatrix,
%                   getPlanes, pad4conv, resize, deltaLab,
%                   separableFilters, separableConv.
%                   (implicit: gauss, gauss2, sumGauss, xyz2lab).
%
% Xuemei Zhang  1/28/96
% Last Modified 4/15/98


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  General Preparation  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin==2 | nargin==4)    % if imageformat is not given, use default
  imageformat = 'xyz';
elseif (nargin==3)            % if only 3 arguments, the 3rd one is imageformat
  imageformat = image2;
end

% force imageformat to be length 5 consistently, so that it is
% easy to do comparisons like (imageformat=='...').
imageformat = [imageformat '   '];
imageformat = imageformat(1:5);

% Check if the input images are 1-D or 2-D
imsize = size(image1);
if (imsize(1)>1 & prod(imsize(2:length(imsize)))>3)   % 2-D images
  dimension = 2;
else
  dimension = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Color Transformation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Performing color transformations ...');

% Convert XYZ or LMS representation to Poirson&Wandell opponent
% representation.
if (imageformat=='xyz10' | imageformat=='lms10')
  xyztype = 10;
else
  xyztype = 2;
end

if (imageformat(1:3)=='lms')
  opp1 = changeColorSpace(image1, cmatrix('lms2opp'));
  if (nargin>3)
    opp2 = changeColorSpace(image2, cmatrix('lms2opp'));
    oppwhite = changeColorSpace(whitepoint, cmatrix('lms2opp'));
    whitepoint = changeColorSpace(oppwhite, cmatrix('opp2xyz', xyztype));
  end
else
  opp1 = changeColorSpace(image1, cmatrix('xyz2opp', xyztype));
  if (nargin>3)
    opp2 = changeColorSpace(image2, cmatrix('xyz2opp', xyztype));
  end
end

clear image1; clear image2;

%%%%%%%%%%%%%%%%%%%%%%
%%  Prepare filters %%
%%%%%%%%%%%%%%%%%%%%%%

disp('Preparing filters ...');

if (dimension == 1)
  [k1, k2, k3] = separableFilters(sampPerDeg, 1);
else
  [k1, k2, k3] = separableFilters(sampPerDeg, 3);
end


%%%%%%%%%%%%%%%%%%%%%%%%
%%  Spatial Filtering %%
%%%%%%%%%%%%%%%%%%%%%%%%

% Apply the filters k1, k2, k3 to the images.
% The edges of the images are reflected for convolution.

if (length(imsize)==3)
  w1 = opp1(:,:,1);
  w2 = opp1(:,:,2);
  w3 = opp1(:,:,3);
else
  [w1, w2, w3] = getPlanes(opp1);
end
clear opp1;
wsize = size(w1);

if (dimension == 1)
  w1 = pad4conv(w1, length(k1));
  w2 = pad4conv(w2, length(k2));
  w3 = pad4conv(w3, length(k3));
  disp('Filtering BW plane of image1 ...');
  p1 = resize(conv(w1, k1), wsize);
  disp('Filtering RG plane of image1 ...');
  p2 = resize(conv(w2, k2), wsize);
  disp('Filtering BY plane of image1 ...');
  p3 = resize(conv(w3, k3), wsize);
else
  disp('Filtering BW plane of image1 ...');
  p1 = separableConv(w1, k1, abs(k1));
  disp('Filtering RG plane of image1 ...');
  p2 = separableConv(w2, k2, abs(k2));
  disp('Filtering BY plane of image1 ...');
  p3 = separableConv(w3, k3, abs(k3));
end

new1 = [p1 p2 p3];

% If a second image is given, do the same filtering to the second image
% and then compute the CIELAB difference between them.
if (nargin>3)
  if (length(imsize)==3)
    w1 = opp2(:,:,1);
    w2 = opp2(:,:,2);
    w3 = opp2(:,:,3);
  else
    [w1, w2, w3] = getPlanes(opp2);
  end
  clear opp2;
  if (dimension == 1)
    w1 = pad4conv(w1, length(k1));
    w2 = pad4conv(w2, length(k2));
    w3 = pad4conv(w3, length(k3));
    disp('Filtering BW plane of image2 ...');
    p1 = resize(conv(w1, k1), wsize);
    disp('Filtering RG plane of image2 ...');
    p2 = resize(conv(w2, k2), wsize);
    disp('Filtering BY plane of image2 ...');
    p3 = resize(conv(w3, k3), wsize);
  else
    disp('Filtering BW plane of image2 ...');
    p1 = separableConv(w1, k1, abs(k1));
    disp('Filtering RG plane of image2 ...');
    p2 = separableConv(w2, k2, abs(k2));
    disp('Filtering BY plane of image2 ...');
    p3 = separableConv(w3, k3, abs(k3));
  end
  new2 = [p1 p2 p3];
end

clear p1 p2 p3 w1 w2 w3 k1 k2 k3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Return Appropriate Results %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin<4)       % return filtered image1 only
  result = reshape(new1, imsize);
else                % compute difference image
  disp('Computing CIELAB differences ...');
  result = changeColorSpace(new1, cmatrix('opp2xyz', xyztype));
  result2 = changeColorSpace(new2, cmatrix('opp2xyz', xyztype));
%  result = result .* (result>0);
%  result2 = result2 .* (result2>0);
  if (nargin == 6)
    result = deltaLab(result, result2, whitepoint, 1/3, k);
  else
    result = deltaLab(result, result2, whitepoint);    
  end
end

