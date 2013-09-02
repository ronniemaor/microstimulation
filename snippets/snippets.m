%%
setup
data = loadData('J29c');

%% 
drawBloodVessels(data)
points = findBloodVessels(data); % try automatically
points = loadExclusionMask(data.sessionKey); % or load current mask
points = choose_points(points); % and do manual adjustments
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
speedsBySigma()
activationBoundaryRaw(data,25:50,0)
activationBoundaryFits(data,25:50,0)

%% Anisotropy
sigmaRatiosOverTime()

%% 
spatialResponseOverTimeMovie(data, 0, 26:40)
