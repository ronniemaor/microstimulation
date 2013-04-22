setupPath
close all
clear all
setDataDir
[blank, stims, rawBlank] = preprocessSession(dataDir);
filename = [dataDir,'/preprocessed'];
fprintf('Saving to %s\n', filename)
save(filename, 'blank', 'stims', 'rawBlank')