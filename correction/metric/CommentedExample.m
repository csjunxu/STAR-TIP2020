%
%  Hello,
%
%    This file is a script that you can use to try out the S-CIELAB
% calculations we have developed.  The sequence of steps in this file
% will (1) illustrate how to calculate the S-CIELAB representation for an
% image, and (2) illustrate how to calculate the S-CIELAB errors
% (delta Es) for a pair of images.
%
% This file is written as if you are going to evaluate the error
% between a pair of images that are presently coded as RGB data.  The
% initial calculation converts the RGB data to CIE XYZ data.  
% The calculations are similar if your images are coded as CMYK,
% but you will need to convert from CMYK to XYZ instead of converting
% from RGB to XYZ.
%
%

%%END INTRODUCTION


%%%%EXAMPLE BEGINS

% 1.  Reading in your image data
%
% First, load in an RGB image. The example image below consists of
% three matrices, rHats,gHats and bHats, each of size 128 x 192.
load images/hats
load images/hatsCompressed

% If you would like to view the image, we suggest you use a tiff
% viewer, like xv, and type 
%
% unix('xv -perfect images/hats.tiff &')
%	
% If you have the Matlab image toolbox, you can read in the tiff files
% directly (which is what we usually do) via
%
% [rHats gHats bHats] = tiffread('images/hats.tiff');
% [rHatsc gHatsc bHatsc] = tiffread('images/hatsCompressed.tiff');
%
% To see the different color planes, you could try looking at
%
%  colormap( gray(128)*diag([1,0,0])), imagesc(rHats)
%  colormap( gray(128)*diag([0,1,0])), imagesc(gHats)
%  colormap( gray(128)*diag([0,0,1])), imagesc(bHats)


% 2.  Defining the calibration information
%

% 2.1:  Spatial calibration information.
%
% Now, we need to specify the viewing conditions.  Specifically, we
% need to know the relevant spatial parameters for when the digital
% image is viewed.  This parameter tells us how many digital samples
% there are per degree of viewing angle.  We call it sampPerDeg.  For
% a typical monitor (72 dots per inch) viewed at 18 inches, one inch
% sweeps out 3.1798 = (180/pi) * atan(1/18) deg.  Hence, there are
% 72/3.1798 samples in a single degree of visual angle for this monitor.
%
% round(72 / ((180/pi)*atan(1/18)))
sampPerDeg = 23;

% 2.2:  Color calibration information
%
% Next, we need to specify two aspects of the display characteristcs
% so that we can specify how the displayed image affects the cone
% photoreceptors.  To make this estimate, we need to know something
% about 
%   1) the effect each display primary has on your cones, and 
%   2) the relationship between the frame-buffer values and the
%   intensity of the display primaries
% 
% For this example, we assumed that your display is pretty standard
% (and like some of ours).  These assumptions are not going to be
% preicsely correct for your CRTs; they are not even close for
% printers or LCD displays. 
%
% A broad description of the issues concerning color calibration may be
% found in the following references:
%
%	Brainard -- CR and A paper
%	???
%	Wandell-- Appendix B
%

% 2.2.1 -- Effects of the display primaries on the human cones
%
%  To compute the effect of the display primaries on the cones, we
%  need to know 
%	1)  The spectral power distribution (SPD) of the display, and
%	2)  The relative absorptions of the human cones.
%
%  We include a file containing the display SPDs of one of our
%  monitors in the file displaySPD.mat.  The file contains the
%  variables: 
%
%	wavelength: a vector describing the wavelengths of the cone
%  		     sensitivities (370:73))
%	displaySPD: a 361x3 matrix of the spectral power distributions
%		     of the red, green, and blue primaries
%
load displaySPD

%  We usually compute with respect to the human cone estimates from
%  Smith and Pokorny (19XX).  These are represented in the file named
%  SmithPokornyCones.mat 
%
%  The file contains the following variables:

%	wavelength:  a vector describing the wavelengths of the cone
%  		     sensitivities (370:73))
%	cones:       a 361 x 3 matrix matrix describing the cone
%		     sensitivities at the corresponding wavelengths
%
load SmithPokornyCones

