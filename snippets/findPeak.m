function data = findPeak(data)
    mask = getMask(data);
    [cX cY peakFrame] = findPeakActivity(data.signal,mask);
    C = [cX cY];
    data.C = C;
    data.peakFrame = peakFrame;
end

function mask = getMask(data)
    config = getSessionConfig(data.sessionKey);
    if isempty(config.manualPeakPosition)
        mask = data.mask;
    else
        [cX, cY] = unpack(config.manualPeakPosition);
        ind = sub2ind([100 100],cX,cY);
        mask = zeros(100,100);
        mask(ind) = 1;
    end    
    
% code for constraining the peak further by defining some other region. 
% using manualPeakPosition instead so this is not needed
%     f = @(x,y) x>36 && y>13; % this would come from session config
%     for x=1:100
%         for y=1:100
%             if ~f(x,y)
%                 ind = sub2ind([100 100],x,y);
%                 mask(ind) = 0;
%             end
%         end
%     end
end
