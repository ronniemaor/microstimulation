function [data,V,shapedV] = cleanBloodVesselsUsingPCA(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end

    r = take_from_struct(parms, 'r', 1.0);
    
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
        nTrials = size(data.signal,3);
        for iTrial = 1:nTrials
            orig_signal = data.orig_signal(:,frame,iTrial);
            w = shapedV' * orig_signal; % get the weights from the shaped PC
            proj = V * w; % apply the original PC with the "shaped weights"
            data.signal(:,frame,iTrial) = orig_signal - r*proj;
        end
    end
end
