clc;
clear;
close all;

scale=1.6;
I = im2double(imread('../img/juice.png'));

[L(:,:,1),R(:,:,1),~]=jiep(I(:,:,1),0.001,0.0001,0.25);
[L(:,:,2),R(:,:,2),~]=jiep(I(:,:,2),0.001,0.0001,0.25);
[L(:,:,3),R(:,:,3),~]=jiep(I(:,:,3),0.001,0.0001,0.25);
r=mean(reshape(R,size(R,1)*size(R,2),size(R,3)));
for i=1:3
    temp=L(:,:,i);
    alpha=mean(temp(:));
    L2(:,:,i)=L(:,:,i)./alpha.*(scale*mean(L(:))*r(i));
end
I_c=L2.*R;

imshow(R);
imshow(L2);
imshow(I_c);
imwrite(I_c,'../img/juice_jiep.png');


