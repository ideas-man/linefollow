# LineFollow

A somewhat overcomplicated way to make a line following robot which uses on-board camera for navigation.

High-tier control system (`L2CS/`): Raspberry Pi 2 Model B + Raspberry Pi Camera Board V2
  - Storing all settings parameters (init.m);
  - Path finding (pathvector.m, turnangle.m);
  - Computing the duty cycle percentage values for the left and right motors (dutycycle.m).
  - Creating all necessary connections, input image processing, sending duty precentage values for both motors over the I2C interface, general control of L2 control system (dcontrol.m).

Low-tier control system (`L1CS/`): PC104 control board + Two 3W DC motors without encoders, L298N motor driver.  
  - Receiving duty cyle percentage for left and right motors via I2C;
  - Proccessing the duty cyle values and controlling the motors.
