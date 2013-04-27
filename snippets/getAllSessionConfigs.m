function sessionConfigs = getAllSessionConfigs()
    sessionConfigs = containers.Map();
    sessionConfigs('J29c') = SessionConfig('Leg/leg_2009_01_29/c');
    sessionConfigs('J29g') = SessionConfig('Leg/leg_2009_01_29/g');
    sessionConfigs('J29i') = SessionConfig('Leg/leg_2009_01_29/i');
    % sessionConfigs('J29j') = SessionConfig('Leg/leg_2009_01_29/j');
    
    sessionConfigs('M18b') = SessionConfig('Leg/leg_2009_03_18/b').manualMask(@(x,y) y<60);
    sessionConfigs('M18c') = SessionConfig('Leg/leg_2009_03_18/c').manualMask(@(x,y) y<60).manualPeak(39,14);
    sessionConfigs('M18d') = SessionConfig('Leg/leg_2009_03_18/d').manualMask(@(x,y) y<60).manualPeak(41,15);
    sessionConfigs('M18e') = SessionConfig('Leg/leg_2009_03_18/e').manualMask(@(x,y) y<60).manualPeak(40,21);
    % sessionConfigs('A1d') = SessionConfig('Leg/leg_2009_04_01/d');    
end