% If you would like to see the cone sensitivities or the display
% spectral power distribution we have assumed, type:
%
% 	plot(wavelength,cones)
% 	plot(wavelength, displaySPD)
%
%	REFERENCE:  
%

%  Now, we can compute the 3 x 3 transformation that maps the linear
%  intensity of the display r,g,b signals into the cone absorptions
%  (l,m,s). 
rgb2lms = cones'* displaySPD;

% 2.2.2  -- Gamma correction
%
%  There is a nonlinear relationship between the frame-buffer values
%  in the image data and the intensity of the light emitted by each of
%  the primaries on your display.  This relationship is captured by a
%  function commonly called the ``display gamma curve.''  
%
%  The file displayGamma.mat contains the variables
%	gamma:  is a look-up table that maps 
%		framebuffer values -> relative linear display intensity
%	where the maximum display intensity is 1.0.
%
%	invGamma: is the inverse of gamma and maps
%		relative lin. disp. intensity -> frame-buffer value
%		This table has been interpolated to 1024 intensity levels.
%
load displayGamma

% 2.2.3  ---  The CIELAB computation requires specifiying the
% white-point of the data set.  In our view, each image should have
% its own white point.  In a generally abominable practice, which we
% follow here, the white point is commonly set to be the white of the
% monitor.  We don't like this much because the white point is
% supposed to depend on the image data, not the display device.  But,
% nevermind. 
%
rgbWhite = [1 1 1];
whitepoint = rgbWhite * rgb2lms';

% We have helped you out here by writing the little routine
% ``cmatrix'' that returns some of the most frequently used matrices,
% such as opp2lms, opp2xyz, and so forth.  The entries returned by
% that routine were computed using the same method shown above for
% computing rgb2lms. 
%

% Setting up the image data for S-CIELAB

% 3.1  -- Convert the RGB data to LMS (or XYZ if you like).
%
% Now, we convert the rgb data into the lms format.  This takes place
% in two steps.  First, we correct the r,g,b frame-buffer values for
% the gamma curve.  Second, we convert the linearized r,g,b values
% into cone absorptions using the matrix rgb2lms
%
img = [ rHats gHats bHats];
imgRGB = dac2rgb(img,gammaTable);
img1LMS = changeColorSpace(imgRGB,rgb2lms);

img = [ rHatsc gHatsc bHatsc];
imgRGB = dac2rgb(img,gammaTable);
img2LMS = changeColorSpace(imgRGB,rgb2lms);

% 3.2 -- Identify the color space
%  
%  The scielab function accepts input in a few different formats.  We
%  need to tell it whether the input data are in lms, or xyz format.
%
imageformat = 'lms';

% 4. --  Run the scielab function.
%  See the paper to understand what it does more fully.
%
% 	REFERENCE:
%	SID paper
%
errorImage = scielab(sampPerDeg, img1LMS, img2LMS, whitepoint, imageformat);


% 5. --  Examining and interpreting the results.
%
max(img1LMS(:)), min(img1LMS(:))
max(img2LMS(:)), min(img2LMS(:))

% For this example, most of the errors are less than 10, as this
% histogram shows.
%
hist(errorImage(:),[1:2:14])
sum(errorImage(:) > 20)   % We think this is 173

% Let's study the spatial distribution of the errors and just mark the
% ones that are 10 or larger using green
%
errorTruncated = min(128*(errorImage/10),128*ones(size(errorImage)));
figure
colormap([gray(127); [0 1 0]])
colormap([gray(127); [1 1 1]])
image(errorTruncated)

% If you have the image processing toolbox, you can find out where the
% edges are and overlay the edges with the locations of the scielab
% errors
%

%% For Matlab version 5, use the following command:
edgeImage = 129 * double(edge(rHats,'prewitt'));
%% For Matlab version 4 or 3, use the following command:
edgeImage = 129 * edge(rHats,'prewitt');

comparison = max(edgeImage,errorTruncated);
mp = [gray(127); [0 1 0]; [1 0 0] ];
colormap(mp)
image(comparison)

figure
colormap(gray(128));
imagesc([rHats + gHats + bHats] / 3)

%%%%%EXAMPLE ENDS
%close all;
