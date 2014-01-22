function [proj,weights] = applyFirstPCs(signal, V, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
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
    
    bDraw = take_from_struct(parms, 'bDraw', true);
    if ~bDraw
        return
    end   
    
    frameRange = take_from_struct(parms, 'frames_to_draw', 10:80);    
    figure;
    set(gca,'FontSize',16);
    legend_txt = cell(1,nPCs);
    for i=1:nPCs
        y = weights(frameRange,i);
        if max(y) < -min(y)
            y = -y; % sign is arbitrary, so make the peak positive
        end
        plot(frameRange, y, 'LineWidth', 2);
        legend_txt{i} = sprintf('PC %d', i);
        hold all
    end
    title('Weight of first PCs in mean blank frames')
    xlabel('frame number')
    ylabel('PC weight')
    legend(legend_txt, 'Location', 'NorthWest');
end

