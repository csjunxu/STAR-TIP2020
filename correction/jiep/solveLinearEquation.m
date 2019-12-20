function u = solveLinearEquation(s, p, wx, wy, lambda1, b, lambda2, method)
    if (~exist('method','var'))
       method='pcg';
    end   

    [m, n]=size(s);
    mn=m*n;
    
    wx = wx(:);
    wy = wy(:);
    ux = padarray(wx, m, 'pre'); ux = ux(1:end-m);
    uy = padarray(wy, 1, 'pre'); uy = uy(1:end-1);
    D = wx+ux+wy+uy;
    T = spdiags([-wx, -wy],[-m,-1],mn,mn);
    Lg = T + T' + spdiags(D, 0, mn, mn);
    
    PP=p.^2;
    PP=spdiags(PP(:),0,mn,mn); 
    A=PP+lambda1*Lg+lambda2*speye(mn,mn);  
    
    sp=p.*s+lambda2*b;
    switch method
        case 'pcg'
            L = ichol(A,struct('michol','on'));    
            [u,~] = pcg(A, sp(:),0.01,40, L, L'); 
        case 'minres'
            [u,~] = minres(A,sp(:),0.01,40);
        case 'bicg'
            [L,U] = ilu(A,struct('type','ilutp','droptol',0.01));
            [u,~] = bicg(A,sp(:),0.01,40,L,U);
        case 'direct'
            [u,~] = A\sp(:); %#ok<RHSFN>
    end
    u = reshape(u, m, n);
end