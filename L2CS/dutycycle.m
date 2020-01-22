function [ DC ] = dutycycle( avgTurnAng, pointsCoords, minDC, imgDim, safeZoneWidth )
%DUTYCYCLE computes the duty cycle for motors in per cent.
%   DUTYCYCLE(AVGTURNANG, POINTSCOORDS, MINDC, IMGDIM, SAFEZONEWIDTH) at
%   first computes the minimum duty cycle for each motor present on
%   two-wheeled robotic platform. Duty cycle linearly rises as average turn
%   angle AVGTURNANG decreases. This minimum value is the same for both
%   motors. Then it computes difference between duty cycle values defined
%   by POITSCOORDS in order to let the platform turn. Then DC array is
%   computed and set in [-100; 100] borders.
%
% -------------------------------------------------------------------------
% | INPUT PARAMETER  |          DESCRIPTION             |      TYPE       |
% -------------------------------------------------------------------------
% |    avgTurnAng    | Angle between current movement   |     numeric     |
% |                  | vector and required movement     |                 |
% |                  | vector. Lies within [-90; +90]   |                 |
% |                  | degrees. See TURNANGLE.M for more|                 |
% |                  | info.                            |                 |
% -------------------------------------------------------------------------
% |   pointsCoords   | Array of X and Y (row and column)|  N-by-2 numeric |
% |                  | coordinates of key  movement     |       array     |
% |                  | points defined by the black line |                 |
% |                  | visible in ROI. see PATHVECTOR.M |                 |
% |                  | for more info.                   |                 |
% -------------------------------------------------------------------------
% |       minDC      | PWM's minimum duty cycle that    |     numeric     |
% |                  | will set motors in motion.       |                 |
% -------------------------------------------------------------------------
% |      imgDim      | Input image's dimensions.        |     1-by-2      |
% |                  | [rows, columns]                  |  numeric array  |
% -------------------------------------------------------------------------
% |   safeZoneWidth  | Width of the path zone in the    |     numeric     |
% |                  | centre of the image (640 +-      |                 |
% |                  | safeZoneWidth/2) where every     |                 |
% |                  | key point is considered to be on |                 |
% |                  | exact movement vector.           |                 |
% -------------------------------------------------------------------------

% Boundaries of move-forward zone:
safeZone = [floor(imgDim(2)/2 - safeZoneWidth/2), floor(imgDim(2)/2 + safeZoneWidth/2)];
% Median values of X-coordinate:
avgX = median(pointsCoords(:,1), 1);
% Small check - might be useful during debug:
msg = [' Angle: ', num2str(avgTurnAng),' Coordinate: ', num2str(avgX)];
disp(msg);
% Minimum duty cycle for both motors:
baseDC = 100 - (abs(avgTurnAng)*(100-minDC))/90;
% Difference between duty cycles:
diffDC = (imgDim(2)/2-avgX)/(imgDim(2)/2) * 100;
if avgX > safeZone(1) && avgX < safeZone(2)
    LDC = baseDC;
    RDC = baseDC;
else
    LDC = floor(baseDC - diffDC);
    RDC = floor(baseDC + diffDC);
end
DC = [LDC, RDC];
% Message for debugging:
msg = [' DiffDC: ', num2str(diffDC), ' BaseDC: ', num2str(baseDC), ' L: ', num2str(DC(1)),' R: ', num2str(DC(2)) ];
disp(msg);
% Apply reverse, full stop and push values into [-100, 100].
DC(DC>100) = 100;
DC(DC<-100) = -100;
end