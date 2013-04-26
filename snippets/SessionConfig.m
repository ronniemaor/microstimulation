classdef SessionConfig
    properties
        dataDir
    end
    
    methods
        function obj = SessionConfig(dataDir)
            obj.dataDir = dataDir;
        end
    end
end
