function shiftedPoints = shift_points(points,dx,dy,sz)
    if ~exist('sz','var')
        sz = [100 100];
    end    

    shiftedPoints = zeros(size(points));
    n = 0;
    for i=1:length(points)
        [x,y] = ind2sub(sz,points(i));
        x = x + dx;
        y = y + dy;
        if x > 0 && x <= sz(1) && y > 0 && y <= sz(2)
            n = n + 1;
            shiftedPoints(n) = sub2ind(sz,x,y);
        end            
    end
    shiftedPoints = shiftedPoints(1:n);
end
