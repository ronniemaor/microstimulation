function paperShowFitsAtPeak(data,parms)
    if ~exist('parms','var')
        parms = make_parms();
    end

    myfigure(parms);
    for isVertical = 0:1
        subplot(1,2,isVertical+1);
        showSingleFrameFit(data,add_parms(parms, 'newFigure',0,'isVertical',isVertical))
    end
end
