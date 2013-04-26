function tmp()
    x = linspace(-1,1,100);
    y = -x + 0.3 * rand(1,100);
    z = x*0.2;

    figure
    subplot(2,1,1)
    plot(x,x);    
    hold on
    
    subplot(2,1,2)
    plot(x,x);
    hold on
    
    subplot(2,1,1)
    plot(x,y,'r');
    hold on
    
    subplot(2,1,2)
    plot(x,z,'r');
    hold on
end