function data = cleanBloodVesselsUsingPCA(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    method = take_from_struct(parms, 'method', 'frame blanks');    
    nPCs = take_from_struct(parms, 'nPCs', 2); % number of principal components to use

    if isequal(method, 'NOP')
        data.signal = data.orig_signal;
        return;
    elseif isequal(method, 'blanks')        
        X = data.allBlanks(:,3:30,:);
    elseif isequal(method, 'frame blanks')
        frameRange = 20:50;
        nBlanks = size(data.allBlanks,3);
        mean_blank = mean(data.allBlanks,3);
        X = data.allBlanks(:,frameRange,:) ./ mean_blank(:,frameRange,ones(1,nBlanks));
    elseif isequal(method, 'frame stims')
        frameRange = 3:24;
        nStims = size(data.stims,3);
        mean_blank = mean(data.allBlanks,3);
        X = data.stims(:,frameRange,:) ./ mean_blank(:,frameRange,ones(1,nStims));
    else
        assert(false, 'unknown method: %s', method);
    end
    [s1,s2,s3] = size(X);
    X = reshape(X,s1,s2*s3);
    
    V = doPCA(X',nPCs);
    
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