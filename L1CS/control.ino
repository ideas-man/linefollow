#include <Wire.h>
#include <PC104.h>

/*  main settings  */
#define ACK 55            // acknowledge bit to master device
#define NACK 15           // not acknowledge bit 
#define BAUD_RATE 115200  // strange baud rate for i2c communication, but it works ¯\_(ツ)_/¯
#define SLAVE_ADDR 3      // slave address on i2c bus (0x03)
#define MIN_DC 25         // minimal duty cycle percentage for racing
#define BYTES_RANGE 255   // range in bytes for speed transformation

/*    default pins for different attachments 
 *    (won't work without this definitions)   
 */
#define greenLine  0x01   //Port D0-D3, Arduino 23-26
#define yellowLine 0x02   //Port C4-C7, Arduino 19-22
#define orangeLine 0x04   //Port C0-C3, Arduino 15-18
#define purpleLine 0x08   //Port A0-A2, Arduino 0-2
#define blueLine   0x10   //Port A6-A3, Arduino 3-6
#define pinkLine   0x20   //Port B2,B5-B7,Arduino 9, 12-14
#define xbeeLine   0x40
#define L298Line   0x80

/*  global variables for act of i2c transmission   */
const byte bytes_to_receive = 2;  // number of bytes to receive via i2c
uint8_t status_on_request = NACK; // default status on request is NACK

/*  robot entity  */
PC104 roboCake;

/*  Communication implemented using I2C bus 
 *  (Raspberry Pi 2 and PC104 boards).
 *  For Raspberry Pi 2 I2C pins are:
 *    -- GND: pin 9
 *    -- SCL: pin 5
 *    -- SDA: pin 3
 *  For PC104 pinout see documentation 
 *  for RoboCake Professional at robotics.by
 */


void setup()
{
  /*  setup PC104 address on i2c bus  */
  Wire.begin(SLAVE_ADDR);

  /*  call for receive_input_data() on write() event from master  */
  Wire.onReceive(receive_input_data);

  /*  call for send_status_byte() on read() event from master  */
  Wire.onRequest(send_status_byte);

  /*  setup baud rate for i2c communication  */
  Serial.begin(BAUD_RATE);

  /*  RoboCake initialization  */
  roboCake.loadControl(0|L298Line|greenLine|yellowLine|orangeLine|purpleLine|blueLine|pinkLine);
}


/* receive two bytes: duty cycle (dc) for left and right motors */
void receive_input_data(int num_of_bytes)
{ 
  /*  print number of received bytes  */
  Serial.println(num_of_bytes);
  
  /*  array for receiving duty cycle values 
   *                    left   right
                          v     v */
  int16_t dc_data[2] = {0b00, 0b00};
  if(num_of_bytes != 2)
  {
    Serial.println("Received < 2 bytes, skip");
    return;  
  }
 
  /*  Read duty cycle values, calculate speed values 
   *  using reducing coefficient (have been found empirically, 
   *  provides correct driving process) and minimal duty cycle 
   *  percentage value, mainly based on mobile robotic platform's weight.
   *  
   *  It's important to note that you can use your own settings
   *  (for reducing_coeff and MIN_DC). In our case for correct 
   *  driving on our surface at testing area we've picked
   *  this values. Shortly speaking, YMMV.
   */
  float reducing_coeff = 0.15;
  float bytes_per_percent = BYTES_RANGE / 100;
  for(size_t i = 0; i < num_of_bytes; i++)
  {
    dc_data[i] = Wire.read();
    dc_data[i] *= reducing_coeff;
    dc_data[i] += MIN_DC;
    dc_data[i] *= bytes_per_percent;
  }
  
  Serial.print(dc_data[0]);
  Serial.print(" ");
  Serial.println(dc_data[1]);
   
  /* if two (in out case) bytes've been received, send ACK byte to master, NACK otherwise */
  status_on_request = (sizeof(*dc_data) == sizeof(float) * bytes_to_receive) ? ACK : NACK;

  /* send speed values to motors */
  roboCake.drive(dc_data[0], dc_data[1]);
}


void send_status_byte()
{
  Wire.write(status_on_request);
}


void loop()
{
  delay(100);
}
