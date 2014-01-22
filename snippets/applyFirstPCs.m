function [w,frameRange] = applyFirstPCs(signal, V, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    nPCs = size(V,2);
    frameRange = take_from_struct(parms, 'frameRange', 10:80);

    mean_signal = mean(signal(:,frameRange,:),3);
    nFrames = length(frameRange);
    w = zeros(nFrames, nPCs);
    for frame = 1:nFrames
        x = mean_signal(:,frame);
        w(frame,:) = V' * x;
    end
    
    bDraw = take_from_struct(parms, 'bDraw', true);
    if ~bDraw
        return
    end
    
    figure;
    set(gca,'FontSize',16);
    legend_txt = cell(1,nPCs);
    for i=1:nPCs
        y = w(:,i);
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
