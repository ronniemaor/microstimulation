function tmp()
    for nPCs = 1:4
        parms = getPCAParms(true,make_parms('nPCs',nPCs));
        parentdir = 'c:\temp\ms';
        variant = sprintf('%dPCs',nPCs);
        basedir = [parentdir, '\', variant];
        if ~exist(basedir,'dir')
            mkdir(parentdir, variant)
        end
        createAllFiguresForPCAComparison(basedir,parms);
        python_prog = 'C:\data\winpython\python-2.7.5.amd64\python.exe';
        script = 'C:\data\microstimulation\code\html\create_html.py';
        cmd = sprintf('%s %s %s', python_prog, script, basedir);
        system(cmd);
    end
end
