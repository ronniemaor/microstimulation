%% surface plot after radius transform
means = ringTransform(signal,mask,3);
means = means(1:18,:);
figure; surf(means); colorbar;
xlabel('Frame'); ylabel('Radius'); zlabel('Signal'); 

%% signal vs. radius for several time points
means = ringTransform(signal,mask,3);
%frames = 32:2:50; 
frames = 24:2:32;
means = means(1:18,frames);
figure; plot(means); 
xlabel('Radius'); ylabel('Signal');
legend(arraySprintf('Frame %d',frames))

%% signal vs. time for several radiuses
means = ringTransform(signal,mask,3);
radiuses = [0, 5, 10]; 
%radiuses = 0:2:10;
means = means(radiuses+1,:);
figure; plot(means'); 
xlabel('Frame'); ylabel('Signal');
legend(arraySprintf('Radius %d',radiuses));
