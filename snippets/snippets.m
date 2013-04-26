%%
setup
data = loadData('J29c');

%% 
drawBloodVessels(data)

%%
showFrame(data)

%%
drawMimg(data, 1e-3, 20:50)

%%
drawSpconds(data, 10, 10:80)

%%
drawSignalOverSliceAndTime(data,0)

%%
modelComparisonAtPeak(data, {GaussianFit, ExponentialFit})

%% 
for isVertical = 0:1
    timeCourse(data, isVertical, 28:45, GaussianFit, 28:35)
end

%% 
spatialResponseOverTimeMovie(data, 0, 26:40)
