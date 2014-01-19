function [V,d,C] = doPCA(X,k)
    % Get first k PCs from X.
    % Input:
    %   X - An n x m matrix: n samples of vectors having m features each.
    %   k - Number of PCs to return.
    % Output:
    %   V - The first k eigenvectors of the correlation matrix.
    %       V is an n x k matrix. Column j is PC number j.
    %   d - The first k eigenvalues.
    %   C - The m x m correlation matrix
    X = X - repmat(mean(X),size(X,1),1);
    C = X'*X;
    [V,D] = eigs(C,k);
    d = diag(D);
end