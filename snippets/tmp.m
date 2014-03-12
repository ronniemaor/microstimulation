function tmp()
    create_PCs_only()
end

function create_PCs_only()
    for nPCs = [4 3 2 1]
        parms = getPCAParms(true,make_parms('nPCs',nPCs));
        parentdir = 'c:\temp\ms';
        variant = sprintf('%dPCs',nPCs);
        basedir = [parentdir, '\', variant];        
        
        allSessions = getSessionsFromParms(parms);
        for cSession = allSessions
            sessionKey = cSession{1};
            dirname = sprintf('%s/%s',basedir, sessionKey);
            
            data = findPeak(loadData(sessionKey, add_parms(parms,'PCAmethod','NOP')));
            
            [V,d,C] = getFirstPCs(data, parms);
            drawMimg(V,make_parms('dynamicRange',5e-2,'frameRange',1:nPCs))
            saveas(gcf, sprintf('%s/PCs.png',dirname))
            drawMimg(V,make_parms('dynamicRange',5e-2,'frameRange',1:nPCs,'bShowGrid',1))
            saveas(gcf, sprintf('%s/PCs-with-grid.png',dirname))

            drawFirstPCsWeights(data,V)
            saveas(gcf, sprintf('%s/PC-weights.png',dirname))
            
            close all
        end
        
    end
end

function create_several_nPCs_variants()
    for nPCs = 1:4
        parms = getPCAParms(true,make_parms('nPCs',nPCs));
        parentdir = 'c:\temp\ms';
        variant = sprintf('%dPCs',nPCs);
        basedir = [parentdir, '\', variant];
        if ~exist(basedir,'dir')
            mkdir(parentdir, variant)
        end
        createAllFiguresForPCAComparison(basedir,parms);
    end
end