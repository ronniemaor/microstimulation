function drawBloodVessels(data, bShowSlices)
    if nargin < 2
        bShowSlices = 1;
    end
    
    blVes = mean(data.rawBlank(:,2:100),2);
    blVes = mfilt2(blVes,100,100,2,'hm');
    
    if bShowSlices
        markedRegion = markSlice(data);
        blVes(markedRegion) = min(blVes); % will show up in black
    end
    
    figure; 
    mimg(blVes,100,100); 
    impixelinfo;
end

function markedRegion = markSlice(data)
    data = findPeak(data);
    W = 9;
    markedRegion = zeros(1,10000);
    for vertical = 0:1
        sliceEq = sliceEqGroups([100,100], data.C, data.mask, W, vertical);
        markedRegion = markedRegion | (sliceEq == 0);
    end
end
