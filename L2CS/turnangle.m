function [ avgTurnAng ] = turnangle( pointsCoords, safeZoneWidth, imgDim )
%TURNANGLE Computes an average turn angle in degrees.
%   TURNANGLE(POINTSCOORDS, SAFEZONEWIDTH, IMGDIM) Computes an average
%   turn angle for robotic platform. For every key movement point
%   in POINTSCOORDS a turn angle is computed. If the first key point lies
%   withing the forward movement path defined by SAFEZONEWIDTH value than
%   every turn boundaries of the angle will be computed for forward
%   movement vector that lies through first POINTSCOORDS point, not
%   [640 720] - [640 0] vector. Every turn angle is multiplied by a
%   significance coefficient. It's value starts from 1 for the first key
%   point and then it decreases linearly. Then the average turn angle
%   is computed.
%
% -------------------------------------------------------------------------
% | INPUT PARAMETER  |          DESCRIPTION             |       TYPE      |
% -------------------------------------------------------------------------
% |   pointsCoords   | Array of X and Y (row and column)|  N-by-2 numeric |
% |                  | coordinates of key  movement     |       array     |
% |                  | points defined by the black line |                 |
% |                  | visible in ROI. See PATHVECTOR.M |                 |
% |                  | for more info.                   |                 |
% -------------------------------------------------------------------------
% |   safeZoneWidth  | Width of the path zone in the    |     numeric     |
% |                  | centre of the image (dim(1) +-   |                 |
% |                  | safeZoneWidth/2) where every     |                 |
% |                  | key point is considered to be on |                 |
% |                  | exact movement vector.           |                 |
% -------------------------------------------------------------------------
% |      imgDim      | Input image's dimensions.        |     1-by-2      |
% |                  | [rows, columns]                  |  numeric array  |
% -------------------------------------------------------------------------

N = length(pointsCoords);
% Preallocate memory:
ang = zeros(1, N);
c = zeros(1, N);
% Boundaries of move-forward zone:
safeZone = [floor(imgDim(2)/2 - safeZoneWidth/2), floor(imgDim(2)/2 + safeZoneWidth/2)];
% Define movement vector:
if pointsCoords(1,1) > safeZone(1) && pointsCoords(1,1) < safeZone(2)
    v1 = [pointsCoords(1,1) imgDim(1)] - [pointsCoords(1,1) 0];
    v2p1 = pointsCoords(1,1);
    v2p2 = imgDim(1);
else
    v1 = [imgDim(2)/2 imgDim(1)] - [imgDim(2)/2 0];
    v2p1 = imgDim(2)/2;
    v2p2 = imgDim(1);
end

% For every key point in POINTSCOORDS compute a turn angle and a
% corrsponding significance coefficient. "ATAN2D gives the angle in degrees
% between the vectors as measured in a counterclockwise direction from v1
% to v2. If that angle would exceed 180 degrees, then the angle is measured
% in the clockwise direction but given a negative value. In other words,
% the output of 'atan2d' always ranges from -180 to +180 degrees."
% ROGER STAFFORD, MATLABCENTRAL FORUM,
% "www.mathworks.com/matlabcentral/answers/180131-how-can-i-
% find-the-angle-between-two-vectors-including-directional-information"

for i=1:N
    v2 = [v2p1 v2p2] - [pointsCoords(i, 1) pointsCoords(i, 2)];
    ang(i) = atan2d(v1(1)*v2(2)-v1(2)*v2(1), v1(1)*v2(1)+v1(2)*v2(2));
    c(i) = (N-i)/(N-1);
end
% Compute the normalized average turn angle.
avgTurnAng = (ang*c')/sum(c);
end