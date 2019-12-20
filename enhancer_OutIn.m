function [ I, R] = enhancer_OutIn( src, alpha, beta, pI, pR, r, K, vareps, debug)
if (~exist('alpha','var'))	% alpha -- parameter for shape
    alpha = 0.001;
end
if (~exist('beta','var'))	% beta -- parameter for texture
    beta = 0.0001;
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
if (~exist('debug','var'))  % debug -- set debug/release
    debug = true;
end
r = max(1, floor((r-1)/2)); % modified from r = (r-1)/2;
eps=0.0001;
if size(src,3)==1
    S = src;
else
    hsv = rgb2hsv(src);
    S = hsv(:,:,3);
end
%% initialize
I=S;                                                    % initialize I_0
R=ones(size(S));                                        % initialize R_0
if debug == true
    fprintf('-- Stop iteration until eplison < %02f or K > %d\n', vareps, K);
end
for OutIter = 1:K
    preOutI=I;
    preOutR=R;
    %imwrite((I-min(min(I)))./(max(max(I))-min(min(I))), ['I' num2str(OutIter-1) '.jpg'])
    %imwrite((R-min(min(R)))./(max(max(R))-min(min(R))), ['R' num2str(OutIter-1) '.jpg'])
    %% algorithm for P1
    % I=S./R; % will generate bug here
    Ix = diff(I,1,2); Ix = padarray(Ix, [0 1], 'post');
    Iy = diff(I,1,1); Iy = padarray(Iy, [1 0], 'post');
    avgIx=convBox( single(Ix), r);
    avgIy=convBox( single(Iy), r);
    ux = max(abs(avgIx.^pI),eps).^(-1);  % ux in Eq.(11) avgIx.^pI > avgIx.*Ix > Ix.^2
    uy = max(abs(avgIy.^pI),eps).^(-1);  % uy in Eq.(11) similarly
    ux(:,end) = 0;
    uy(end,:) = 0;
    %%% show the weights
    %imwrite((Ix-min(min(Ix)))./(max(max(Ix))-min(min(Ix))), 'weights/Ix_cai.jpg')
    %imwrite((Iy-min(min(Iy)))./(max(max(Iy))-min(min(Iy))), 'weights/Iy_cai.jpg')
    %imwrite((avgIx-min(min(avgIx)))./(max(max(avgIx))-min(min(avgIx))), 'weights/avgIx_cai.jpg')
    %imwrite((avgIy-min(min(avgIy)))./(max(max(avgIy))-min(min(avgIy))), 'weights/avgIy_cai.jpg')
    %imwrite((ux-min(min(ux)))./(max(max(ux))-min(min(ux))), ['weights/ux_pI' num2str(pI) '.jpg'])
    %imwrite((uy-min(min(uy)))./(max(max(uy))-min(min(uy))), ['weights/uy_pI' num2str(pI) '.jpg'])
    %% algorithm for P2
    % R=S./I; % will generate bug here
    Rx = diff(R,1,2); Rx = padarray(Rx, [0 1], 'post');
    Ry = diff(R,1,1); Ry = padarray(Ry, [1 0], 'post');
    avgRx=convBox( single(Rx), r);
    avgRy=convBox( single(Ry), r);
    vx = max(abs(avgRx.^pR),eps).^(-1);                            % vx in Eq.(11)
    vy = max(abs(avgRy.^pR),eps).^(-1);                            % vy in Eq.(11)
    vx(:,end) = 0;
    vy(end,:) = 0;
    %imwrite((Rx-min(min(Rx)))./(max(max(Rx))-min(min(Rx))), 'weights/Rx_cai.jpg')
    %imwrite((Ry-min(min(Ry)))./(max(max(Ry))-min(min(Ry))), 'weights/Rx_cai.jpg')
    %imwrite((vx-min(min(vx)))./(max(max(vx))-min(min(vx))), ['weights/vx_pR' num2str(pR) '.jpg'])
    %imwrite((vy-min(min(vy)))./(max(max(vy))-min(min(vy))), ['weights/vy_pR' num2str(pR) '.jpg'])
    for InIter = 1:K
        preI=I;
        preR=R;
        %% algorithm for P1
        I = solveLinearSystem(S, R, ux, uy, alpha);  % Eq.(12)
        eplisonIin = norm(I-preI, 'fro')/norm(preI, 'fro');       % iterative error of I
        
        %% algorithm for P2
        R = solveLinearSystem(S, I, vx, vy, beta);            	% Eq.(13)
        eplisonRin = norm(R-preR, 'fro')/norm(preR, 'fro');       % iterative error of R
        
        %% iteration until convergence
        if debug == true
            fprintf('Iter #%d : eplisonI = %f; eplisonR = %f\n', InIter, eplisonIin, eplisonRin);
        end
        if(eplisonIin<vareps||eplisonRin<vareps)
            break;
        end
        
    end
    eplisonIout = norm(I-preOutI, 'fro')/norm(preOutI, 'fro');       % iterative error of I
    eplisonRout = norm(R-preOutR, 'fro')/norm(preOutR, 'fro');       % iterative error of R
    %% iteration until convergence
    if debug == true
        fprintf('OutIter #%d : eplisonI = %f; eplisonR = %f\n', OutIter, eplisonIout, eplisonRout);
    end
    if(eplisonIout<vareps||eplisonRout<vareps)
        break;
    end
end


