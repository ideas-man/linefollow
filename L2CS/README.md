## L2 control system

Code for high-tier control system based on Raspberry Pi 2 and MATLAB Server.

The given code provides following functionality:
  - Storing all settings parameters (init.m);
  - Path finding (pathvector.m, turnangle.m);
  - Computing duty cycle percentage values for left and right motors (dutycycle.m).
  - Creating all necessary connections, input image processing, sending duty precentage values for left and right motors over I2C interface, overall control of L2 control system (dcontrol.m);
