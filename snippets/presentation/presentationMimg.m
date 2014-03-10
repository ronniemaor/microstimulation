function presentationMimg(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end

    data = loadData('M18c',parms);
    drawMimg(data, make_parms('frameRange',25:42))
end
