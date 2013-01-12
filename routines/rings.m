function R = rings(N,C,mask,W)
% Find positions of rings that are equidistant from a center
%
% Usage:
%   R = rings(N,C,mask,W)
%
% Input:
%   N = [nX, nY]: dimensions of the image
%   C = [centerX, centerY]: position of the center of the rings
%   mask: one dimensional nX*nY logical array indicating positions 
%         that should be considered. Others will be set to NaN in R.
%   W: width of each ring in pixels (default=1)
%
% Output:
%   R: nX*nY matrix of ring number per pixel.
%   NOTE: R is one dimensional. X is the "inner loop" index.

if nargin < 4
    W=1; 
end

nX = N(1);
nY = N(2);

R = NaN*zeros(1,nX*nY);
for iY = 1:nY
    for iX = 1:nX
        P = [iX iY];
        i = 100*(iY-1) + iX;
        if mask(i)
            R(i) = floor( norm(P-C) / W );
        end
    end
end
