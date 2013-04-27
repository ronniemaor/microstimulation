classdef SessionConfig
    properties
        dataDir
        manualPeakPosition = [];
    end
    
    methods
        function obj = SessionConfig(dataDir)
            obj.dataDir = dataDir;
        end
        
        function obj = manualPeak(obj, cX, cY)
            obj.manualPeakPosition = [cX,cY];
        end
    end
end
