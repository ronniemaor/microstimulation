classdef SessionConfig
    properties
        dataDir
        microAmp
        pulseInterval
        trainDuration
        electrodeDepth
        hasV2
        manualPeakPosition
        manualMaskFunction
    end
    
    methods
        function obj = SessionConfig(dataDir, microAmp, pulseInterval, trainDuration, electrodeDepth, hasV2)
            obj.dataDir = dataDir;
            obj.microAmp = microAmp;
            obj.pulseInterval = pulseInterval;
            obj.trainDuration = trainDuration;
            obj.electrodeDepth = electrodeDepth;
            obj.hasV2 = hasV2;
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
