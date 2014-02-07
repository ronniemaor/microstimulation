function setupPath()
    path(pathdef)
    baseDir = fileparts(mfilename('fullpath'));
    path(path,[baseDir '/lab']);
    path(path,[baseDir '/snippets']);
    path(path,[baseDir '/snippets/presentation']);
    path(path,[baseDir '/snippets/paper']);
    path(path,[baseDir '/routines']);
    path(path,[baseDir '/3rd party']);
    path(path,[baseDir '/3rd party/export_fig']);

    hamutalCodeDir = 'C:/data/microstimulation/My_M_Files';
    if ~exist(hamutalCodeDir,'dir')
        error('Could not find path to hamutalCodeDir')
    end
    path(path,[hamutalCodeDir, '/Matlab4Hamutal'])
    path(path,[hamutalCodeDir, '/Matlab4Inbal'])
    path(path,[hamutalCodeDir, '/Elhanan-M-Files'])
end