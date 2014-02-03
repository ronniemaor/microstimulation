function myfigure(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    if take_from_struct(parms,'newFigure',1)
        figure;
    end
    set(gca,'FontSize', take_from_struct(parms,'FontSize', 16));
    if take_from_struct(parms, 'maxfigure',1)
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
    end
end
