function [ DC ] = dutycycle( avgTurnAng, pointsCoords, minDC, imgDim, safeZoneWidth )
%DUTYCYCLE computes the duty cycle for motors in per cent.
%   DUTYCYCLE(AVGTURNANG, POINTSCOORDS, MINDC, IMGDIM, SAFEZONEWIDTH) at
%   first computes the minimum duty cycle for each motor present on
%   two-wheeled robotic platform. Duty cycle linearly rises as average turn
%   angle AVGTURNANG decreases. This minimum value is the same for both
%   motors. Then it computes difference between the duty cycle values 
%   defined by POINTSCOORDS in order to let the platform turn. Then DC array
%   is computed and set in [-100; 100] range.
%   
%   avgTurnAng: Angle between the current movement vector and the required 
%               movement vector. Lies within the [-90; +90] range in degrees.
%               See TURNANGLE.M for more info. Type: numeric.
%
%   pointsCoords: Array of X and Y (row and column) coordinates of key movement
%                 points defined by the black line visible in ROI. See
%                 PATHVECTOR.M for more info. Type: (N, 2) numeric array.
%
%   minDC: PWM minimum duty cycle value (clip value) that will set motors 
%          in motion. Type: numeric.
%
%   imgDim: Input image dimensions. Type: (1, 2) numeric array.
%
%   safeZoneWidth: Width of the path zone in the centre of the image 
%                  (640 +- safeZoneWidth/2) where every key point is 
%                  considered to be lying on the movement vector.
%                  Type: numeric

% Boundaries of the move-forward zone
safeZone = [floor(imgDim(2)/2 - safeZoneWidth/2), floor(imgDim(2)/2 + safeZoneWidth/2)];
% Median values of the X-coordinate
avgX = median(pointsCoords(:,1), 1);
% debug message
msg = [' Angle: ', num2str(avgTurnAng),' Coordinate: ', num2str(avgX)];
disp(msg);
% Minimum duty cycle for both motors
baseDC = 100 - (abs(avgTurnAng)*(100-minDC))/90;
% Difference between the duty cycles
diffDC = (imgDim(2)/2-avgX)/(imgDim(2)/2) * 100;
if avgX > safeZone(1) && avgX < safeZone(2)
    LDC = baseDC;
    RDC = baseDC;
else
    LDC = floor(baseDC - diffDC);
    RDC = floor(baseDC + diffDC);
end
DC = [LDC, RDC];
% Message for debugging
msg = [' DiffDC: ', num2str(diffDC), ' BaseDC: ', num2str(baseDC), ' L: ', num2str(DC(1)),' R: ', num2str(DC(2)) ];
disp(msg);
% Sqeeze reverse, full stop and push values into [-100, 100]
DC(DC>100) = 100;
DC(DC<-100) = -100;
end