function [pc_angles,subspace_angles] = checkStabilityOfPCs(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    nPCs = take_from_struct(parms, 'nPCs', 4);
    nIterations = take_from_struct(parms, 'iterations', 50);
    
    frameRange = 20:50;
    blanks = data.allBlanks(:,frameRange,:);
    
    nBlanks = size(blanks,3);
    idxMid = floor(nBlanks/2);
    pc_angles = zeros(nIterations,nPCs);
    subspace_angles = zeros(nIterations,nPCs);
    for iIter = 1:nIterations
        fprintf('Iteration %d/%d\n', iIter,nIterations)
        perm = randperm(nBlanks);
        V1 = getPCs(blanks(:,:,perm(1:idxMid)),nPCs);
        V2 = getPCs(blanks(:,:,perm(idxMid+1:end)),nPCs);
        for iPC = 1:nPCs
            v1 = V1(:,iPC);
            v2 = V2(:,iPC);
            pc_angles(iIter,iPC) = abs(v1'*v2);
            sub1 = V1(:,1:iPC);
            sub2 = V2(:,1:iPC);
            subspace_angles(iIter,iPC) = cos(subspace(sub1,sub2));
        end
        fprintf('\tPC angles:')
        fprintf('%g ',pc_angles(iIter,:))
        fprintf('\n')
        fprintf('\tSubspace angles:')
        fprintf('%g ',subspace_angles(iIter,:))
        fprintf('\n')
    end
    
    % draw PC angles
    myfigure(parms)
    mu = mean(pc_angles);
    sem = std(pc_angles)/sqrt(nIterations);
    barwitherr(sem,mu);
    ylim([0 1])
    title(sprintf('Agreement between PCs estimated on separate trials - %s',data.sessionKey))
    ylabel('cos(angle) \pm std')
    str_xlabels = cell(1,nPCs);
    for i=1:nPCs
        str_xlabels{i} = sprintf('PC%d',i);
    end
    set(gca,'XTickLabel',str_xlabels)

    % draw subspace angles
    myfigure(parms)
    mu = mean(subspace_angles);
    sem = std(subspace_angles);
    barwitherr(sem,mu);
    ylim([0 1])
    title(sprintf('Agreement between PC subspaces estimated on separate trials - %s',data.sessionKey))
    ylabel('cos(angle) \pm std')
    str_xlabels = cell(1,nPCs);
    str_xlabels{1} = 'PC1';
    for i=2:nPCs
        str_xlabels{i} = sprintf('PCs1:%d',i);
    end
    set(gca,'XTickLabel',str_xlabels)
end

function [V,d,C] = getPCs(blanks, nPCs)
    nBlanks = size(blanks,3);
    mean_blank = mean(blanks,3);
    X = blanks(:,:,:) ./ mean_blank(:,:,ones(1,nBlanks));
    [s1,s2,s3] = size(X);
    X = reshape(X,s1,s2*s3);    
    [V,d,C] = doPCA(X',nPCs);
end
