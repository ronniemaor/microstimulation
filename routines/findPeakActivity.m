function [iX,iY,iFrame] = findPeakActivity(signal,mask)
    if nargin < 2
        mask = [];
    end
    nFrames = size(signal,2);

    kSmooth = [5 5 5];
    
    signal = mean(signal,3);
    signal = reshape(signal,100,100,nFrames);
    smoothed = convn(signal, ones(kSmooth), 'same');
    
    % ignore times outside 11:39 and pixels outside mask
    minValue = min(smoothed(:));
    smoothed(:,:,1:10) = minValue;
    smoothed(:,:,40:end) = minValue;
    toRemove = find(~mask);
    [x,y] = ind2sub([100,100],toRemove);
    for i=1:length(toRemove)
        smoothed(x(i),y(i),:) = minValue;
    end
    
    [~,ind] = max(smoothed(:));
    [iX,iY, iFrame] = ind2sub(size(smoothed),ind);
end