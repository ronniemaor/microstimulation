classdef SessionConfig
    properties
        dataDir
        microAmp
        pulseInterval
        trainDuration
        electrodeDepth
        manualPeakPosition
        noiseMaskFunction
    end
    
    methods
        function obj = SessionConfig(dataDir, microAmp, pulseInterval, trainDuration, electrodeDepth)
            obj.dataDir = dataDir;
            obj.microAmp = microAmp;
            obj.pulseInterval = pulseInterval;
            obj.trainDuration = trainDuration;
            obj.electrodeDepth = electrodeDepth;
            obj.manualPeakPosition = [];
            obj.noiseMaskFunction = [];
        end
        
        function obj = manualPeak(obj, cX, cY)
            obj.manualPeakPosition = [cX,cY];
        end
        
        function obj = noiseMask(obj, f)
            obj.noiseMaskFunction = f;
        end
    end
end
