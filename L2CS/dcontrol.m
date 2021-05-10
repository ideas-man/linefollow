init;
% Create connection to RasPi and camera board
mypi = raspi(rasPiIP,'pi','raspberry');
mycamera = cameraboard(mypi, 'Resolution', camRes, 'VerticalFlip', 1, 'ROI', ROI);
% Establish connection to PC104
enableI2C(mypi, I2CSpeed);
i2cPC104 = i2cdev(mypi, bus, adr);
% Form connection data package for logger
% connData = string({rasPiIP, bus, adr, pingres; pitime, pingtime, pingtime, pingtime});

idx = 1;
% First frame
sceneImage = snapshot(mycamera);
sceneImage = imcomplement(imbinarize(rgb2gray(sceneImage)));
img = imshow(sceneImage);
hold on
% Init trace, median markers and angle pointer
tMarker = plot(-100, -100, 'r*', 'MarkerSize',10);
mMarker = plot(100, 100, 'b*', 'MarkerSize',16);
aLine = line([len, len+len*sind(45)],[imgDim(1), imgDim(1)-len*cosd(45)],  'Color', 'r', 'LineWidth', 2);

while idx==1
    sceneImage = snapshot(mycamera);
    % Camera's magical settings require image to be mirroed vertically
    sceneImage = imcomplement(imbinarize(rgb2gray(sceneImage)));
    %sceneImage = sceneImage(:, end:-1:1);
    set(img, 'CData', sceneImage);
    % Start processing input image
    pointsCoords = pathvector(sceneImage, numSect);
    avgTurnAng = turnangle(pointsCoords, safeZoneWidth, imgDim);
    DC = dutycycle(avgTurnAng, pointsCoords, minDC, imgDim, safeZoneWidth);
    % Write data to L1 control system
    DC(DC<0) = 256 - DC(DC<0);
    write(i2cPC104, [uint8(DC(1)) uint8(DC(2))]);
    % Plot angle pointer
    set(aLine, 'XData', [len, len+len*sind(avgTurnAng)], 'YData', [imgDim(1), imgDim(1)-len*cosd(avgTurnAng)]);
    % Plot trace marker
    set(tMarker, 'XData', pointsCoords(:,1), 'YData', pointsCoords(:,2));
    % Plot median marker
    set(mMarker, 'XData', median(pointsCoords(:,1), 1), 'YData', median(pointsCoords(:,2), 1));
end