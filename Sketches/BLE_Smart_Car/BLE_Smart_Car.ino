//
//  BLE_Smart_Car.ino
//  Created by Rakesh TA on 13/01/12.
//
//  Bluetooth controlled smart car
//

#include "HBridgeMotorController.h"
#include "RotaryEncoderController.h"
#include "SerialProcessor.h"
#include "Packet.h"
#include "Pins.h"


// Motor controller
HBridgeMotorController motorController(
    PIN_MOTOR_PWMA, PIN_MOTOR_IN1A, PIN_MOTOR_IN2A,
    PIN_MOTOR_PWMB, PIN_MOTOR_IN1B, PIN_MOTOR_IN2B,
    PIN_MOTOR_STBY);


// Setup
void setup() {

 
  // Start serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial);

  Serial.println("BLE Smart Car");

  // Start components
  {
    SerialProcessor::begin();
  }
}

// Loop
void loop() {

  // Loop all the components
  {
    SerialProcessor::loop();
  }
}
