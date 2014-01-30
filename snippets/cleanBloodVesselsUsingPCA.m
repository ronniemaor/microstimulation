function [data,V,shapedV] = cleanBloodVesselsUsingPCA(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end

    V = getFirstPCs(data, parms);    
    
    % apply shape (default is NOP shape of all ones)
    shape = createPCAWeightingShape(data, parms);
    shapedV = zeros(size(V));
    for i=1:size(V,2)
        v = V(:,i) .* shape;
        v = v/norm(v); % renormalize PC
        shapedV(:,i) = v;
    end
    
    nFrames = size(data.signal,2);
    for frame = 1:nFrames
        r = calcCorrectionRatio(data, frame, V, parms);
        r = min(r);
        fprintf('frame=%d, r=%.3f\n', frame, r)
        nTrials = size(data.signal,3);
        for iTrial = 1:nTrials
            orig_signal = data.orig_signal(:,frame,iTrial);
            w = shapedV' * orig_signal; % get the weights from the shaped PC
            w = w .* r;
            proj = V * w; % apply the original PC with the "shaped weights"
            data.signal(:,frame,iTrial) = orig_signal - proj;
        end
    end
end

function r = calcCorrectionRatio(data, frame, V, parms)
    nPCs = size(V,2);
    r = take_from_struct(parms, 'r', 1);
    if frame == 1 % frame 1 causes problems. skip it.
        r = 1;
    end
    if isfloat(r)
        assert(r > 0)
        assert(r <= 1)
        r = r * ones(nPCs,1);
        return
    end
    assert(isequal(r,'auto'))
    
    % compute mean(abs(w(blank)))
    nTrials = size(data.allBlanks,3);
    wBlank = zeros(nPCs,1);
    for iTrial=1:nTrials
        x = data.allBlanks(:,frame,iTrial) - data.blank(:,frame);
        wBlank = wBlank + abs(V' * x);
    end
    wBlank = wBlank / nTrials;

    % compute mean(abs(w(signal)))
    nTrials = size(data.signal,3);
    wSignal = zeros(nPCs,1);
    for iTrial=1:nTrials
        x = data.signal(:,frame,iTrial);
        wSignal = wSignal + abs(V' * x);
    end
    wSignal = wSignal / nTrials;
    
    r = wBlank ./ wSignal;
end
