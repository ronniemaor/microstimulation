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
            corrected_signal = remove_contribution(orig_signal,V);
            data.signal(:,frame,iTrial) = corrected_signal;
        end
    end
end

function x = remove_contribution(x,V)
    nPCs = size(V,2);
    proj = zeros(size(x));
    for i=1:nPCs % TODO - remove the loop
        pc = V(:,i);
        alpha = pc' * x;
        proj = proj + alpha*pc;
    end
    x = x - proj;
end