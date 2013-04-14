classdef GaussianFit < FitBase
    properties
        bDcShift
    end
    
    methods
        function obj = GaussianFit(bDcShift)
            if nargin < 1
                bDcShift = 0;
            end
            obj.bDcShift = bDcShift;
        end
        
        function s = name(obj)
            s = 'Gaussian fit';
            if obj.bDcShift
                s = [s, ' (with DC)'];
            end
        end
        
        function names = paramNames(obj)
            names = {'a', 'sigma'};
            if obj.bDcShift
                names{3} = 'b';
            end
        end
        
        function P = fitParams(obj,x,y,debug)
            % Input:
            %   X(i) - sample point i (currently one dimensional)
            %   Y(i) - target value for point i
            % Output:
            %   P
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
            if obj.bDcShift
                P0(3) = 0;
            end            
            P = fminunc(@f,P0,options,x,y);
            P(1) = P(1) * scale; % correct "a" for scaling Y
            P(2) = abs(P(2)); % sigma is symmetrical wrt sign. Keep it positive.
            if obj.bDcShift
                P(3) = P(3) * scale;
            end
        end
        
        function y = fitValues(obj,x,P)
            if obj.bDcShift
                [a,sigma,b] = unpack(P);
            else
                [a,sigma] = unpack(P);
                b = 0;
            end
            Zi = x / sigma;
            expPart = exp(-0.5*Zi.^2);
            y = a*expPart + b; % gaussian value for all samples Xi
        end
    end
end

function [val,grad] = f(P,X,Y)
    bDcShift = length(P) == 3;
    if bDcShift
        [a,sigma,b] = unpack(P);
    else
        [a,sigma] = unpack(P);
        b = 0;
    end
    Zi = X / sigma;
    expPart = exp(-0.5*Zi.^2);
    Fi = a*expPart + b; % gaussian value for all samples Xi
    DY = Fi-Y; % difference from labels

    % compute mean error (error is square difference)
    val = 0.5*mean(DY.^2);

    % Compute the gradient
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    dE = DY;

    % grad_a
    d_a = expPart;
    grad_a = mean(dE .* d_a);

    % grad_sigma
    d_sigma = a/sigma * (Zi.^2) .* expPart;
    grad_sigma = mean(dE .* d_sigma);

    % grad_b
    if bDcShift
        d_b = 1;
        grad_b = mean(dE .* d_b);
    end
    
    grad = [grad_a, grad_sigma];
    if bDcShift
        grad(3) = grad_b;
    end    
end