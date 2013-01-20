function [a,b,mu,sigma,err] = bestGaussian(X,Y,debug)
% X(i) - sample point i (currently one dimensional)
% Y(i) - "label" for point i
if nargin < 3
    debug = 0;
end
options = optimset('GradObj','on');
if debug
    options = optimset(options, 'DerivativeCheck', 'on');
else
    options = optimset(options, 'Display', 'off');
end

scale = max(Y)-min(Y); % hack for optimization to converge
Y = Y / scale;

P0 = [(max(Y)-min(Y)), min(Y), mean(X), (max(X)-min(X)/10)];
P = fminunc(@f,P0,options,X,Y);
a = P(1) * scale;
b = P(2) * scale;
mu = P(3);
sigma = P(4);
err = f(P,X,Y);
end

function [val,grad] = f(P,X,Y)
a = P(1);
b = P(2);
mu = P(3);
sigma = P(4);

Zi = (X - mu) / sigma;
expPart = exp(-0.5*Zi.^2);
Fi = a*expPart + b; % gaussian value for all samples Xi
Di = Fi-Y; % difference from labels

% compute mean error (error is square difference)
val = mean(Di.^2);

% Compute the gradient
%%%%%%%%%%%%%%%%%%%%%%%%%%%
dE = 2*Di;

% grad_a
da = expPart;
grad_a = mean(dE .* da);

% grad_b
db = 1;
grad_b = mean(dE .* db);

% grad_mu
d_mu = a/sigma * Zi .* expPart;
grad_mu = mean(dE .* d_mu);

% grad_sigma
d_sigma = a/sigma * (Zi.^2) .* expPart;
grad_sigma = mean(dE .* d_sigma);

grad = [grad_a, grad_b, grad_mu, grad_sigma];
end