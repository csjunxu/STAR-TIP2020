function [ I, R] = STAR( src, alpha, beta, pI, pR, vareps, r, K, debug)
if (~exist('alpha','var'))	% alpha -- parameter for structure
    alpha = 0.001;
end
if (~exist('beta','var'))	% beta -- parameter for texture
    beta = 0.0001;
end
if (~exist('pI','var'))	% pI -- parameter for structure INTENSITY
    pI = 1.5;
end
if (~exist('pR','var'))	% pR -- parameter for texture INTENSITY
    pR = 0.5;
end
if (~exist('vareps','var')) % vareps -- stopping parameter
    vareps = 0.01;
end
if (~exist('r','var'))      % r -- the size of Omega in Eq.(3)
    r = 3;
end
if (~exist('K','var'))      % K -- maximum iterations
    K = 20;
end
if (~exist('debug','var'))  % debug -- set debug/release
    debug = true;
end
r = (r-1)/2;
eps=0.0001;
if size(src,3)==1
    S = src;
else
    hsv = rgb2hsv(src);
    S = hsv(:,:,3);
end

I=S;             % initialize I_0
R=ones(size(S)); % initialize R_0
if debug == true
    fprintf('-- Stop iteration until eplison < %02f or K > %d\n', vareps, K);
end
for iter = 1:K
    preI=I;
    preR=R;
    
    %% algorithm for P1
    %pI=max(pI,pR);
    I=S./R;
    Ix = diff(I,1,2); Ix = padarray(Ix, [0 1], 'post');
    Iy = diff(I,1,1); Iy = padarray(Iy, [1 0], 'post');
    avgIx=convBox( single(Ix), r);
    avgIy=convBox( single(Iy), r);
    ux = max(abs(avgIx).^pI,eps).^(-1);  % structure map avgIx.^pI > avgIx.*Ix > Ix.^2
    uy = max(abs(avgIy).^pI,eps).^(-1);  % structure map
    ux(:,end) = 0;
    uy(end,:) = 0;
    
    I = solveLinearSystem(S, R, ux, uy, alpha);  % Eq.(12)
    eplisonI = norm(I-preI, 'fro')/norm(preI, 'fro');   % iterative error of I
    
    %% algorithm for P2
    %pR=min(pI,pR);
    R=S./I;
    Rx = diff(R,1,2); Rx = padarray(Rx, [0 1], 'post');
    Ry = diff(R,1,1); Ry = padarray(Ry, [1 0], 'post');
    avgRx=convBox( single(Rx), r);
    avgRy=convBox( single(Ry), r);
    vx = max(abs(avgRx).^pR,eps).^(-1);  % texture map
    vy = max(abs(avgRy).^pR,eps).^(-1);  % texture map
    vx(:,end) = 0;
    vy(end,:) = 0;
    
    R = solveLinearSystem(S, I, vx, vy, beta);            	% Eq.(13)
    eplisonR = norm(R-preR, 'fro')/norm(preR, 'fro');   % iterative error of R
    
    %% iteration until convergence
    if debug == true
        fprintf('Iter #%d : eplisonI = %f; eplisonR = %f\n', iter, eplisonI, eplisonR);
    end
    if(eplisonI<vareps||eplisonR<vareps)
        break;
    end
end
I(I<0)=0;
R(R<0)=0;
end


