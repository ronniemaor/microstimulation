function shape = createPCAWeightingShape(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    method = take_from_struct(parms, 'shape_method', 'hard');

    if isequal(method, 'NOP')
        fprintf('NO PC shaping\n');
        shape = ones(10000,1);
        return;
    end
    
    [shape,foundShape] = applyConfiguredMasks(data.sessionKey, 'pcShape');
    if foundShape
        fprintf('Shaping PCs using session-specific mask\n');
        return;
    end

    fprintf('Shaping PCs using shape method = %s\n', method);
    if isequal(method, 'hard')        
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
    else
        assert(false, 'Unknown shape method: %s', method);
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