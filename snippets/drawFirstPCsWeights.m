function [ymin,ymax] = drawFirstPCsWeights(data, V, parms)

    ttl = take_from_struct(parms,'ttl', 'PC weights over time');
    frameRange = take_from_struct(parms,'frameRange', 10:80);
    bJustMinMax = take_from_struct(parms, 'justMinMax', false);
    
    nPCs = size(V,2);    
    
    [~,wBlank] = applyFirstPCs(data.allBlanks - 1, V);
    wBlank = mean(wBlank,3);
    [~,wSignal] = applyFirstPCs(data.orig_signal, V);
    wSignal = mean(wSignal,3);
    
    ymin = min(min(wBlank(:)),min(wSignal(:)));
    ymax = max(max(wBlank(:)),max(wSignal(:)));
    
    % override ymin/ymax from parms
    ymin = take_from_struct(parms,'ymin',ymin);
    ymax = take_from_struct(parms,'ymax',ymax);
    
    if bJustMinMax
        return
    end
    
    colorOrder = [ ...
            0         0    1.0000; ...
             0    0.5000         0; ...
        1.0000         0         0; ...
             0    0.7500    0.7500; ...
        0.7500         0    0.7500; ...
        0.7500    0.7500         0; ...
        0.2500    0.2500    0.2500; ...
    ];

    myfigure;
    legend_txt = cell(1,2*nPCs);
    for i=1:nPCs  
        plot(frameRange, wSignal(frameRange,i), 'LineWidth', 2, 'LineStyle', '-', 'Color', colorOrder(i,:));
        hold all
        legend_txt{2*i-1} = sprintf('PC%d - signal', i);
        plot(frameRange, wBlank(frameRange,i), 'LineWidth', 2, 'LineStyle', '--', 'Color', colorOrder(i,:));
        legend_txt{2*i} = sprintf('PC%d - blank', i);
    end
    ymargin = 0.05*(ymax-ymin);
    ylim([ymin-ymargin, ymax+ymargin])
    title(ttl)
    xlabel('frame number')
    ylabel('PC weight')
    legend(legend_txt, 'Location', 'NorthWest');
end

