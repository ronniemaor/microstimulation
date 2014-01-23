function fractions = showFirstPCsVariance(data)
    nPCs = 10;
    [~,d,C] = getFirstPCs(data, make_parms('nPCs', nPCs));
    
    sum_of_all = trace(C);
    fractions = d / sum_of_all;
end