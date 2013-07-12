function points = choose_points()
    gca;
    hold on
    
    % get a new line object
    line = plot(1,1,'b.','linewidth',2);
    set(line,'xdata',[],'ydata',[]);
    
    sz = [100 100];

    points = [];
    while 1
        [x,y,button] = ginput(1);
        if button == 3 % exit on right click
            break
        end

        x = round(x);
        y = round(y);
        ind = sub2ind(sz,x,y);
        if find(points == ind, 1)
            points = points(points ~= ind); % 2nd click removes point
        else
            points = [points ind]; % otherwise it's new - add it
        end
       
        % draw the new set of points
        [X,Y] = ind2sub(sz,points);
        set(line,'xdata',X,'ydata',Y);
    end
end