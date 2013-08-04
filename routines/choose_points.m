function points = choose_points(points, dXY, sz)
% Mark a set of points manually on a image. Returns the marked points.
% 
% Marking is done with the left mouse button. Clicking on a point that's 
% already marked unmarks it.
% To exit, click the right mouse button.
%
% Input:
%   points - A set of marked points to start with. Defaults to empty set.
%   dXY - pair [dx dy] of how much to shift points by when placing on
%         image. Defaults to [0 0].
%   sz - size of image. Defaults to [100 100]
% Output:
%   points - A vector of pixel indices that were chosen. 
%            Indices are flat, i.e. one dimensional (1 .. prod(sz))
    if ~exist('points','var')
        points = [];
    end
    
    if ~exist('dXY','var')
        dXY = [0 0];
    end
    
    if ~exist('sz','var')
        sz = [100 100];
    end
    
    points = shift_points(points,dXY(1),dXY(2),sz);
    
    % get a new line object
    gca;
    hold on
    line = plot(1,1,'b.','linewidth',2);
    set(line,'xdata',[],'ydata',[]);
    
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

    % unshift the points before returning them
    points = shift_points(points,-dXY(1),-dXY(2),sz);    
end