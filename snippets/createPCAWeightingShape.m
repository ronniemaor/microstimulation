function shape = createPCAWeightingShape(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    config = getSessionConfig(data.sessionKey);
    
    method = take_from_struct(parms, 'shape_method', 'hard');

    fprintf('Shaping PCs using shape method = %s\n', method);
    if isequal(method, 'NOP')
        shape = ones(10000,1);
        return;
    elseif isequal(method, 'hard')        
        shape = zeros(10000,1);
        data = findPeak(data);
        if config.hasV2
            defaultMaxD = 20;
        else
            defaultMaxD = 35;
        end
        maxD = take_from_struct(parms,'maxD',defaultMaxD);
        C = data.C;
        for x = 1:100
            for y = 1:100
                ind = sub2ind([100 100],x,y);
                shape(ind) = pixel_value(x,y, C, maxD);
            end
        end
    else
        assert(false, 'unknown shape method: %s', method);
    end
end

function v = pixel_value(x,y,C,maxD)
    d = norm([x y] - C);
    if d > maxD;
        v = 1;
    else
        v = 0;
    end
end