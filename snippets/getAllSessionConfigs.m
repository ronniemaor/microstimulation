function sessionConfigs = getAllSessionConfigs()
    % SessionConfig(dataDir, microAmp, pulseInterval, trainDuration, electrodeDepth)
    
    sessionConfigs = containers.Map();
    sessionConfigs('J29c') = SessionConfig('Leg/leg_2009_01_29/c',70,3,15,0);
    sessionConfigs('J29g') = SessionConfig('Leg/leg_2009_01_29/g',70,3,60,250);
    sessionConfigs('J29i') = SessionConfig('Leg/leg_2009_01_29/i',90,3,90,250);
    sessionConfigs('J29j') = SessionConfig('Leg/leg_2009_01_29/j',90,3,90,500);
    
    sessionConfigs('M18b') = SessionConfig('Leg/leg_2009_03_18/b',70,2,80,200).manualMask(@(x,y) y<60);
    sessionConfigs('M18c') = SessionConfig('Leg/leg_2009_03_18/c',70,2,80,400).manualMask(@(x,y) y<60).manualPeak(39,14);
    sessionConfigs('M18d') = SessionConfig('Leg/leg_2009_03_18/d',70,2,80,600).manualMask(@(x,y) y<60).manualPeak(41,15);
    sessionConfigs('M18e') = SessionConfig('Leg/leg_2009_03_18/e',70,2,80,800).manualMask(@(x,y) y<60).manualPeak(40,21);
    
    sessionConfigs('J26a') = SessionConfig('Arg/2008_06_26/a',50,3,240,0).manualPeak(59,74);
    sessionConfigs('J26b') = SessionConfig('Arg/2008_06_26/b',80,3,240,0).manualPeak(56,75);
    sessionConfigs('J26c') = SessionConfig('Arg/2008_06_26/c',80,3,240,150).manualPeak(56,77);
end
