function contour = findContour(mask)
    toRemove = zeros(10000,1);
    nToRemove = 0;
    
    inds = find(mask == 1);
    for i=1:length(inds)
        ind = inds(i);
        if shouldRemove(mask,ind)
            nToRemove = nToRemove + 1;
            toRemove(nToRemove) = ind;
        end
    end
    toRemove = toRemove(1:nToRemove);
    
    contour = mask;
    contour(toRemove) = 0;
end

function b = shouldRemove(mask,ind)
    [x,y] = ind2sub([100 100],ind);
    c = countPixel(mask,x-1,y) + countPixel(mask,x+1,y) + countPixel(mask,x,y-1) + countPixel(mask,x,y+1);
    b = (c == 4);
end

function c = countPixel(mask,x,y)
    if (x<1) || (x>100)
        c = 1;
        return
    end
    if (y<1) || (y>100)
        c = 1;
        return
    end
    ind = sub2ind([100 100],x,y);
    c = mask(ind);
end