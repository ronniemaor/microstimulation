function s = formatStimulationParams(sessionKey)
    config = getSessionConfig(sessionKey);
    s = sprintf('%d\\muA, %dms, train %dms, %d\\mum down', config.microAmp, config.pulseInterval, config.trainDuration, config.electrodeDepth);     
end