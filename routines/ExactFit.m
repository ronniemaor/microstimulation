classdef ExactFit < FitBase
    methods (Static)
        function s = name()
            s = 'Exact fit';
        end
        
        function names = paramNames()
            names = {};
        end
        
        function P = fitParams(~,~,yTest,~)
            % Input:
            %   X(i) - sample point i (ignored)
            %   Y(i) - target value for point i (ignored)
            %   yTest(j,i) - target test values (several rows of points)
            %   
            % Output:
            %   P = fit parameters (which is actually the fit)
            P = mean(yTest,1);
        end
        
        function y = fitValues(~,P)
            y = P;
        end
    end
end
