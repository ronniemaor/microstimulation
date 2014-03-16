function [Vrj,Wjs,PROJrs,ORIGrs,Srs] = examineShapeCorrections(data,parms)
    if ~exist('parms','var')
        parms = make_parms();
    end

    data = findPeak(data);
    
    nPCs = take_from_struct(parms,'nPCs',2);
    frame = take_from_struct(parms,'frame',data.peakFrame);
    
    R = zeros(1,2);
    R(1) = sub2ind([100 100],25,25);
    R(2) = sub2ind([100 100],75,35);
    V = getFirstPCs(data, parms);
    Vrj = getVrj(V,R,parms);

    shapeA = getShape(@(x,y) norm([x y] - data.C) > 35);
    shapeB = getShape(@(x,y) y>=50);
    shapes = [shapeA shapeB];
    nShapes = size(shapes,2);
    Wjs = zeros(nPCs,nShapes);
    signal = mean(data.orig_signal,3);
    for iShape = 1:nShapes
        shapedV = getShapedV(V, shapes(:,iShape));    
        [~,weights] = applyFirstPCs(signal, V, shapedV);
        Wjs(:,iShape) = weights(frame,:)';
    end
    
    PROJrs = Vrj*Wjs;
    s1 = getRegionMean(signal(:,frame),R(1),parms);
    s2 = getRegionMean(signal(:,frame),R(2),parms);
    ORIGrs = [s1 s1; s2 s2];
    Srs = ORIGrs - PROJrs;
end

function Vrj = getVrj(V,R,parms)
    nRegions = length(R);
    nPCs = size(V,2);
    Vrj = zeros(nRegions,nPCs);
    for r = 1:nRegions
        for j = 1:nPCs
            Vrj(r,j) = getRegionMean(V(:,j),R(r),parms);
        end
    end
end

function m = getRegionMean(s,indCenter,parms)
    [x,y] = ind2sub([100 100], indCenter);
    D = take_from_struct(parms,'D',4);
    m = 0;
    for dx = -D:D
        for dy = -D:D
            ind = sub2ind([100 100], x+dx, y+dy);
            m = m + s(ind);
        end
    end
    m = m / (2*D+1)^2;
end

function shape = getShape(f)
    shape = zeros(10000,1);
    for x = 1:100
        for y = 1:100
            ind = sub2ind([100 100],x,y);
            shape(ind) = f(x,y);
        end
    end
end
