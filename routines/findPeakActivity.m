function [iX,iY,iFrame] = findPeakActivity(signal)
    nFrames = size(signal,2);    

    kSmooth = [5 5 5];
    nBorder = 10;
    
    signal = mean(signal,3);
    signal = reshape(signal,100,100,nFrames);
    smoothed = convn(signal, ones(kSmooth), 'same');
    
    % ignore border (spatial + temporal)
    minValue = min(smoothed(:));
    smoothed(1:nBorder,:,:) = minValue;
    smoothed((end-nBorder+1):end,:,:) = minValue;
    smoothed(:,1:nBorder,:) = minValue;
    smoothed(:,(end-nBorder+1):end,:) = minValue;
    smoothed(:,:,1:10) = minValue;
    smoothed(:,:,60:end) = minValue;
    
    [~,ind] = max(smoothed(:));
    [iX,iY, iFrame] = ind2sub(size(smoothed),ind);
end