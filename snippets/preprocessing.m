dataDir = 'C:\data\zuta\Leg\leg_2009_01_29\c';
[blank, stims] = preprocessSession(dataDir, '2901');
filename = [dataDir,'\preprocessed'];
fprintf('Saving to %s\n', filename)
save(filename, 'blank', 'stims')