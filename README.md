# LineFollowing


## Summary
Somewhat overcomplicated way to make a line following robot which uses on-board camera for navigation.

## Getting Started
Feel free to test some ideas present here. You'll need:

### Step 1: Hardware
**1.** *Mobile robot* - We are using **RoboCake Professional by Robotics.by**.

|        RoboCake Professional   |                       |
|:---:|:---:|
|High-tier control system (L2CS) | Raspberry Pi 2 Model B|
|Low-tier control system (L1CS)  | PC104 by Robotics.by   |
|Sensor system                   | Raspberry Pi Camera Board V2|
|Motor system                    | Two 3W DC motors without encoders, L298N motor driver|

For additional info contact: *_contacts@robotics.by_*.

### Step 2: Software
**1.** *MathWorks MATLAB environment* - You can get your license (at least ver2016a) [here](http://www.mathworks.com/).

**2.** *MATLAB Support Package for Raspberry Pi Hardware* - Get your copy [here](https://www.mathworks.com/matlabcentral/fileexchange/45145-matlab-support-package-for-raspberry-pi-hardware/).

**2.** *Arduino IDE* - Get your free copy [here](https://www.arduino.cc/en/Main/OldSoftwareReleases).

**3.** *FTDI 2XX Driviers* - Get your free copy [here](http://www.ftdichip.com/Drivers/D2XX.htm).

**4.** *PC104 library for Arduino IDE* - right now there's no simple way to get this library while it's in testing stage, but you can contact *_contacts@robotics.by_* for additional info.

### Step 3: PC104 lib by Robotics.by
After installing Arduino IDE and Java Runtime Environment:

**1.** Copy *robotics_by* folder to *X:\Program Files (x86)\Arduino\hardware*.

**2.** Copy *robotics_by_PC104_main* to *C:\Users\UserName\Documents\Arduino\libraries* (default path for Arduino libraries).

Now in *Sketch -> Include Library* should be new entry *robotics_by_PC104_main lib*, and in File -> Examples should be *robotics_by_PC104_main - example*.

### Step 4
Now proceed to /L1CS/ and /L2CS/ README instructions.
