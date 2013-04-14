classdef TwoSidedGaussianFit < FitBase
    methods (Static)
        function s = name()
            s = 'DoubleGaussian fit';
        end
        
        function names = paramNames()
            names = {'a', 'mu', 'sigmaP', 'sigmaM'};
        end
        
        function [x,P] = testParamValues()
            x = -5:0.1:5;
            P = [1, 1, 1, 3];
        end
        
        function P = fitParams(x,y,~,debug)
            % Input:
            %   X(i) - sample point i (currently one dimensional)
            %   Y(i) - target value for point i
            % Output:
            %   [a,mu,sigmaP,sigmaM] = unpack(P)
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

            sigma0 = (max(x)-min(x)/10);
            P0 = [(max(y)-min(y)), mean(x), sigma0, sigma0];
            P = fminunc(@f,P0,options,x,y);
            P(1) = P(1) * scale; % correct "a" for scaling Y
            % sigmaP and sigmaM are symmetrical wrt sign. Keep them positive.
            P(3) = abs(P(3));
            P(4) = abs(P(4));
        end
        
        function y = fitValues(x,P)
            [a,mu,sigmaP,sigmaM] = unpack(P);
            DX = x - mu;
            plusRange = x >= mu;
            minusRange = ~plusRange;
            Zi = zeros(size(DX));
            Zi(plusRange) = DX(plusRange)/sigmaP;
            Zi(minusRange) = DX(minusRange)/sigmaM;
            expPart = exp(-0.5*Zi.^2);
            y = a*expPart; % gaussian value for all samples Xi
        end
    end
end

function [val,grad] = f(P,X,Y)
[a,mu,sigmaP,sigmaM] = unpack(P);
plusRange = X >= mu;
minusRange = ~plusRange;
DX = X - mu;
Zi = zeros(size(DX));
Zi(plusRange) = DX(plusRange)/sigmaP;
Zi(minusRange) = DX(minusRange)/sigmaM;
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
d_mu = a * Zi .* expPart;
d_mu(plusRange) = d_mu(plusRange) / sigmaP;
d_mu(minusRange) = d_mu(minusRange) / sigmaM;
grad_mu = mean(dE .* d_mu);

% grad_sigmaP
d_sigmaP = a/sigmaP * (Zi.^2) .* expPart;
d_sigmaP(minusRange) = 0;
grad_sigmaP = mean(dE .* d_sigmaP);

% grad_sigmaM
d_sigmaM = a/sigmaM * (Zi.^2) .* expPart;
d_sigmaM(plusRange) = 0;
grad_sigmaM = mean(dE .* d_sigmaM);

grad = [grad_a, grad_mu, grad_sigmaP, grad_sigmaM];
end