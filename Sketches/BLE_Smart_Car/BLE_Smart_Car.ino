//
//  BLE_Smart_Car.ino
//  Created by Rakesh TA on 13/01/12.
//
//  Bluetooth controlled smart car
//

#include "SmartCar.h"
#include "RotaryEncoderController.h"
#include "SerialProcessor.h"

void setup() {

  // Start serial communications and wait for port to open:
  {
    Serial.begin(9600);
    while (!Serial);
  
    Serial.println("BLE Smart Car");
  }

  // Start components
  {
    SerialProcessor::begin();
  }
}

void loop() {

  // Loop all the components
  {
    SerialProcessor::loop();
  }
}
