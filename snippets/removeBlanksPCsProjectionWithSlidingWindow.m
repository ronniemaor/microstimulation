function data = removeBlanksPCsProjectionWithSlidingWindow(data,parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    nPCs = take_from_struct(parms, 'nPCs', 2); % number of principal components to use
    b_use_blanks_for_projection = take_from_struct(parms,'use_blanks',true);
    b_center_blanks = take_from_struct(parms,'center_blanks',true);

    nBlanks = size(data.allBlanks,3);    
    mean_blank = mean(data.allBlanks,3);
    windowDelta = take_from_struct(parms,'windowDelta',5);

    if b_use_blanks_for_projection
        if b_center_blanks
            fprintf('Using centered blanks for projection\n')
            signal_for_projection = mean_blank - 1;
        else
            fprintf('Using non centered blanks for projection\n')
            signal_for_projection = mean_blank;
        end
    else
        fprintf('Using signal for projection\n')
        signal_for_projection = data.orig_signal;
    end
    
    nFrames = size(data.signal, 2);
    for frame = 1:nFrames
        % do PCA on blanks from current frame +/- windowDelta frames
        windowStart = max(frame-windowDelta, 1);
        windowEnd = min(frame+windowDelta, nFrames);
        fprintf('Computing PCA for frame %d based on frame window %d:%d\n', frame, windowStart, windowEnd);
        frameWindow = windowStart:windowEnd;
        X = data.allBlanks(:,frameWindow,:) ./ mean_blank(:,frameWindow,ones(1,nBlanks));
        [s1,s2,s3] = size(X);
        X = reshape(X,s1,s2*s3);  
        V = doPCA(X',nPCs);
        
        nTrials = size(data.signal,3);
        if b_use_blanks_for_projection
            % compute projection of blank frame on PCs
            x = signal_for_projection(:,frame);
            w = V' * x;
            proj  = V * w;

            % remove the projection from the signal
            data.signal(:,frame,:) = data.orig_signal(:,frame,:) - repmat(proj,[1 1 nTrials]);
        else
            for iTrial = 1:nTrials
                orig_signal = data.orig_signal(:,frame,iTrial);
                w = V' * orig_signal;
                proj  = V * w;
                data.signal(:,frame,iTrial) = orig_signal - proj;
            end
        end
    end
end