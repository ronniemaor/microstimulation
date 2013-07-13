function points = choose_points(points)
    if ~exist('points','var')
        points = [];
    end
    
    % get a new line object
    gca;
    hold on
    line = plot(1,1,'b.','linewidth',2);
    set(line,'xdata',[],'ydata',[]);
    
    sz = [100 100];

    while 1
        % draw the current set of points
        [X,Y] = ind2sub(sz,points);
        set(line,'xdata',X,'ydata',Y);

        % get a new point
        [x,y,button] = ginput(1);
        if button == 3 % exit on right click
            break
        end

        % toggle selection of the new point
        x = round(x);
        y = round(y);
        ind = sub2ind(sz,x,y);
        if find(points == ind, 1)
            points = points(points ~= ind); % 2nd click removes point
        else
            points = [points ind]; % otherwise it's new - add it
        end
    end
    
    % delete the lineseries to leave the figure like we found it
    delete(line);
end