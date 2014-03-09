function drawFirstPCsWeights(weights, frameRange)
    nPCs = size(weights,2);
    
    myfigure;
    set(gca,'FontSize',16);
    legend_txt = cell(1,nPCs);
    for i=1:nPCs
        y = weights(frameRange,i);
%         if max(y) < -min(y)
%             y = -y; % sign is arbitrary, so make the peak positive
%         end
        plot(frameRange, y, 'LineWidth', 2);
        legend_txt{i} = sprintf('PC %d', i);
        hold all
    end
    title('Weight of first PCs in mean blank frames')
    xlabel('frame number')
    ylabel('PC weight')
    legend(legend_txt, 'Location', 'NorthWest');
end
