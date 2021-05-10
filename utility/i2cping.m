function [ statuscode ] = i2cping( mypi, bus, adr )
%I2CPING performs ping of the defined address via I2C interface.
%   I2CPING(MYPI, BUS, ADR) pings I2C device with ADR address of the BUS
%   bus of the MYPI connection with the targeted RaspberryPi board.
%
%   mypi: RasPi connection object. Type: raspi object.
%
%   bus: The I2C bus ID. Type: char.
%
%   adr: I2C device address. Type: char.
%   
%   statuscode: Status code. 0 - Required bus address not found.
%                            1 - Lost packages/response does not match 
%                                ping package.
%                            2 - Connection is stable.
%               Type: numeric.

count = 0;
enableI2C(mypi);
if find(strcmp(adr, scanI2CBus(mypi, bus))) == 1
    i2cConn = i2cdev(mypi, bus, adr);
    for i=1:5
        write(i2cConn, uint8(128));
        % wait...
        resp = read(i2cConn,1);
        if resp == uint8(55)
            count = +1;
        end
    end
    if count == 5
        statuscode = 2;
        return
    else
        statuscode = 1;
        return
    end
else
    statuscode = 0;
    return
end
end