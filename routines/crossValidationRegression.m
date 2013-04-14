function [yFit, P, err, errSem, overfitR2] = ...
         crossValidationRegression(h, x, Y, nBins, nBootstrap)
% Input:
% x - 1xN row vector with X axis values of regression points
% Y - MxN matrix. M rows of N regression target values each. 
%     Each row represents a different sample.
% h - Regression class (e.g. GaussianFit), implementing BaseFit
% nBins - number of cross validation groups. 
%         nBins <= 0 means nBins = M (AKA "leave one out"). 
%         nBins = 1 will use the whole group for both training 
%                   and testing (disables cross validation)
% Output:
% yFit - best fit trained on all data
% P - fit parameters over average of all rows.
% err - average of RMS errors on test set per cross validation training set
% errSem - standard error of mean for the RMS error
% overfitR2 - R2 computed between yFit (on all data) and the AVERAGE
%             of Y over all trials.
    M = size(Y,1);
    if nargin < 4
        nBins = 5;
    end
    if nBins <= 0
        nBins = M; % "leave one out"
    end
    if nargin < 5
        nBootstrap = ceil(30/nBins);
    end

    errSamples = zeros(nBootstrap,nBins);
    for iBootstrap = 1:nBootstrap       
        indexes = randperm(M);
        bins = divideToBins(indexes,nBins);
        for iBin = 1:nBins
            if nBins > 1
                trainingCells = bins(1:nBins ~= iBin);
                trainingRows = [trainingCells{:}];
                yTrain = mean(Y(trainingRows,:),1);
            else
                yTrain = mean(Y(:,:),1);
            end
            
            testRows = bins{iBin};
            yTest = Y(testRows,:);
            
            h.fitParamsHint(yTest); % allow cheating for testing purposes
            P = h.fitParams(x,yTrain);
            yFit = h.fitValues(x,P);
            errSamples(iBootstrap,iBin) = calcR2(yTest,yFit);
        end
    end
    err = mean(errSamples(:));
    errSem = std(errSamples(:)) / sqrt(nBins*nBootstrap);
    
    % final fit with all the data
    yAll = mean(Y,1);
    h.fitParamsHint(yAll);
    P = h.fitParams(x,yAll);
    yFit = h.fitValues(x,P);
    overfitR2 = calcR2(yAll,yFit);
end
