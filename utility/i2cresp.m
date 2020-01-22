function [ statuscode ] = i2cresp( i2cConn )
%I2CRESP compares response message with '5-by-5' message.
%   I2CRESP(I2CCONN) reads data from existing I2CCONN connection and checks
%   if it is a low-tier control system's 'loud and clear' response message 
%   that follows after incoming message from high-tier control system.
%
% -------------------------------------------------------------------------
% | INPUT PARAMETER  |          DESCRIPTION             |       TYPE      |
% -------------------------------------------------------------------------
% |     i2cConn      | Connection to I2C device.        |  i2cdev object  |
% -------------------------------------------------------------------------
%
% -------------------------------------------------------------------------
% | OUTPUT PARAMETER |     VALUE      |             MEANING               |
% -------------------------------------------------------------------------
% |    statuscode    |       0        | Confirmation message was not      |
% |                  |                | recieved or it was not containing |
% |                  |                | required data.                    |
% |                  ------------------------------------------------------
% |                  |       1        | Confirmation message was recieved.|
% -------------------------------------------------------------------------

msg = read (i2cConn,1);
if msg == 55
    statuscode = 1;
    return
else
    statuscode = 0;
    return
end
end