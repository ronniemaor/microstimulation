function [w,frames_to_show] = firstPCWeightsOnBlanks(data, V, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    nPCs = size(V,2);
    frames_to_show = take_from_struct(parms, 'frames_to_show', 10:80);

    blanks = data.allBlanks(:,frames_to_show,:);
    mean_blank = mean(blanks,3);
    nFrames = length(frames_to_show);
    w = zeros(nFrames, nPCs);
    for frame = 1:nFrames
        x = mean_blank(:,frame) - 1;
        w(frame,:) = V' * x;
    end
    
    figure;
    set(gca,'FontSize',16);
    legend_txt = cell(1,nPCs);
    for i=1:nPCs
        y = w(:,i);
        if max(y) < -min(y)
            y = -y; % sign is arbitrary, so make the peak positive
        end
        plot(frames_to_show, y, 'LineWidth', 2);
        legend_txt{i} = sprintf('PC %d', i);
        hold all
    end
    title('Weight of first PCs in mean blank frames')
    xlabel('frame number')
    ylabel('PC weight')
    legend(legend_txt, 'Location', 'NorthWest');
end
