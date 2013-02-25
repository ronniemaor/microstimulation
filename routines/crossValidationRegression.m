function [yFit,P,R2] = crossValidationRegression(h,x,Y,nBins)
% Input:
% x - 1xN row vector with X axis values of regression points
% Y - MxN matrix. M rows of N regression target values each. 
%     Each row represents a different sample.
% h - Regression class (e.g. GaussianFit), with methods:
%     P = h.fitParams(x,y)
%     y = h.FitValues(x,P)
% nBins - number of cross validation groups. Negative number means
%         nBins = M (leave one out). nBins=1 will use the whole group
%         for both training and testing (this effectively disabled CV)
% Output:
% P - fit parameters over average of all rows.
% R2 - average of R2 on test set per cross validation training set
    M = size(Y,1);
    if nargin < 4
        nBins = 5;
    end
    if nBins <= 0
        nBins = M; % "leave one out"
    end
    bins = divideToBins(1:M,nBins);
    binR2s = zeros(nBins,1);
    for iBin = 1:nBins
        if nBins > 1
            trainingCells = bins(1:nBins ~= iBin);
            trainingRows = [trainingCells{:}];
            yTrain = mean(Y(trainingRows,:),1);
        else
            yTrain = mean(Y(:,:),1);
        end
        P = h.fitParams(x,yTrain);
        
        testRows = bins{iBin};
        yTest = mean(Y(testRows,:),1);
        yFit = h.fitValues(x,P);
        binR2s(iBin) = calcR2(yTest,yFit);
    end
    R2 = mean(binR2s); % error estimate is average over results from bins
    
    % final fit with all the data
    yAll = mean(Y,1);
    P = h.fitParams(x,yAll);
    yFit = h.fitValues(x,P);
end
