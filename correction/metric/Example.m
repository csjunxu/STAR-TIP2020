%%%% BRIEF EXAMPLE BEGINS
%
% This script is supposed to be run line-by-line, so that you can
% see the result of each operation.
%
% We normally run this by using emacs as the editor.  We open two buffers and
% run matlab in one buffer and have the text commands in the other.
% We copy the matlab commands from the text buffer to the matlab buffer.
%
% These commands along with many wordy comments can be found in
% CommentedExample.m
%


% Load the two images
%
load images/hats
load images/hatsCompressed

% 2.  Load the calibration information
%
sampPerDeg = 23;
load displaySPD;
load SmithPokornyCones;
rgb2lms = cones'* displaySPD;
load displayGamma;
rgbWhite = [1 1 1];
whitepoint = rgbWhite * rgb2lms'

% 3.1  -- Convert the RGB data to LMS (or XYZ if you like).
%
img = [ rHats gHats bHats];
imgRGB = dac2rgb(img,gammaTable);
img1LMS = changeColorSpace(imgRGB,rgb2lms);
img = [ rHatsc gHatsc bHatsc];
imgRGB = dac2rgb(img,gammaTable);
img2LMS = changeColorSpace(imgRGB,rgb2lms);
imageformat = 'lms';

% 4. --  Run the scielab function.
errorImage = scielab(sampPerDeg, img1LMS, img2LMS, whitepoint, imageformat);

% 5. --  Examining and interpreting the results.
%
% max(img1LMS(:)), min(img1LMS(:))
% max(img2LMS(:)), min(img2LMS(:))

hist(errorImage(:),[1:2:14])
sum(errorImage(:) > 20)   % We think this is 173

% Look at the spatial distribution of the errors.
%
errorTruncated = min(128*(errorImage/10),128*ones(size(errorImage)));
figure(1)
colormap(gray(128));
image(errorTruncated); axis image;

% If you have the image processing toolbox, you can find out where the
% edges are and overlay the edges with the locations of the scielab
% errors

%% For Matlab version 5, use the following command:
edgeImage = 129 * double(edge(rHats,'prewitt'));
%% For Matlab version 4 or 3, use the following command:
edgeImage = 129 * double(edge(rHats,'prewitt'));

comparison = max(edgeImage,errorTruncated);
mp = [gray(127); [0 1 0]; [1 0 0] ];
colormap(mp)
image(comparison)

% You can look at the image as a gray-scale
%
figure(2)
colormap(gray(128));
imagesc([rHats + gHats + bHats] / 3)

%%%%%EXAMPLE ENDS
%close all;
