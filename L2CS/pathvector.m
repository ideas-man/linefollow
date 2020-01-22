function [ pointsCoords ] = pathvector(sceneImage, numSer)
%PATHVECTOR Computes the movement  path defined by the black line.
%   PATHVECTOR(SCENEIMAGE, NUMSER) Computes POINTSCOORD array of X and Y
%   coordinates of key movement points on the black line. NUMSECT defines
%   the number of sectors image will be divided into. For every sector a
%   key point will be found.
%
% -------------------------------------------------------------------------
% |  INPUT PARAMETER  |         DESCRIPTION             |       TYPE      |
% -------------------------------------------------------------------------
% |     sceneImage    | Input image of the track.       |  binary image   |
% -------------------------------------------------------------------------
% |      numSer       | Number of series  image will be |     numeric     |
% |                   | divided to.                     |                 |
%--------------------------------------------------------------------------

% Preallocate memory:
pointsCoords = zeros(0, 2);
inputdim1 = size(sceneImage,1);
% Step that will define the series 'height':
step = inputdim1/numSer;
% Compute the start and the end row of the current series:
yPrev = round(inputdim1:-step:1);
yCurr = round(inputdim1-step+1:-step:1);
for i=1:numSer
    % Compute the sum value of each series colunm:
    sum1 = sum(sceneImage(yCurr(i):yPrev(i),:), 1);
    % Check if theres black line in the first place:
    if max(sum1) ~= 0
        % Find all indexes of the maximum sum1 values:
        idx = find(sum1 == max(sum1));
        % Compute coordinates of the key point:
        x_dotsCoord = floor(median(idx));
        y_dotsCoord = floor((yPrev(i)-yCurr(i))/2) + yCurr(i);
        pointsCoords(size(pointsCoords, 1) + 1, :) = [x_dotsCoord, y_dotsCoord];
    end
end
end