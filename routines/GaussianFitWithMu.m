classdef GaussianFitWithMu < FitBase
    methods (Static)
        function s = name()
            s = 'Gaussian fit';
        end
        
        function names = paramNames()
            names = {'a', 'mu', 'sigma'};
        end
        
        function P = fitParams(x,y,debug)
            % Input:
            %   X(i) - sample point i (currently one dimensional)
            %   Y(i) - target value for point i
            % Output:
            %   [a,mu,sigma] = unpack(P)
            if nargin < 3
                debug = 0;
            end
            options = optimset('GradObj','on');
            if debug
                options = optimset(options, 'DerivativeCheck', 'on');
            else
                options = optimset(options, 'Display', 'off');
            end

            scale = max(y)-min(y); % hack for optimization to converge
            y = y / scale;

            P0 = [(max(y)-min(y)), mean(x), (max(x)-min(x)/10)];
            P = fminunc(@f,P0,options,x,y);
            P(1) = P(1) * scale; % correct "a" for scaling Y
            P(3) = abs(P(3)); % sigma is symmetrical wrt sign. Keep it positive.
        end
        
        function y = fitValues(x,P)
            [a,mu,sigma] = unpack(P);
            Zi = (x - mu) / sigma;
            expPart = exp(-0.5*Zi.^2);
            y = a*expPart; % gaussian value for all samples Xi
        end
    end
end

function [val,grad] = f(P,X,Y)
[a,mu,sigma] = unpack(P);
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