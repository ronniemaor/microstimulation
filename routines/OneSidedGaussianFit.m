classdef OneSidedGaussianFit
    methods (Static)
        function s = name()
            s = 'One Sided Gaussian fit';
        end
        
        function names = paramNames()
            names = {'a', 'sigma'};
        end
        
        function P = fitParams(x,y,~,debug)
            % Input:
            %   X(i) - sample point i (currently one dimensional)
            %   Y(i) - target value for point i
            % Output:
            %   [a,sigma] = unpack(P)
            if nargin < 4
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

            P0 = [(max(y)-min(y)), (max(x)-min(x)/10)];
            P = fminunc(@f,P0,options,x,y);
            P(1) = P(1) * scale; % correct "a" for scaling Y
            P(2) = abs(P(2)); % sigma is symmetrical wrt sign. Keep it positive.
        end
        
        function y = fitValues(x,P)
            [a,sigma] = unpack(P);
            Zi = x / sigma;
            expPart = exp(-0.5*Zi.^2);
            y = a*expPart; % gaussian value for all samples Xi
        end
    end
end

function [val,grad] = f(P,X,Y)
    [a,sigma] = unpack(P);
    Zi = X / sigma;
    expPart = exp(-0.5*Zi.^2);
    Fi = a*expPart; % gaussian value for all samples Xi
    Di = Fi-Y; % difference from labels

    % compute mean error (error is square difference)
    val = mean(Di.^2);

    % Compute the gradient
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    dE = 2*Di;

    % grad_a
    d_a = expPart;
    grad_a = mean(dE .* d_a);

    % grad_sigma
    d_sigma = a/sigma * (Zi.^2) .* expPart;
    grad_sigma = mean(dE .* d_sigma);

    grad = [grad_a, grad_sigma];
end