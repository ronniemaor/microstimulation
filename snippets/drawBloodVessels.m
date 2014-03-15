function drawBloodVessels(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    bShowCenter= take_from_struct(parms, 'bCenter', 1);
    showMask = take_from_struct(parms, 'showMask', 0);
    extraMask = take_from_struct(parms,'extraMask',[]);

    blVes = mean(data.rawBlank(:,2:100),2);
    blVes = mfilt2(blVes,100,100,2,'hm');
    
    if bShowCenter
        markedRegion = markCenter(data);
        blVes(markedRegion) = min(blVes); % will show up in black
    end
        
    if showMask
        markedRegion = ~data.mask;
        blVes(markedRegion) = min(blVes); % will show up in black
    end
    
    blVes(extraMask) = min(blVes); % will show up in black
    
    myfigure; 
    mimg(blVes,100,100,'auto',0,' '); 
    h = gca;
    topLevelTitle(sprintf('%s - blood vessels', data.sessionKey));
    axes(h);
    impixelinfo;
end

function markedRegion = markCenter(data)
    data = findPeak(data);
    W = 3;
    markedRegion = zeros(1,10000);
    for vertical = 0:1
        sliceEq = sliceEqGroups([100,100], data.C, data.mask, W, vertical);
        markedRegion = markedRegion | (sliceEq == 0);
    end
end
