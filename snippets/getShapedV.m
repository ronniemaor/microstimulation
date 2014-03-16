function shapedV = getShapedV(V, shape)
    shapedV = zeros(size(V));
    for i=1:size(V,2)
        v = V(:,i) .* shape;
        v = v/norm(v); % renormalize PC
        shapedV(:,i) = v;
    end
end
