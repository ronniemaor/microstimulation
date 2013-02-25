function Eq = sliceEqGroups(N,C,mask,W,vertical)
% Equivalent positions are a fixed displacement (with sign) from the center
% along a horizontal or vertical direction. We average over W pixels
% along the perpendicular axis to the one we're varying along.
%
% Usage:
%   Eq = sliceEqGroups(N,C,mask,W,vertical)
%
% Input:
%   N = [nX, nY]: dimensions of the image
%   C = [centerX, centerY]: position of the center of the slice
%   mask: one dimensional nX*nY logical array indicating positions 
%         that should be considered. Others will be set to NaN in Eq.
%   W: width of the band in pixels (default=1)
%   vertical: make the band vertical instead of horizontal (default=0)
%
% Output:
%   Eq: nX*nY row vector of group number (position along slice) per pixel.
%       Pixels that fall outside the band or the mask will get NaN.
%   NOTE: Eq is one dimensional. X is the "inner loop" index.

if nargin < 4
    W = 1; 
end
if nargin < 5
    vertical = 0;
end    

nX = N(1);
nY = N(2);

if vertical
    lengthAxis = 2; % Y axis is "length"
    widthAxis = 1; % X axis is "width"
else
    lengthAxis = 1;  % X axis is "length"
    widthAxis = 2; % Y axis is "width"
end

Eq = NaN*zeros(1,nX*nY);
for iY = 1:nY
    for iX = 1:nX
        P = [iX iY];
        i = 100*(iY-1) + iX;
        if ~mask(i)
            continue
        end
        d = P-C;
        if round(d(widthAxis)/W) ~= 0
            continue
        end
        Eq(i) = floor(d(lengthAxis));
    end
end
