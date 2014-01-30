function data = cleanBloodVesselsUsingPCA(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    V = getFirstPCs(data, parms);

    nFrames = size(data.signal,2);
    for frame = 1:nFrames
        nTrials = size(data.signal,3);
        for iTrial = 1:nTrials
            orig_signal = data.orig_signal(:,frame,iTrial);
            w = V' * orig_signal;
            proj = V * w;
            data.signal(:,frame,iTrial) = orig_signal - proj;
        end
    end
end
