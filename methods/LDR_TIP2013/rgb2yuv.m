function [ Y, U, V ] = rgb2yuv( R, G, B )

T = [0.2126 0.7152 0.0722; -0.1146 -0.3854 0.5; 0.5 -0.4542 -0.0468];

R = double(R);
G = double(G);
B = double(B);

Y = T(1,1) * R + T(1,2) * G + T(1,3) * B;
U = T(2,1) * R + T(2,2) * G + T(2,3) * B + 128;
V = T(3,1) * R + T(3,2) * G + T(3,3) * B + 128;

Y = uint8(round(Y));
U = uint8(round(U));
V = uint8(round(V));

end