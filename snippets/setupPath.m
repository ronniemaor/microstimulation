function setupPath()
    snippetsDir = fileparts(mfilename('fullpath'));
    baseDir = fileparts(snippetsDir);
    path(path,[baseDir '/snippets']);
    path(path,[baseDir '/routines']);
    path(path,[baseDir '/3rd party']);

    hamutalCodeDir = 'C:/data/zuta/My_M_Files';
    if ~exist(hamutalCodeDir,'dir')
        error('Could not find path to hamutalCodeDir')
    end
    path(path,[hamutalCodeDir, '/Matlab4Hamutal'])
    path(path,[hamutalCodeDir, '/Matlab4Inbal'])
end