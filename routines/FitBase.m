classdef FitBase
    % mandatory interface
    methods (Abstract)
        s = name(obj)
        names = paramNames(obj)
        P = fitParams(obj,x,y,yTest,debug)
        y = fitValues(obj,x,P)
    end
    
    % default implementations (can be overriden)
    methods
        function [x,P] = testParamValues(obj)
            fprintf('No specific test parameters. Using defaults\n');
            paramNames = obj.paramNames();
            nParams = length(paramNames);
            if nParams == 0
                P = [];
            else
                P = 0.5 + 3*rand(1,nParams);
            end
            x = -5:0.1:5;
        end
        
        % allow cheating for testing purposes.
        % default implementation does nothing.
        function fitParamsHint(obj,yTest) 
        end
    end
end