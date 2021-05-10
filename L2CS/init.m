% Raspberry Pi settings
rasPiIP = '192.168.1.246';
% Camera Board settings
camRes = '1280x720';
ROI = [0, 0, 1, 1];
% I2C interface settings
% Note that PC104 board has '0x03' default I2C adress.
bus = 'i2c-1';
adr = '0x03';
I2CSpeed = 115200;
% Image processing settings
imgDim = [str2double(camRes(strfind(camRes,'x')+1:end)) ,str2double(camRes(1:strfind(camRes,'x')-1))];
numSect = 10;
safeZoneWidth = 400;
% Visualisation settings
len = str2double(camRes(1:strfind(camRes,'x')-1))/2;
% Allocate space for log data if needed
% connData = string(zeros(2, 4));
% logData = string(zeros(1, 6));
% MEData = string(zeros(2, 1));
% Minimum duty cycle
minDC = 25;