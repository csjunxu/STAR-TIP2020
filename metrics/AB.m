function score = AB(Im)
% compute the Average Brightness(AB) of an image
% -------------------------------------------------------------------------
% input : 'Im' is a gray or RGB image of size h x w x ch
% output: score is the mean brightness of the input image 'Im'% 
% -------------------------------------------------------------------------
if size(Im, 3) == 3
    Im = rgb2gray(Im);
end
score = mean2(Im);