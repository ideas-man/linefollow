function [ ] = dlog( logData, connData, MEData )
%DLOG creates a log file.
%   DLOG(LOGDATA, CONNDATA, MEDATA) opens or creates a new log file LOG.TXT. 
%   It starts with a header containing data about connection to target
%   RasPi and I2C interface connection. Then the LOGDATA table follows, it 
%   contains info about time, average turn angle, median X coordinate, 
%   right and left motors DC, and low-level control system response values.
%   It closes file with MExeption class identifier field. All timestamps
%   are provided at INPUT_VAR(X,2) in CONNDATA and MEDATA inputs.
%
%   logData: Array that contains the date and time of iteration time of 
%            iteration (see DATETIME for more info), average turn angle
%            and median X coordinate (see TURNANGLE.M for more info),
%            right and left motors dutyCycle see (DUTYCYCLE.M for more info),
%            and IP adress of target RasPi board. Type: (N, 6) string.
%
%   connData: IP-adress of the target RasPi board. I2C bus ID and device
%             address, and I2CPING.M output code (See I2CPING.M for more 
%             info with corresponding timestamps. Type: (2, 4) string.
%
%   MEData: MExeption class error identifier with timestamp. 
%           Type: (2, 1) string.

fileID = fopen('log.txt','a+');
fprintf(fileID,'%20s : Connection established succsessfully with %18s\r\n',...
    connData(2,1), connData(1,1));
fprintf(fileID,'%20s : Pinging %5s, address %5s... Output code: %2s\r\n',...
    connData(2,2), connData(1,2), connData(1,3), connData(1,4));
fprintf(fileID,'                                DATA TABLE\r\n');
fprintf(fileID,'|                 time |  angle |  coordinate |   rDC |   lDC | response |\r\n');
for i=1:size(logData,1)
 fprintf(fileID,'| %20s | %6s |      %6s | %6s | %6s |   %6s | \r\n',...
     logData(i,:));   
end
fprintf(fileID,'%20s :  %18s\r\n',MEData(1,1), MEData(1,2));
fclose('all');
end