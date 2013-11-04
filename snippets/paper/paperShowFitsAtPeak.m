function paperShowFitsAtPeak(data)
    figure;
    for isVertical = 0:1
        subplot(1,2,isVertical+1);
        showSingleFrameFit(data,make_parms('newFigure',0,'isVertical',isVertical))
    end
end
