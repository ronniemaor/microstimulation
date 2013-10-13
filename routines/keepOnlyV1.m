function maskPoints = keepOnlyV1(v1_v2_boundary_points)
% Return a mask which extends v1_v2_boundary_points to exclude any points above that line
    [X,Y] = ind2sub([100 100],v1_v2_boundary_points);
    findBoundary = @(x) min(Y(X == x));
    mask = ones(100,100);
    for x = 1:100
        yBoundary = findBoundary(x);
        if ~isempty(yBoundary)
            mask(x,1:yBoundary) = 0;
            %ind = sub2ind([100 100],x,y);
        end
    end
    maskPoints = find(mask(:) == 0);
end