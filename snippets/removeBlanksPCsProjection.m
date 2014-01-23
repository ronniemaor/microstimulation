function data = removeBlanksPCsProjection(data,parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    b_center_blanks = take_from_struct(parms,'center_blanks',true);
    
    V = getFirstPCs(data, parms);

    if b_center_blanks
        proj = applyFirstPCs(data.allBlanks - 1, V);
    else
        proj = applyFirstPCs(data.allBlanks, V);
    end
        
    nTrials = size(data.signal,3);
    data.signal = data.signal - repmat(proj,[1 1 nTrials]);
end