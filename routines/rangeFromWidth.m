function r = rangeFromWidth(center,width)
delta = floor((width-1)/2);
r = (center-delta):(center+delta);