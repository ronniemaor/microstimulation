classdef ExponentialFit
    properties
        bDcShift
    end
    
    methods
        function obj = ExponentialFit(bDcShift)
            if nargin < 1
                bDcShift = 0;
            end
            obj.bDcShift = bDcShift;
        end
        
        function s = name(obj)
            s = 'Exponential fit';
            if obj.bDcShift
                s = [s, ' (with DC)'];
            end
        end
        
        function names = paramNames(obj)
            names = {'a', 'alpha'};
            if obj.bDcShift
                names{3} = 'b';
            end
        end
        
        function [x,P] = testParamValues(obj)
            x = 0:0.1:5;
            P = ones(1, length(obj.paramNames()));
        end
        
        function P = fitParams(obj, x,y,~,debug)
            % Input:
            %   X(i) - sample point i (currently one dimensional)
            %   Y(i) - target value for point i
            % Output:
            %   P
            if nargin < 5
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

            P0 = [1, max(x)/2];
            if obj.bDcShift
                P0(3) = 0;
            end
            P = fminunc(@f,P0,options,x,y);
            P(1) = P(1) * scale; % correct "a" for scaling Y
            if obj.bDcShift
                P(3) = P(3) * scale;
            end
        end
        
        function y = fitValues(obj,x,P)
            if obj.bDcShift
                [a,alpha,b] = unpack(P);
            else
                [a,alpha] = unpack(P);
                b = 0;
            end
            y = a*exp(-alpha*x) + b;
        end
    end
end

function [val,grad] = f(P,X,Y)
    bDcShift = length(P) == 3;
    if bDcShift
        [a,alpha,b] = unpack(P);
    else
        [a,alpha] = unpack(P);
        b = 0;
    end
    Fi = a*exp(-alpha*X) + b;

    DY = Fi-Y;

    % compute mean error (error is square difference)
    val = 0.5*mean(DY.^2);

    % Compute the gradient
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    dE = DY;

    % grad_a
    d_a = (Fi-b)/a;
    grad_a = mean(dE .* d_a);

    % grad_alpha
    d_alpha = (Fi-b) .* (-X) ;
    grad_alpha = mean(dE .* d_alpha);
    
    % grad_b
    if bDcShift
        d_b = 1;
        grad_b = mean(dE .* d_b);
    end

    grad = [grad_a, grad_alpha];
    if bDcShift
        grad(3) = grad_b;
    end
end