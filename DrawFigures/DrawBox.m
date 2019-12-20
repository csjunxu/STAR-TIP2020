function [ outputimage ] = DrawBox( image, top, left, width, rgbarray)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[m, n, c] = size(image);
if(c==3)
    outputimage = image;
else
    outputimage(:,:,1) = image;
    outputimage(:,:,2) = image;
    outputimage(:,:,3) = image;
end
r = rgbarray(1);
g = rgbarray(2);
b = rgbarray(3);

outputimage(top:top+width,left,1) = r;
outputimage(top:top+width,left,2) = g;
outputimage(top:top+width,left,3) = b;
outputimage(top:top+width,left+1,1) = r;
outputimage(top:top+width,left+1,2) = g;
outputimage(top:top+width,left+1,3) = b;
outputimage(top:top+width,left+width,1) = r;
outputimage(top:top+width,left+width,2) = g;
outputimage(top:top+width,left+width,3) = b;
outputimage(top:top+width,left+width-1,1) = r;
outputimage(top:top+width,left+width-1,2) = g;
outputimage(top:top+width,left+width-1,3) = b;

outputimage(top,left:left+width,1) = r;
outputimage(top,left:left+width,2) = g;
outputimage(top,left:left+width,3) = b;
outputimage(top+1,left:left+width,1) = r;
outputimage(top+1,left:left+width,2) = g;
outputimage(top+1,left:left+width,3) = b;
outputimage(top+width,left:left+width,1) = r;
outputimage(top+width,left:left+width,2) = g;
outputimage(top+width,left:left+width,3) = b;
outputimage(top+width-1,left:left+width,1) = r;
outputimage(top+width-1,left:left+width,2) = g;
outputimage(top+width-1,left:left+width,3) = b;

end

