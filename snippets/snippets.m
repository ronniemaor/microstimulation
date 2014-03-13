%% before we start
setup

%% initial configuration and preprocessing of a new session (only needed once for each new session)
% 1) add entry in getAllSessionConfigs
% 2) preprocess:
preprocessAndSave('J26c')

%% loading the data
data = loadData('J29c');

%% blood vessels and masks

drawBloodVessels(data)
points = findBloodVessels(data); % try automatically
points = loadExclusionMask(data.sessionKey,'noise'); % or load current mask
points = choose_points(points); % and do manual adjustments
points = keepOnlyV1(boundaryPoints); % extend mask upwards given manually marked boundary between V1 and V2
saveExclusionMask(data.sessionKey,'noise',points);

% matching points to green
showGreen(data.sessionKey);
points = choose_points(points,[dx dy]);

%% show frame (peak frame by default)
showFrame(data)
showFrame(loadData('M18e'), 1e-3, 59, 1, 1)

%% Ways to get an impression of the data
drawMimg(data)
drawMimg(data.allBlanks - 1) % draw the blanks instead of the signal
drawSpconds(data, make_parms('frameRange',20:50))
drawSignalOverSliceAndTime(data,0)

%% model comparison (gaussian vs. exponential)
modelComparisonAtPeak(data, {GaussianFit, ExponentialFit})
modelComparisonAllSessions({GaussianFit, ExponentialFit}) % lots of bars
modelComparisonScatterPlot({GaussianFit, ExponentialFit})
presentationModelSelection % scatter plot

%% fits
showSingleFrameFit(data)
res = cacheTimeCourseParams('M18d'); % compute and cache fits (can do this once explicitly or let it be done implicitly)
computeFitsCache(parms,bForce); % compute cache for all sessions
timeCourse(data, isVertical, 28:45, GaussianFit, 28:35) % fits for a single sessions
timeCourseSeveralSessions(make_parms('sessions', {'M18b', 'M18c', 'M18d', 'M18e'})) % fits for several sessions

%% Propagation speeds
speedsBySigma() % speedsBySigma(make_parms('sessions',{'M18b','J29c'}))
activationBoundaryRaw(data,0)
activationBoundaryFits(data.sessionKey,0)
speedsByJancke(make_parms('threshold',2.5E-4)) % more parms: sessions
sessionActivationsAndSpeeds(make_parms('sessions',{'M18b','M18c','M18d','M18e'}))

%% Anisotropy
sigmaRatiosOverTime()
JanckeRatiosOverTime(make_parms('threshold',2.5E-4))

%% misc
spatialResponseOverTimeMovie(data, 0, 26:40)

%% figures for paper
% 1) Configure and preprocess the session (see above)
% 2) Find peak. Look at data and verify things make sense.
data = findPeak(loadData('J29c', make_parms('exclude_noisy_regions',false)))
data = findPeak(loadData('J26c'));
showFrame(data)
drawMimg(data, make_parms('dynamicRange',1e-3))
drawSpconds(data)
% 3) Show fits at peak frame
paperShowFitsAtPeak(data,parms);
% 4) Fit parameters over time
paperCreateSampleSessionFigures(data,parms);
% 5) Speed analysis
paperSpeeds(data.sessionKey, parms);

% summaries
paperSpeedSummary(parms);
paperFitsSummary(parms); 

% clean blood vessels using PCA
data = cleanBloodVesselsUsingPCA(data);
data = loadData('J29c') % default PCA cleaning
data = loadData('J29c', make_parms('method','NOP')) % no PCA cleaning

%% more PCA stuff
V = getFirstPCs(data, make_parms('nPCs', 2));
drawMimg(V,make_parms('dynamicRange',5e-2,'frameRange',1:2))
fractions = showFirstPCsVariance(data)
[proj,weights] = applyFirstPCs(data.allBlanks - 1, V);
drawFirstPCsWeights(data,V)
drawMimg(mean(proj, make_parms('dynamicRange',1e-3,'frameRange',10:80))
drawSpconds(data)

% visualizing weight shapes
[data,V,shapedV] = cleanBloodVesselsUsingPCA(data, make_parms('shape_method', 'hard', 'maxD', 35));
drawMimg(data)
drawSpconds(data)
drawMimg(shapedV,make_parms('dynamicRange',5e-2,'frameRange',1:2))
[nPixels,nFrames,nTrials] = size(data.signal);
shape = createPCAWeightingShape(data, make_parms('shape_method','hard', 'maxD', 35));
sig = data.orig_signal .* repmat(shape,[1,nFrames,nTrials]);
drawMimg(sig)

%% standard examination of a session (for evaluating PCA cleanup)
parms = make_parms('exclude_noisy_regions',false, 'PCAmethod', 'frame blanks', 'active_cache', 'PCA');
%parms = make_parms('exclude_noisy_regions',true, 'PCAmethod', 'NOP', 'active_cache', 'no-PCA');
data = findPeak(loadData(session_key, parms))
showFrame(data)
drawMimg(data)
drawSpconds(data)
paperShowFitsAtPeak(data,parms);
paperCreateSampleSessionFigures(data,parms);
paperSpeeds(data.sessionKey, parms);

createAllFiguresForPCAComparison('C:\temp\ms'); % parms: sessions
