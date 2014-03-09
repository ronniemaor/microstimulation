function createAllFiguresForPCAComparison(basedir, parms)
    if ~exist('parms', 'var')
        parms = make_parms();
    end
    parms.nPCs = take_from_struct(parms,'nPCs',2);
    bDoSummary = take_from_struct(parms,'summary',true);
    
    allSessions = getSessionsFromParms(parms);
    for cSession = allSessions
        sessionKey = cSession{1};
        for bPCA = 0:1
            saveAllSessionFigures(basedir, sessionKey, parms, bPCA);
        end
    end
    
    if bDoSummary
        for bPCA = 0:1
            saveAllSummaryFigures(basedir, parms, bPCA);        
        end
    end

    f = fopen(sprintf('%s/sessions.txt',basedir),'w');    
    for cSession = allSessions
        sessionKey = cSession{1};
        fprintf(f,'%s\n',sessionKey);
    end
    fclose(f);
end

function [parms, variationName] = getParmsAndVariationName(parms, bPCA)
    if bPCA
        parms = add_parms(parms, 'use_blood_vessel_mask',false, 'PCAmethod', 'frame blanks', 'active_cache', 'PCA');
        variationName = 'PCA';
    else
        parms = add_parms(parms, 'use_blood_vessel_mask',true, 'PCAmethod', 'NOP', 'active_cache', 'no-PCA');
        variationName = 'no-PCA';
    end    
end

function saveAndCloseFig(fig,name)
    set(fig,'Color','w')
    export_fig(fig,name)
    close(fig)
end

function saveAllSummaryFigures(basedir, parms, bPCA)
    if ~exist(basedir,'dir')
        mkdir(basedir)
    end

    [parms, variationName] = getParmsAndVariationName(parms, bPCA);
    nSessions = length(getSessionsFromParms(parms));
    
    timeCourseSeveralSessions(add_parms(parms, 'summary', 'mean'));
    saveAndCloseFig(gcf, sprintf('%s/time-courses-%s.png',basedir,variationName))
    
    if nSessions > 3
        timeCourseSeveralSessions(add_parms(parms, 'summary', 'median', 'medianErrWidth', 15));
        set(gcf,'Color','w')
        saveAndCloseFig(gcf, sprintf('%s/time-courses-median-%s.png',basedir,variationName))
    end
    
    speedsByJancke(parms);
    saveAndCloseFig(gcf, sprintf('%s/speeds-%s.png',basedir,variationName))

    sigmaRatiosOverTime(parms);
    saveAndCloseFig(gcf, sprintf('%s/sigma-ratios-over-time-%s.png',basedir,variationName))
    
    JanckeRatiosOverTime(parms);
    saveAndCloseFig(gcf, sprintf('%s/jancke-ratios-over-time-%s.png',basedir,variationName))
    
    close all
end

function saveAllSessionFigures(basedir, sessionKey, parms, bPCA)
    dirname = sprintf('%s/%s',basedir, sessionKey);
    if ~exist(dirname,'dir')
        mkdir(dirname)
    end

    [parms, variationName] = getParmsAndVariationName(parms, bPCA);
    
    data = findPeak(loadData(sessionKey, parms));

    showFrame(data)
    saveas(gcf, sprintf('%s/peak-frame-%s.png',dirname,variationName))
            
    drawMimg(data)
    saveas(gcf, sprintf('%s/mimg-%s.png',dirname,variationName))
    
    if bPCA
        drawSpconds(data)
        saveas(gcf, sprintf('%s/spconds-%s.png',dirname,variationName))

        nPCs = take_from_struct(parms,'nPCs');
        [V,d,C] = getFirstPCs(data, parms);
        drawMimg(V,5e-2,1:nPCs)
        saveas(gcf, sprintf('%s/PCs.png',dirname))
        
        [proj,weights] = applyFirstPCs(data.allBlanks - 1, V);
        drawFirstPCsWeights(weights,10:80)
        saveas(gcf, sprintf('%s/PC-weights.png',dirname))
        
        drawMimg(proj, 1e-3, 10:80)
        saveas(gcf, sprintf('%s/mimg-blanks-PCs-proj.png',dirname))
        
        drawMimg(data.allBlanks-1, 1e-3, 10:80)
        saveas(gcf, sprintf('%s/mimg-blanks.png',dirname))
    end

    paperShowFitsAtPeak(data,parms);
    saveas(gcf, sprintf('%s/fits-at-peak-%s.png',dirname,variationName))
    
    paperCreateSampleSessionFigures(data,parms);
    saveas(gcf, sprintf('%s/parameter-time-courses-%s.png',dirname,variationName))
    
    paperSpeeds(data.sessionKey, parms);
    saveas(gcf, sprintf('%s/speeds-%s.png',dirname,variationName))
    
    close all
end