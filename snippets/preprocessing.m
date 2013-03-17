[blank, stims] = preprocessSession(dataDir);
filename = [dataDir,'/preprocessed'];
fprintf('Saving to %s\n', filename)
save(filename, 'blank', 'stims')