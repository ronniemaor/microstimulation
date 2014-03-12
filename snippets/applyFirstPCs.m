function [proj,weights] = applyFirstPCs(signal, V, shapedV)
    if ~exist('shapedV','var')
        shapedV = V;
    end
    
    [nPixels,nFrames,nTrials] = size(signal);
    nPCs = size(V,2);

    weights = zeros(nFrames,nPCs,nTrials);
    proj = zeros(nPixels,nFrames,nTrials);
    for frame = 1:nFrames
        for iTrial = 1:nTrials
            orig_signal = signal(:,frame,iTrial);
            w = shapedV' * orig_signal; % get the weights from the shaped PC
            weights(frame,:,iTrial) = w;
            proj(:,frame,iTrial) = V * w; % apply the original PC with the "shaped weights"
        end
    end
end

