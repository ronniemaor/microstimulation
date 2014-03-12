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

function runHtmlScript(script,args)
    python_prog = 'C:\data\winpython\python-2.7.5.amd64\python.exe';
    if ~exist(python_prog,'file')
        python_prog = 'python';
    end

    snipptesDir = fileparts(mfilename('fullpath'));
    htmlCodeDir = fullfile(snipptesDir,'..', 'html');
    
    cmd = sprintf('%s %s/%s %s', python_prog, htmlCodeDir, script, args);
    status = system(cmd);
    assert(status == 0, 'failed to run python script')
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

    parms = getPCAParms(bPCA,parms);
    variationName = parms.variationName;
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
    
    runHtmlScript('create_summary_html.py', basedir);
end

function saveAllSessionFigures(basedir, sessionKey, parms, bPCA)
    dirname = sprintf('%s/%s',basedir, sessionKey);
    if ~exist(dirname,'dir')
        mkdir(dirname)
    end

    parms = getPCAParms(bPCA,parms);
    variationName = parms.variationName;
    
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
        drawMimg(V,make_parms('dynamicRange',5e-2,'frameRange',1:nPCs))
        saveas(gcf, sprintf('%s/PCs.png',dirname))
        drawMimg(V,make_parms('dynamicRange',5e-2,'frameRange',1:nPCs,'bShowGrid',1))
        saveas(gcf, sprintf('%s/PCs-with-grid.png',dirname))
        
        [proj,weights] = applyFirstPCs(data.allBlanks - 1, V);
        drawFirstPCsWeights(weights,10:80)
        saveas(gcf, sprintf('%s/PC-weights.png',dirname))
        
        drawMimg(proj, make_parms('dynamicRange',1e-3,'frameRange',10:80))
        saveas(gcf, sprintf('%s/mimg-blanks-PCs-proj.png',dirname))
        
        drawMimg(data.allBlanks-1, make_parms('dynamicRange',1e-3,'frameRange',10:80))
        saveas(gcf, sprintf('%s/mimg-blanks.png',dirname))
    end

    paperShowFitsAtPeak(data,parms);
    saveas(gcf, sprintf('%s/fits-at-peak-%s.png',dirname,variationName))
    
    paperCreateSampleSessionFigures(data,parms);
    saveas(gcf, sprintf('%s/parameter-time-courses-%s.png',dirname,variationName))
    
    paperSpeeds(data.sessionKey, parms);
    saveas(gcf, sprintf('%s/speeds-%s.png',dirname,variationName))
    
    close all
    runHtmlScript('create_session_html.py', sprintf('%s %s',basedir,sessionKey));
end