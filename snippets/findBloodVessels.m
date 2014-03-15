function points = findBloodVessels(data)
    points = findPoints(data);
    drawBloodVessels(data);
    points = choose_points(points);
end

function points = findPoints(data)
    if isequal(data.sessionKey(1:3),'J29')
        w = 2; p = 4;
    elseif isequal(data.sessionKey(1:3),'M18')
        w = 2; p = 15;
    else
        w = 2; p = 4;
    end
    blVes = mean(data.rawBlank(:,2:100),2);
    blVes = mfilt2(blVes,100,100,w,'hm');
    chamber = blVes(data.origMask);
    threshold = prctile(chamber,p);
    points = find(blVes < threshold & data.origMask)';
end
