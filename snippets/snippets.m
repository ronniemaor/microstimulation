%%
setup
preprocessAndSave('J26c') % Only needed once for each new session.
data = loadData('J29c');

%% 
drawBloodVessels(data)
points = findBloodVessels(data); % try automatically
points = loadExclusionMask(data.sessionKey); % or load current mask
points = choose_points(points); % and do manual adjustments
points = keepOnlyV1(boundaryPoints); % extend mask upwards given manually marked boundary between V1 and V2
saveExclusionMask(data.sessionKey,points);

% matching points to green
showGreen(data.sessionKey);
points = choose_points(points,[dx dy]);

%%
showFrame(data)
showFrame(loadData('M18e'), 1e-3, 59, 1, 1)

%%
drawMimg(data, 1e-3, 20:50)
drawSpconds(data, 10, 10:80)
drawSignalOverSliceAndTime(data,0)

%%
modelComparisonAtPeak(data, {GaussianFit, ExponentialFit})
modelComparisonAllSessions({GaussianFit, ExponentialFit})
modelComparisonScatterPlot({GaussianFit, ExponentialFit})
presentationModelSelection % scatter plot

%% 
for isVertical = 0:1
    timeCourse(data, isVertical, 28:45, GaussianFit, 28:35)
end

res = cacheTimeCourseParams('M18d');
timeCourseSeveralSessions(make_parms('sessions', {'M18b', 'M18c', 'M18d', 'M18e'}))

%% Propagation speeds
speedsBySigma() % speedsBySigma(make_parms('sessions',{'M18b','J29c'}))
activationBoundaryRaw(data,25:50,0)
activationBoundaryFits(data.sessionKey,0)
speedsByJancke(make_parms('threshold',2.5E-4)) % more parms: sessions
sessionActivationsAndSpeeds(make_parms('sessions',{'M18b','M18c','M18d','M18e'}))

%% Anisotropy
sigmaRatiosOverTime()
JanckeRatiosOverTime(make_parms('threshold',2.5E-4))

%% 
spatialResponseOverTimeMovie(data, 0, 26:40)
