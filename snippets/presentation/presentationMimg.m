function presentationMimg(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end

    data = loadData('M18c',parms);
    drawMimg(data, 2e-3, 25:42, 1)
end
