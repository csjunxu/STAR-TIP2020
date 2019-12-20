function [L, R, t] = jpr(S, alpha, beta, lambda)

r=5;
r0=3;
eps=0.0001;
K=20;
B=convMax(single(S),r0);
B = guidedfilter(S, B, 20, 10^-3);

L=S;
R=ones(size(S));

tic
for iter = 1:K
    %% Solve L
    L_old=L;
    R_old=R;
    
    L=S./R;
	Lx = diff(L,1,2); Lx = padarray(Lx, [0 1], 'post');
	Ly = diff(L,1,1); Ly = padarray(Ly, [1 0], 'post');
    gLx=convBox( single(Lx), r);
    gLy=convBox( single(Ly), r);
    %Lxy=sqrt(Lx.^2+Ly.^2);
    
    WLx = max(abs(gLx.*Lx),eps).^(-1);
    WLy = max(abs(gLy.*Ly),eps).^(-1);
    WLx(:,end) = 0;
    WLy(end,:) = 0;
    
    L = solveLinearEquation(S, R, WLx, WLy, alpha, B, lambda);
    normL = norm(L-L_old, 'fro')/norm(L_old, 'fro');
    %L = max(L,S);
    
    %% Solve R
    R=S./L;
    Rx = diff(R,1,2); Rx = padarray(Rx, [0 1], 'post');
	Ry = diff(R,1,1); Ry = padarray(Ry, [1 0], 'post');
    WRx = max(abs(Rx),eps).^(-1);
    WRy = max(abs(Ry),eps).^(-1);
    WRx(:,end) = 0;
    WRy(end,:) = 0;
    
    R = solveLinearEquation(S, L, WRx, WRy, beta, B, 0);
    normR = norm(R-R_old, 'fro')/norm(R_old, 'fro');
    R = max(R,0);
    if(normL<0.01&&normR<0.01)
        break;
    end

end 

t=toc;
end
