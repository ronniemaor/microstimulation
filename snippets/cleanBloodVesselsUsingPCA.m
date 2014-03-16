function [data,V,shapedV,weights] = cleanBloodVesselsUsingPCA(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    method = take_from_struct(parms, 'PCAmethod', 'sheker');    
    if isequal(method, 'NOP')
        data.signal = data.orig_signal;
        V = nan;
        shapedV = nan;
        return;
    end  

    V = getFirstPCs(data, parms);   
    shape = createPCAWeightingShape(data, parms);
    shapedV = getShapedV(V, shape);
    [proj,weights] = applyFirstPCs(data.orig_signal, V, shapedV);
    data.signal = data.orig_signal - proj;
end
