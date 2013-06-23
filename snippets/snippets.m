%%
setup
data = loadData('J29c');

%% 
drawBloodVessels(data)
showFrame(data)
showFrame(loadData('M18e'), 1e-3, 59, 1, 1)

%%
drawMimg(data, 1e-3, 20:50)
drawSpconds(data, 10, 10:80)
drawSignalOverSliceAndTime(data,0)

%%
modelComparisonAtPeak(data, {GaussianFit, ExponentialFit})
modelComparisonAllSessions({GaussianFit, ExponentialFit})

%% 
for isVertical = 0:1
    timeCourse(data, isVertical, 28:45, GaussianFit, 28:35)
end

timeCourseSeveralSessions(GaussianFit, 28:45, {'M18b', 'M18c', 'M18d', 'M18e'})

%% 
spatialResponseOverTimeMovie(data, 0, 26:40)
