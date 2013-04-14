classdef ExactFit < FitBase
    properties
        yTest
    end
    
    methods (Static)
        function s = name()
            s = 'Exact fit';
        end
        
        function names = paramNames()
            names = {};
        end
        
        function y = fitValues(~,P)
            y = P;
        end
    end
    
    methods
        function fitParamsHint(obj, yTest)
            obj.yTest = yTest;
        end

        function P = fitParams(obj,~,~,~,~)
            P = mean(obj.yTest,1);
        end        
    end
end
