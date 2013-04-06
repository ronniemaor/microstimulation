classdef OneSidedExponentialFit
    methods (Static)
        function s = name()
            s = 'One Sided Exponential fit';
        end
        
        function names = paramNames()
            names = {'a', 'alpha'};
        end
        
        function [x,P] = testParamValues()
            x = 0:0.1:5;
            P = [1, 1];
        end
        
        function P = fitParams(x,y,~,debug)
            % Input:
            %   X(i) - sample point i (currently one dimensional)
            %   Y(i) - target value for point i
            % Output:
            %   [a,alpha] = unpack(P)
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

            P0 = [1, max(x)/2];
            P = fminunc(@f,P0,options,x,y);
            P(1) = P(1) * scale; % correct "a" for scaling Y
        end
        
        function y = fitValues(x,P)
            [a,alpha] = unpack(P);
            y = a*exp(-alpha*x);
        end
    end
end

function [val,grad] = f(P,X,Y)
    [a,alpha] = unpack(P);
    Fi = a*exp(-alpha*X);

    DY = Fi-Y;

    % compute mean error (error is square difference)
    val = 0.5*mean(DY.^2);

    % Compute the gradient
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    dE = DY;

    % grad_a
    d_a = Fi/a;
    grad_a = mean(dE .* d_a);

    % grad_alpha
    d_alpha = Fi .* (-X) ;
    grad_alpha = mean(dE .* d_alpha);

    grad = [grad_a, grad_alpha];
end