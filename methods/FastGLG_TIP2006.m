clear all;
clc;
x3=imread('img.png');
x=rgb2gray(x3);
x1=rgb2gray(x3);
x2=rgb2gray(x3);
imshow(x);
title('Original Image');

[p q]=size(x);
h1=zeros(1,256);
for i=1:p
    for j=1:q
       h1(x(i,j)+1)=h1(x(i,j)+1)+1;
    end
end
n=0;
for i=1:256
    if(h1(i)~=0)
        n=n+1;
    end
end
h=zeros(n,256);
for i=1:p
for j=1:q
    m=x(i,j);
    h(n,m+1)=h(n,m+1)+1;
end
end
M=256;


c=0;
i=1;
g=zeros(n,n);
l=zeros(n,n);
r=zeros(n,n);
for k=1:256
    if(h(n,k) ~= 0)
        g(n,i)=h(n,k);
        l(n,i)=k-1;
        r(n,i)=k-1;
        i=i+1;
    end;
end











while(n>3)
a=g(n,1);
for i=2:n
    if(a>g(n,i))
        a=g(n,i);
        ia=i;
    end
end

if(ia==1)
    id=1;
elseif(ia==n)
        id=ia;
        
elseif(g(n,ia-1)<=g(n,ia+1))
    id=ia-1;
else
    id=ia;
end;
if(ia==1)
    b=g(n,ia+1);
elseif(ia==n)
    b=g(n,ia-1);
else
    if(g(n,ia+1)<=g(n,ia-1))
        b=g(n,ia+1);
    else
        b=g(n,ia-1);
    end

end


for i=1:n-1
    if(i<id)
        g(n-1,i)=g(n,i);
    elseif(i==id)
            g(n-1,i)=a+b;
        else
            g(n-1,i)=g(n,i+1);
        
    end

       if(i<=id)
           l(n-1,i)=l(n,i);
       else
           l(n-1,i)=l(n,i+1);
       end;
       if(i<id)
           r(n-1,i)=r(n,i);
       else
           r(n-1,i)=r(n,i+1);
       end
end;

n=n-1;
end
            





n=22;

if(l(n-1,1)~=r(n-1,1))
      N=(M-1)/(n-1);
else
      N=(M-1)/(n-2);
end

for k=1:M-1
    if(k<=l(n-1,1))
        T(n-1,k)=0;
    elseif(k>=r(n-1,n-1))
        T(n-1,k)=255;
    else
        for p1=1:n-1
            flag=0;
            if(k>=l(n-1,p1)&&k<=r(n-1,p1))
                    i=p1;
                    flag=1;
                    break;
            end
            if(k>r(n-1,p1)&&k<l(n-1,p1+1))
                i=p1;
                break;
            end
        end
        if(flag==1) && (l(n-1,i)~=r(n-1,i))
            if(l(n-1,1)==r(n-1,1))
                T(n-1,k)=(i-1-((r(n-1,i)-k)/(r(n-1,i)-l(n-1,i))))*N+1;
            else
                T(n-1,k)=(i-((r(n-1,i)-k)/(r(n-1,i)-l(n-1,i))))*N+1;
            end
        else
            if(l(n-1,1)==r(n-1,1))
                T(n-1,k)=(i-1)*N;
            else
                T(n-1,k)=i*N;
            end
        end
    end
end
% for i=1:p
%     for j=1:q
%         m=x3(i,j);
%         x(i,j)=T(n-1,m+1);
%     end
% end
% for i=1:p
%     for j=1:q
%         m=x(i,j);
%         h(n-1,m+1)=h(n-1,m+1)+1;
%     end
% end
% npix=p*q;
% sum=0;
% for i=1:M-1
%     for j=i+1:M
%         sum=sum+h(n-1,i)*h(n-1,j)*(j-i);
%     end
% end
% d(n-1)=sum/(npix*(npix-1));
% n=n-1;



for i=1:255
    T(21,i)=uint32(T(21,i));
end

x=zeros(p,q);
for i=1:p
    for j=1:q
        k=x1(i,j);
        x(i,j)=T(21,k+1);
    end
end
figure;
imshow(x,[]);title('After FGLG');