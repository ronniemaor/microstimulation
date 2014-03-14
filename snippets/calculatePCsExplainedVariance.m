function calculatePCsExplainedVariance(parms)
    if ~exist('parms', 'var')
        parms = make_parms();
    end
    maxPCs = take_from_struct(parms,'maxPCs',4);

    parms = add_parms(getPCAParms(true,parms), 'nPCs', maxPCs);

    allSessions = getSessionsFromParms(parms);
    nSessions = length(allSessions);
    ev = zeros(nSessions,maxPCs);
    iSession = 0;
    for cSession = allSessions
        iSession = iSession + 1;
        sessionKey = cSession{1};
        data = loadData(sessionKey, getPCAParms(false)); % load data without doing PCA to save time since we're doing it again afterwards anyway
        [~,d,C] = getFirstPCs(data, parms);
        ev(iSession,:) = 100 * d / trace(C);
    end
    
    myfigure(parms)
    barwitherr(std(ev,0,1),mean(ev,1), 'b','LineWidth',2);
    ylim([0 100])
    title('Variance explained by first PCs')
    ylabel('Percent of total variance \pm std')
    str_xlabels = cell(1,maxPCs);
    for i=1:maxPCs
        str_xlabels{i} = sprintf('PC%d',i);
    end
    set(gca,'XTickLabel',str_xlabels)
    hold on
    
    cs = cumsum(ev,2);
    errorbar(mean(cs,1),std(cs,0,1), 'Color', 'g', 'LineWidth', 2)
end
