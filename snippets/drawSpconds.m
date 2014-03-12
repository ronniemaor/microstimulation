%% time course per region: stim vs. blank
function drawSpconds(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    nBins = take_from_struct(parms,'nBins',10);
    frameRange = take_from_struct(parms,'frameRange',10:80);
    showOrig = take_from_struct(parms,'showOrig',true);
    ttl = take_from_struct(parms,'ttl','');
    
    isFullData = isfield(data,'signal');
    if isFullData
        signal = data.signal;
    else
        signal = data; % we got a matrix already: pixels x frames [x trials]
    end
    signal = mean(signal,3); % average out trials if we have them

    otherSignal = [];
    if showOrig && isFullData
        otherSignal = data.orig_signal;
    end
    otherSignal = take_from_struct(parms,'otherSignal',otherSignal);
    
    plotdata = signal(:,frameRange);
    if ~isempty(otherSignal)
        plotdata(:,:,2) = mean(otherSignal(:,frameRange,:),3);
    end
    
    myfigure;
    plotspconds(plotdata,100,100,nBins);
    if ~isempty(ttl)
        title(ttl)
    end
end
