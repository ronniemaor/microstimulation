function tmp()
    allSessions = getAllSessionConfigs();
    for cSession = allSessions.keys()
        sessionKey = cSession{1};
        data = loadData(sessionKey);
        data = findPeak(data);
        dt = 10*(data.peakFrame-25);
        fprintf('Peak for %s at frame %d (%.2f msec after stimulation)\n', sessionKey, data.peakFrame, dt)
    end

end