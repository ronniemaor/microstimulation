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
        maxD = take_from_struct(parms,'maxD',35);
        C = data.C;
        for x = 1:100
            for y = 1:100
                ind = sub2ind([100 100],x,y);
                shape(ind) = pixel_value(x,y, C, maxD);
            end
        end
    elseif isequal(method, 'bottomhalf')
        shape = zeros(10000,1);
        for x = 1:100
            for y = 1:100
                ind = sub2ind([100 100],x,y);
                shape(ind) = (y>50);
            end
        end
    elseif isequal(method, 'tophalf')
        shape = zeros(10000,1);
        for x = 1:100
            for y = 1:100
                ind = sub2ind([100 100],x,y);
                shape(ind) = (y<=50);
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