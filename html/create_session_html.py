# -*- coding: utf-8 -*-
"""
Created on Fri Feb 07 14:09:14 2014

@author: ronnie
"""

import sys
from os.path import join
from jinja2 import Template

def create_session_html(basedir, session):
    print 'Creating html for {}'.format(session)
    figures = [
        'peak-frame',
        'mimg',
        'spconds',
        'fits-at-peak',
        'parameter-time-courses',
        'speeds',
    ]
    
    html = Template("""
<html>
<head>
    <link rel="stylesheet" type="text/css" href="../figures.css">
</head>
<body>
<H1 align="center">{{session}}</H1>
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

<H1>PCs</H1>
<a href="PCs.png"><img src="PCs.png" width=45%></img></a>
<a href="PCs-with-grid.png"><img src="PCs-with-grid.png" width=45%></img></a>

<H1>Shaped PCs</H1>
<a href="shaped-PCs.png"><img src="shaped-PCs.png" width=45%></img></a>
<a href="shaped-PCs-with-grid.png"><img src="shaped-PCs-with-grid.png" width=45%></img></a>

<H1>PC weights</H1>
<a href="PC-weights-not-shaped.png"><img src="PC-weights-not-shaped.png" width=45%></img></a>
<a href="PC-weights-shaped.png"><img src="PC-weights-shaped.png" width=45%></img></a>

<H1>Blood Vessels</H1>
<a href="blves.png"><img src="blves.png" width=45%></img></a>
<a href="green.png"><img src="green.png" width=45%></img></a>

<H1>SNR in weight estimation region vs. "signal" region</H1>
<a href="SNR-of-regions.png"><img src="SNR-of-regions.png" width=45%></img></a>


<H1>Mimg with PC weight estimation region contour</H1>
<a href="mimg-with-shape-contour.png"><img src="mimg-with-shape-contour.png" width=100%></img></a>

</body>
</html>    
""").render(**locals())
    with open(join(basedir,session,'session_figures.html'), 'w') as f:
        f.write(html)

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print 'Usage: {} <basedir> <session>'.format(sys.argv[0])
        sys.exit()
    basedir = sys.argv[1]
    session = sys.argv[2]
    create_session_html(basedir,session)