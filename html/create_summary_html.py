# -*- coding: utf-8 -*-
"""
Created on Fri Feb 07 14:09:14 2014

@author: ronnie
"""

import sys
from os.path import join, isdir, exists
from os import makedirs, listdir
import shutil
import re
from jinja2 import Template
from this_dir import this_dir

def ensure_dir(d):
    if not exists(d):
        makedirs(d)

def find_sessions(basedir):
    subdirs = [x for x in listdir(basedir) if isdir(join(basedir,x))]
    session_subdirs = [x for x in subdirs if re.match('\w\d\d?\w$', x)]

    main_sessions = [x.strip() for x in file(join(basedir,'sessions.txt')).readlines()]
    other_sessions = list(set(session_subdirs) - set(main_sessions))
    
    return main_sessions, other_sessions

def create_summary_html(basedir):
    print 'Creating html files in {}'.format(basedir)
    ensure_dir(basedir)
    main_sessions, other_sessions = find_sessions(basedir)    
    shutil.copy(join(this_dir(),'figures.css'), basedir)
    
    figures = [
        'speeds',
        'time-courses',
        'sigma-ratios-over-time',
        'jancke-ratios-over-time',
    ]
    
    html = Template("""
<html>
<head>
    <link rel="stylesheet" type="text/css" href="figures.css">
</head>
<body>

<H1>Figures for each Session</H1>
{% for session in main_sessions %}
    <a href="{{session}}/session_figures.html">{{session}}</a> &nbsp &nbsp &nbsp &nbsp
{% endfor %}
</br>

</br>
{% if other_sessions %}
Additional Sessions (not used for summaries):</br>
{% endif %}
{% for session in other_sessions %}
    <a href="{{session}}/session_figures.html">{{session}}</a> &nbsp &nbsp &nbsp &nbsp
{% endfor %}
</br>

<H1>Summaries over all sessions</H1>
<a href="PCs-explained-variance-summary.png"><img src="PCs-explained-variance-summary.png" width=50%></img></a>
<P>
<table width=100%>
    <tr>
        <td class="tableHeading"><b>No PCA</b></td>
        <td class="tableHeading"><b>PCA</b></td>
    </tr>
{% for figure in figures %}    
    <tr>
        <td><a href="{{figure}}-no-PCA.png"><img src="{{figure}}-no-PCA.png" width=100%></img></a></td>
        <td><a href="{{figure}}-PCA.png"><img src="{{figure}}-PCA.png" width=100%></img></a></td>
    </tr>
{% endfor %}
</table>
</P>

</body>
</html>    
""").render(**locals())
    with open(join(basedir,'summary.html'), 'w') as f:
        f.write(html)
    
if __name__ == '__main__':
    if len(sys.argv) < 2:
        print 'Usage: {} <basedir>'.format(sys.argv[0])
        sys.exit()
    basedir = sys.argv[1]
    create_summary_html(basedir)