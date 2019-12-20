function [ outputimage ] = boxandresize( image, top, left, width, scale, model )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% top 框顶坐标
% left 框左边坐标
% width 框宽度
% scale 放大倍数
% model 模式
outputimage = DrawBox( image, top, left, width, [0,255,0]);

smallimage = outputimage(top:top+width,left:left+width,:);
bigimage = imresize(smallimage,scale, 'bic');
[m ,n, c] = size(bigimage);
if(model==1)    %右下角
    outputimage(end-m+1:end,end-n+1:end,:) = bigimage;
elseif(model==2)   %左下角
    outputimage(end-m+1:end,1:n,:) = bigimage;
else
        outputimage(1:m,end-n+1:end,:) = bigimage;
end

end

