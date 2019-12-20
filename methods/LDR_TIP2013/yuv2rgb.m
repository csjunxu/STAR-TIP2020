function rgb = yuv2rgb(Y,U,V)

Y = double(Y);
U = double(U) - 128;
V = double(V) - 128;

T = inv([0.2126 0.7152 0.0722; -0.1146 -0.3854 0.5; 0.5 -0.4542 -0.0468]);
rgb = zeros(size(Y,1),size(Y,2),3);

rgb(:,:,1) = T(1,1) * Y + T(1,2) * U + T(1,3) * V;
rgb(:,:,2) = T(2,1) * Y + T(2,2) * U + T(2,3) * V;
rgb(:,:,3) = T(3,1) * Y + T(3,2) * U + T(3,3) * V;
rgb = uint8(round(rgb));

end

