function [ ] = dlog( logData, connData, MEData )
%DLOG creates log file containing all necessary info for debug.
%   DLOG(LOGDATA, CONNDATA, MEDATA) opens or creates new log file LOG.TXT. 
%   It starts with a header containing data about connection to target
%   RasPi and I2C interface connection. Then LOGDATA table follows, It 
%   contains info about time, average turn angle, median X coordinate, 
%   right and left motors DC, and low-level control system response values.
%   It closes file with MExeption class identifier field. All timestamps
%   are provided at INPUT_VAR(X,2) in CONNDATA and MEDATA inputs.
%
% -------------------------------------------------------------------------
% | INPUT PARAMETER  |          DESCRIPTION             |       TYPE      |
% -------------------------------------------------------------------------
% |     logData      | Array that contains date and     |  n-by-6 string  |
% |                  | time of iteration (see DATETIME  |                 |
% |                  | for more info, average turn      |                 |
% |                  | angle and median X coordinate    |                 |
% |                  | (see TURNANGLE.M for more info), |                 |
% |                  | right and left motors dutyCycle  |                 |
% |                  | see (DUTYCYCLE.M for more info), |                 |
% |                  | and IP adress of target RasPi    |                 |
% |                  | board.                           |                 |
% -------------------------------------------------------------------------
% |     connData     | IP-adress of the target RasPi    |  2-by-4 string  |
% |                  | board. I2C bus ID and device     |                 |
% |                  | address, and i2cping.m output    |                 |
% |                  | code (See I2CPING.M for more info|                 |
% |                  | with corresponding timestamps.   |                 |
% -------------------------------------------------------------------------
% |      MEData      | MExeption class error identifier |  2-by-1 string  |
% |                  | with timestamp                   |                 |
%--------------------------------------------------------------------------

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