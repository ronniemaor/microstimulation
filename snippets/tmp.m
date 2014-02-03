function tmp()
    myfigure;
    plot(1:10)
    showSliceDirection(1)
end

function showSliceDirection(isVertical)
    t = sliceName(isVertical);
    axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1], ...
         'Box','off', 'Visible','off', ...
         'Units','normalized', 'clipping' , 'off');
    text(0.05,0.7,['\bf ' t],'HorizontalAlignment', ...
         'center', 'VerticalAlignment', 'top', 'Rotation', 90)
end
