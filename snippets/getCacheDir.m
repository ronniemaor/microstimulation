function cacheDir = getCacheDir(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end

    active_cache = take_from_struct(parms, 'active_cache','PCA');
    cacheDir = [getBaseDataDir(), '/cache/', active_cache];
end