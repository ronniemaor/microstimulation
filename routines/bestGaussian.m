function [a,b,mu,sigma] = bestGaussian(X,Y)
% X(i) - sample point i (currently one dimensional)
% Y(i) - "label" for point i
P0 = [(max(Y)-min(Y)), min(Y), mean(X), (max(X)-min(X)/10)];
options = optimset('GradObj','off');
P = fminunc(@f,P0,options,X,Y);
a = P(1);
b = P(2);
mu = P(3);
sigma = P(4);
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
dE = 2*Fi;

% grad_a
da = expPart;
grad_a = mean(dE .* da);

% grad_b
db = 1;
grad_b = mean(dE .* db);

% grad_mu
d_mu = - a/sigma * Zi .* expPart;
grad_mu = mean(dE .* d_mu);

% grad_sigma
d_sigma = a/sigma * (Zi.^2) .* expPart;
grad_sigma = mean(dE .* d_sigma);

grad = [grad_a, grad_b, grad_mu, grad_sigma];
end