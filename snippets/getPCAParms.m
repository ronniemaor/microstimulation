function parms = getPCAParms(bPCA,parms)
    if ~exist('parms', 'var')
        parms = make_parms();
    end

    if bPCA
        nPCs = take_from_struct(parms,'nPCs',2);
        parms = add_parms(parms, 'variationName', 'PCA', 'nPCs', nPCs, 'use_blood_vessel_mask',false, 'PCAmethod', 'frame blanks', 'active_cache', sprintf('PCA-%dPCs',nPCs));
    else
        parms = add_parms(parms, 'variationName', 'no-PCA', 'use_blood_vessel_mask',true, 'PCAmethod', 'NOP', 'active_cache', 'no-PCA');
    end    
end
