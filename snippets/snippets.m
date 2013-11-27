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
points = loadExclusionMask(data.sessionKey); % or load current mask
points = choose_points(points); % and do manual adjustments
points = keepOnlyV1(boundaryPoints); % extend mask upwards given manually marked boundary between V1 and V2
saveExclusionMask(data.sessionKey,points);

% matching points to green
showGreen(data.sessionKey);
points = choose_points(points,[dx dy]);

%% show frame (peak frame by default)
showFrame(data)
showFrame(loadData('M18e'), 1e-3, 59, 1, 1)

%% Ways to get an impression of the data
drawMimg(data, 1e-3, 20:50)
drawSpconds(data, 10, 10:80)
drawSignalOverSliceAndTime(data,0)

%% model comparison (gaussian vs. exponential)
modelComparisonAtPeak(data, {GaussianFit, ExponentialFit})
modelComparisonAllSessions({GaussianFit, ExponentialFit}) % lots of bars
modelComparisonScatterPlot({GaussianFit, ExponentialFit})
presentationModelSelection % scatter plot

%% fits
showSingleFrameFit(data)
res = cacheTimeCourseParams('M18d'); % compute and cache fits (can do this once explicitly or let it be done implicitly)
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
data = findPeak(loadData('J26c'));
showFrame(data)
drawMimg(data, 1e-3, 20:50)
% 3) Show fits at peak frame
paperShowFitsAtPeak(data);
% 4) Fit parameters over time
paperCreateSampleSessionFigures(data);
% 5) Speed analysis
paperSpeeds(data.sessionKey);

% summaries
paperSpeedSummary();
paperFitSummary(); 