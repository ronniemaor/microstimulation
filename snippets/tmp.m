function tmp()
%     ax1 = subplot(2,2,1);
%     plot(rand(30,2))
%     subplot(2,2,3);
%     plot(rand(30,2))
%     p1 = get(ax1,'Position');
%     legend({'foo', 'bar'}, 'Position', [p1(1)+1.25*p1(3), p1(2), 0.5*p1(2), 0.5*p1(4)])
    ax1 = subplot(3,1,1);
    plot(rand(30,2))
    ax2 = subplot(3,1,2);
    plot(rand(30,2))
    xl = legend({'first','second'},'Location','EastOutside');
    ax3 = subplot(3,1,3);
    plot(rand(30,2))
    p1 = get(ax1,'Position');
    p2 = get(ax2,'Position');
    p3 = get(ax3,'Position');
    %set(ax1,'Position',[p2(1) p1(2) p2(3) p1(4)])
    %set(ax3,'Position',[p2(1) p3(2) p2(3) p3(4)])
    set(xl, 'Position', [0 0 0.2 0.2])
end