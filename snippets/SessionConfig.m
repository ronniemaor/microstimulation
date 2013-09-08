classdef SessionConfig
    properties
        dataDir
        microAmp
        pulseInterval
        trainDuration
        electrodeDepth
        manualPeakPosition
        manualMaskFunction
    end
    
    methods
        function obj = SessionConfig(dataDir, microAmp, pulseInterval, trainDuration, electrodeDepth)
            obj.dataDir = dataDir;
            obj.microAmp = microAmp;
            obj.pulseInterval = pulseInterval;
            obj.trainDuration = trainDuration;
            obj.electrodeDepth = electrodeDepth;
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
