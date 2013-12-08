function cleanBloodVesselsUsingPCA(sessionKey, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    method = take_from_struct(parms, 'method', 'frame blanks');    
    nPCs = take_from_struct(parms, 'nPCs', 2); % number of principal components to use
    bShowOrig = take_from_struct(parms, 'showOrig', true);
    apply_on_signal = take_from_struct(parms, 'apply_on_signal', true);

    data = findPeak(loadData(sessionKey));
    frame = take_from_struct(parms, 'frame', data.peakFrame);

    blanks = getAllBlanks(sessionKey);
    nBlanks = size(blanks,3);
    if isequal(method, 'blanks')
        X = blanks(:,3:30,:);
        [s1,s2,s3] = size(X);
        X = reshape(X,s1,s2*s3);        
    elseif isequal(method, 'frame blanks')
        X = blanks(:,frame,:);
        X = squeeze(X);
    elseif isequal(method, 'stimulus')
        X = data.stims(:,30:35,:);
        [s1,s2,s3] = size(X);
        X = reshape(X,s1,s2*s3);        
    elseif isequal(method, 'frame signal - over blanks')
        mean_stim = squeeze(mean(data.stims(:,frame,:),3));
        frame_blanks = squeeze(blanks(:,frame,:));
        signal = (repmat(mean_stim,1,nBlanks) ./ frame_blanks) - 1;
        X = signal;
    elseif isequal(method, 'frame signal - over stims')
        frame_stims = squeeze(data.stims(:,frame,:));
        nStims = size(frame_stims,2);
        mean_blank = squeeze(mean(blanks(:,frame,:),3));
        signal = (frame_stims ./ repmat(mean_blank,1,nStims)) - 1;
        X = signal;
    else
        assert(false, 'unknown method: %s', method);
    end
    
    V = doPCA(X',nPCs);
    
    mean_stim = mean(data.stims(:,frame,:),3);
    mean_blank = data.blank(:,frame);
    orig_signal = (mean_stim ./ mean_blank) - 1;
    
    if apply_on_signal
        corrected_signal = remove_contribution(orig_signal,V);
    else
        % apply separately to stimulus and blanks, then divide
        projected_stim = remove_contribution(mean_stim,V);
        projected_blank = remove_contribution(mean_blank,V);
        corrected_signal = (projected_stim ./ projected_blank) - 1;
        corrected_signal(~data.origMask) = 0; % needs fixing after projections
    end
    
    if bShowOrig
        drawOne(orig_signal, 2e-3, sprintf('%s@%d - original',sessionKey, frame));
    end
    drawOne(corrected_signal, 2e-3, sprintf('%s@%d after %d PC removal (%s)',sessionKey,frame,nPCs,method));
end

function drawOne(signal, dynamicRange, ttl)
    figure;
    mimg(signal,100,100,-dynamicRange,dynamicRange,' ');
    colormap(mapgeog);
    title(ttl)
end

function allBlanks = getAllBlanks(sessionKey)
    dataDir = getSessionDataDir(sessionKey);
    filename = [dataDir,'/all_blanks.mat'];
    if exist(filename,'file')
        filedata = load(filename);
        allBlanks = filedata.allBlanks;
        return;
    end

    [blank, stims, rawBlank, mask, allBlanks] = preprocessSession(getSessionDataDir(sessionKey));    
    fprintf('***** Saving preprocessed data to %s\n', filename)
    save(filename, 'allBlanks')
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