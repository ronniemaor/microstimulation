classdef ExponentialFit
    methods (Static)
        function s = name()
            s = 'Exponential fit';
        end
        
        function names = paramNames()
            names = {'a', 'x0', 'alpha', 'beta'};
        end
        
        function P = fitParams(x,y,debug)
            % Input:
            %   X(i) - sample point i (currently one dimensional)
            %   Y(i) - target value for point i
            % Output:
            %   [a,x0,alpha,beta] = unpack(P)
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

            P0 = [1, 0, max(x)/2, -min(x)/2];
            P = fminunc(@f,P0,options,x,y);
            P(1) = P(1) * scale; % correct "a" for scaling Y
        end
        
        function y = fitValues(x,P)
            [a,x0,alpha,beta] = unpack(P);
            DX = x - x0;
            alphaRange = x >= x0;
            betaRange = ~alphaRange;
            Pi = zeros(size(DX));
            Pi(alphaRange) = -alpha * DX(alphaRange);
            Pi(betaRange) = beta * DX(betaRange);
            y = a*exp(Pi);
        end
    end
end

function [val,grad] = f(P,X,Y)
[a,x0,alpha,beta] = unpack(P);
alphaRange = X >= x0;
betaRange = ~alphaRange;
DX = X - x0;
Pi = zeros(size(DX));
Pi(X >= x0) = -alpha * DX(X >= x0);
Pi(X < x0) = beta * DX(X < x0);
Fi = a*exp(Pi);

DY = Fi-Y;

% compute mean error (error is square difference)
val = 0.5*mean(DY.^2);

% Compute the gradient
%%%%%%%%%%%%%%%%%%%%%%%%%%%
dE = DY;

% grad_a
da = Fi/a;
grad_a = mean(dE .* da);

% grad_x0
d_x0 = Fi;
d_x0(alphaRange) = d_x0(alphaRange) * alpha;
d_x0(betaRange) = d_x0(betaRange) * (-beta);
grad_x0 = mean(dE .* d_x0);

% grad_alpha
d_alpha = Fi .* (-DX) ;
d_alpha(betaRange) = 0;
grad_alpha = mean(dE .* d_alpha);

% grad_alpha
d_beta = Fi .* DX ;
d_beta(alphaRange) = 0;
grad_beta = mean(dE .* d_beta);

grad = [grad_a, grad_x0, grad_alpha, grad_beta];
end