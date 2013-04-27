classdef SessionConfig
    properties
        dataDir
        manualPeakPosition
        manualMaskFunction
    end
    
    methods
        function obj = SessionConfig(dataDir)
            obj.dataDir = dataDir;
            obj.manualPeakPosition = [];
            obj.manualMaskFunction = [];
        end
        
        function obj = manualPeak(obj, cX, cY)
            obj.manualPeakPosition = [cX,cY];
        end
        
        function obj = manualMask(obj, f)
            obj.manualMaskFunction = f;
        end
    end
end
