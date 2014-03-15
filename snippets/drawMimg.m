%% time series of stim/blank for whole chamber 
function drawMimg(data, parms)
    if ~exist('parms', 'var')
        parms = make_parms();
    end

    dynamicRange = take_from_struct(parms,'dynamicRange',2e-3);
    frameRange = take_from_struct(parms,'frameRange',20:50);
    bNormalizeTime = take_from_struct(parms,'bNormalizeTime',0);
    bShowGrid = take_from_struct(parms,'bShowGrid',0);
    extraMask = take_from_struct(parms,'extraMask',[]);
    
    if isfield(data,'signal')
        signal = data.signal;
    else
        signal = data; % we got a matrix already: pixels x frames x trials
    end
    signal = signal(:,frameRange,:);
    meanSignal = mean(signal,3);
    if bNormalizeTime
        startFrame = 25;
        msecPerFrame = 10;
        times = msecPerFrame * (frameRange - startFrame);
    else
        times = frameRange;
    end
    
    meanSignal(extraMask,:) = -dynamicRange;
    
    if bShowGrid
        for i = 10:10:90
            for j = 1:100
                ind1 = sub2ind([100,100],i,j);
                ind2 = sub2ind([100,100],j,i);
                meanSignal([ind1 ind2],:) = -dynamicRange;
            end
        end
    end
    
    myfigure;
    mimg(meanSignal,100,100,-dynamicRange,dynamicRange,times,0,16); 
    colormap(mapgeog);
end