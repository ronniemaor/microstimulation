function pc1 = cleanBloodVesselsUsingPCA(sessionKey)
    data = findPeak(loadData(sessionKey));
    frame = data.peakFrame;

    blanks = getAllBlanks(sessionKey);
    X = blanks(:,3:30,:);
    %X = blanks(:,frame,:);
    [s1,s2,s3] = size(X);
    X = reshape(X,s1,s2*s3);
    [V,d,C] = doPCA(X',1);
    pc1 = V(:,1);
    
    mean_stim = mean(data.stims(:,frame,:),3);
    mean_blank = data.blank(:,frame);
    projected_stim = remove_contribution(mean_stim,V);
    projected_blank = remove_contribution(mean_blank,V);
    signal = (projected_stim ./ projected_blank) - 1;
    signal(~data.origMask) = 0;
    
    dynamicRange = 2e-3;
    figure;
    mimg(signal,100,100,-dynamicRange,dynamicRange,' ');
    colormap(mapgeog);
end

function allBlanks = getAllBlanks(sessionKey)
    [blank, stims, rawBlank, mask, allBlanks] = preprocessSession(getSessionDataDir(sessionKey));
end

function x = remove_contribution(x,V)
    return;
    nPCs = size(V,2);
    for i=1:nPCs % TODO - remove the loop
        pc = V(:,i);
        alpha = pc' * x;
        x = x - alpha*x;
    end
end