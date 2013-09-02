function myfigure(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    if take_from_struct(parms,'newFigure',1)
        figure;
    end
    set(gca,'FontSize', take_from_struct(parms,'FontSize', 16));
end