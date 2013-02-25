function res = calcR2(x,y)
% Compute R2 (explained variance) as the square of the 
% correlation between x and y.
% x,y should be one dimensional vectors of same length. 
% The function can work with either row or column vectors.
    rho = corr(x(:),y(:));
    res = rho^2;
end