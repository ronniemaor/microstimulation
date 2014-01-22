function [w,frames_to_show] = firstPCWeightsOnBlanks(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    nPCs = take_from_struct(parms, 'nPCs', 2); % number of principal components to use

    frameRange = 20:50;
    nBlanks = size(data.allBlanks,3);
    mean_blank = mean(data.allBlanks,3);
    X = data.allBlanks(:,frameRange,:) ./ mean_blank(:,frameRange,ones(1,nBlanks));

    [s1,s2,s3] = size(X);
    X = reshape(X,s1,s2*s3);
    
    V = doPCA(X',nPCs);
    
    frames_to_show = 10:80;
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
