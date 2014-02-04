function [V,d,C] = getFirstPCs(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    method = take_from_struct(parms, 'PCAmethod', 'frame blanks');    
    nPCs = take_from_struct(parms, 'nPCs', 2); % number of principal components to use

    fprintf('Computing blood vessel contribution using PCA. method=%s\n', method);
    if isequal(method, 'blanks')        
        X = data.allBlanks(:,3:30,:);
    elseif isequal(method, 'frame blanks')
        frameRange = 20:50;
        nBlanks = size(data.allBlanks,3);
        mean_blank = mean(data.allBlanks,3);
        X = data.allBlanks(:,frameRange,:) ./ mean_blank(:,frameRange,ones(1,nBlanks));
    elseif isequal(method, 'frame stims')
        frameRange = 3:24;
        nStims = size(data.stims,3);
        mean_blank = mean(data.allBlanks,3);
        X = data.stims(:,frameRange,:) ./ mean_blank(:,frameRange,ones(1,nStims));
    else
        assert(false, 'unknown method: %s', method);
    end
    [s1,s2,s3] = size(X);
    X = reshape(X,s1,s2*s3);
    
    [V,d,C] = doPCA(X',nPCs);
end
