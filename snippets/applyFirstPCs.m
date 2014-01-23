function [proj,weights] = applyFirstPCs(signal, V)
    [nPixels,nPCs] = size(V);

    mean_signal = mean(signal,3);
    nFrames = size(mean_signal,2);
    weights = zeros(nFrames, nPCs);
    proj = zeros(nPixels,nFrames);
    for frame = 1:nFrames
        x = mean_signal(:,frame);
        w = V' * x;
        weights(frame,:) = w;
        proj(:,frame) = V * w;
    end
end

