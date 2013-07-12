function points = choose_points()
    gca;
    hold on
    line = plot(1,1,'b.','linewidth',2);
    set(line,'xdata',[],'ydata',[]);
    
    sz = [100 100];

    points = [];
    while 1
        [x,y,button] = ginput(1);
        if button == 3
            break
        end

        x = round(x);
        y = round(y);
        ind = sub2ind(sz,x,y);
        if find(points == ind, 1)
            points = points(points ~= ind);
        else
            points = [points ind];
        end
       
        [X,Y] = ind2sub(sz,points);
        set(line,'xdata',X,'ydata',Y);
    end
end