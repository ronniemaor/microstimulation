function [a,mu,sigma,R2] = bestGaussian(X,Y,debug)
% X(i) - sample point i (currently one dimensional)
% Y(i) - target value for point i
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

P0 = [(max(Y)-min(Y)), mean(X), (max(X)-min(X)/10)];
P = fminunc(@f,P0,options,X,Y);
a = P(1) * scale;
mu = P(2);
sigma = P(3);
R2 = explainedVariance(P,X,Y);
end

function R2 = explainedVariance(P,X,Y)
a = P(1);
mu = P(2);
sigma = P(3);

Zi = (X - mu) / sigma;
expPart = exp(-0.5*Zi.^2);
Fi = a*expPart; % gaussian value for all samples Xi

rho = corr(Y',Fi');
R2 = rho^2;
end

function [val,grad] = f(P,X,Y)
a = P(1);
mu = P(2);
sigma = P(3);

Zi = (X - mu) / sigma;
expPart = exp(-0.5*Zi.^2);
Fi = a*expPart; % gaussian value for all samples Xi
Di = Fi-Y; % difference from labels

% compute mean error (error is square difference)
val = mean(Di.^2);

% Compute the gradient
%%%%%%%%%%%%%%%%%%%%%%%%%%%
dE = 2*Di;

% grad_a
da = expPart;
grad_a = mean(dE .* da);

% grad_mu
d_mu = a/sigma * Zi .* expPart;
grad_mu = mean(dE .* d_mu);

% grad_sigma
d_sigma = a/sigma * (Zi.^2) .* expPart;
grad_sigma = mean(dE .* d_sigma);

grad = [grad_a, grad_mu, grad_sigma];
end