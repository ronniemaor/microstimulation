function drawBloodVessels(data, bShowSlices, bMarkVessels)
    if ~exist('bShowSlices','var')
        bShowSlices = 1;
    end
    
    if ~exist('bMarkVessels','var')
        bMarkVessels = 0;
    end
    
    blVes = mean(data.rawBlank(:,2:100),2);
    blVes = mfilt2(blVes,100,100,2,'hm');
    
    if bShowSlices
        markedRegion = markSlice(data);
        blVes(markedRegion) = min(blVes); % will show up in black
    end
        
    if bMarkVessels
        markedRegion = markVessels(data);
        blVes(markedRegion) = min(blVes); % will show up in black
    end
    
    figure; 
    mimg(blVes,100,100,'auto',0,' '); 
    h = gca;
    topLevelTitle(sprintf('%s - blood vessels', data.sessionKey));
    axes(h);
    impixelinfo;
end

function markedRegion = markVessels(data)
    % w = 2; p = 4; % J29
    % w = 2; p = 15; % M18
    % w = 1.7; p = 15; % M18-2
    blVes = mean(data.rawBlank(:,2:100),2);
    blVes = mfilt2(blVes,100,100,w,'hm');
    chamber = blVes(data.origMask);
    threshold = prctile(chamber,p);
    markedRegion = blVes < threshold | ~data.origMask;
end

function markedRegion = markSlice(data)
    data = findPeak(data);
    W = 3;
    markedRegion = zeros(1,10000);
    for vertical = 0:1
        sliceEq = sliceEqGroups([100,100], data.C, data.mask, W, vertical);
        markedRegion = markedRegion | (sliceEq == 0);
    end
end
