function [V,d,C] = doPCA(X,k)
    X = X - repmat(mean(X),size(X,1),1);
    C = X'*X;
    [V,D] = eigs(C,k);
    d = diag(D);
end