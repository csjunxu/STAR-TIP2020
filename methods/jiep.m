function [ I, R] = jiep( src, alpha, beta, lambda, vareps, r, r0, K, debug)
if (~exist('alpha','var'))	% alpha -- parameter for shape
    alpha = 0.001;
end
if (~exist('beta','var'))	% beta -- parameter for texture
    beta = 0.0001;
end
if (~exist('lambda','var'))	% lambda -- parameter for illumination
    lambda = 0.25;
end
if (~exist('vareps','var')) % vareps -- stopping parameter
    vareps = 0.01;
end
if (~exist('K','var'))      % K -- maximum iterations
    K = 20;
end
if (~exist('r','var'))      % r -- the size of Omega in Eq.(3)
    r = 3;
end
if (~exist('r0','var'))     % r0 -- the size of Omega in Eq.(7)
    r0 = 5;
end
if (~exist('debug','var'))  % debug -- set debug/release
    debug = true;
end
r = (r-1)/2;
r0 = (r0-1)/2;
eps=0.0001;
if size(src,3)==1
    S = src;
    gray = src;
else
    hsv = rgb2hsv(src);
    S = hsv(:,:,3);
    gray = rgb2gray(src);
end

B = convMax(single(S),r0);                              % Eq.(7)
B = guidedfilter(gray, B, 20, eps);                     % use guided filer to refine bright channel
I=S;                                                    % initialize I_0
R=ones(size(S));                                        % initialize R_0
if debug == true
    fprintf('-- Stop iteration until eplison < %02f or K > %d\n', vareps, K);
end
for iter = 1:K
    preI=I;
    preR=R;
    %% algorithm for P1
    I=S./R;
    Ix = diff(I,1,2); Ix = padarray(Ix, [0 1], 'post');
    Iy = diff(I,1,1); Iy = padarray(Iy, [1 0], 'post');
    avgIx=convBox( single(Ix), r);
    avgIy=convBox( single(Iy), r);
    ux = max(abs(avgIx.*Ix),eps).^(-1);                     % ux in Eq.(11)
    uy = max(abs(avgIy.*Iy),eps).^(-1);                     % uy in Eq.(11)
    ux(:,end) = 0;
    uy(end,:) = 0;

    I = solveLinearSystem(S, R, ux, uy, alpha, B, lambda);  % Eq.(12)
    eplisonI = norm(I-preI, 'fro')/norm(preI, 'fro');       % iterative error of I
    
    %% algorithm for P2
    R=S./I;
    Rx = diff(R,1,2); Rx = padarray(Rx, [0 1], 'post');
    Ry = diff(R,1,1); Ry = padarray(Ry, [1 0], 'post');
    vx = max(abs(Rx),eps).^(-1);                            % vx in Eq.(11)
    vy = max(abs(Ry),eps).^(-1);                            % vy in Eq.(11)
    vx(:,end) = 0;
    vy(end,:) = 0;

    R = solveLinearSystem(S, I, vx, vy, beta);            	% Eq.(13)
    eplisonR = norm(R-preR, 'fro')/norm(preR, 'fro');       % iterative error of R
    
    %% iteration until convergence
    if debug == true
        fprintf('Iter #%d : eplisonI = %f; eplisonR = %f\n', iter, eplisonI, eplisonR);
    end
    if(eplisonI<vareps||eplisonR<vareps)
        break;
    end
end
end


