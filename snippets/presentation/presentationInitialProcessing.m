function presentationInitialProcessing(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end

    data = loadData('J29c',parms);
    data = findPeak(data);
    parms = add_parms(parms, ...
        'dynamicRange', 1e-3, ...
        'frame', data.peakFrame, ...
        'showCenter', 0, ...
        'showManualMask', 0 ...
    );
    showFrame(data,parms);
    showFrame(data,add_parms(parms, 'extraMask', markPeak(data)));    
    showFrame(data,add_parms(parms, 'extraMask', markSlices(data)));    
end

function region = markSlices(data)
    W = 9;
    vertical = 0;
    sliceEq = sliceEqGroups([100,100], data.C, data.mask, W, vertical);
    region = (sliceEq >= 0) & (sliceEq <= 60);
end    

function region = markPeak(data)
    data = findPeak(data);
    size = 4;
    cX = data.C(1);
    cY = data.C(2);
    f = @(x,y) sub2ind([100 100],x,y);
    region = f(cX,cY);
    for i = 1:size
        region = [region f(cX,cY+i) f(cX,cY-i) f(cX+i,cY) f(cX-i,cY)];
    end    
end