function dst = solveLinearSystem(s, ir, uvx, uvy, alphabet, b, lambda, method)
    if (~exist('b','var'))
       b = 0;
       lambda = 0;
    end
    if (~exist('method','var'))
       method = 'pcg';
    end

    [h, w] = size(s);
    hw = h * w;
    %% calculate the five-point positive definite Laplacian matrix
    uvx = uvx(:);
    uvy = uvy(:);
    ux = padarray(uvx, h, 'pre'); ux = ux(1:end-h);
    uy = padarray(uvy, 1, 'pre'); uy = uy(1:end-1);
    D = uvx+ux+uvy+uy;
    T = spdiags([-uvx, -uvy],[-h,-1],hw,hw);
    %% calculate the variable of linear system
    MN = T + T' + spdiags(D, 0, hw, hw);                % M in Eq.(12) or N in Eq.(13)    
    ir2 = ir.^2;                                        % R^{T}R in Eq.(12) or I^{T}I in Eq.(13)
    ir2 = spdiags(ir2(:),0,hw,hw); 
    DEN = ir2 + alphabet * MN + lambda * speye(hw,hw);  % denominator in Eq.(12) or Eq.(13)
    NUM = ir.*s + lambda * b;                           % numerator in Eq.(12) or Eq.(13) 
    %% solve the linear system
    switch method
        case 'pcg'
            L = ichol(DEN,struct('michol','on'));    
            [dst,~] = pcg(DEN, NUM(:), 0.01, 40, L, L'); 
        case 'minres'
            [dst,~] = minres(DEN,NUM(:), 0.01, 40);
        case 'bicg'
            [L,U] = ilu(DEN,struct('type','ilutp','droptol',0.01));
            [dst,~] = bicg(DEN,NUM(:), 0.01, 40, L, U);
        case 'direct'
            [dst,~] = DEN\NUM(:); %#ok<RHSFN>
    end
    dst = reshape(dst, h, w);
end