//
//  BLE_Smart_Car.ino
//  Created by Rakesh TA on 13/01/12.
//
//  Bluetooth controlled smart car
//

#include <SoftwareSerial.h>
#include "HBridgeMotorController.h"
#include "RotaryEncoderController.h"
#include "Packet.h"

// H-bridge motor controller pins
#define PIN_MOTOR_PWMA 11
#define PIN_MOTOR_IN1A  9
#define PIN_MOTOR_IN2A 10
#define PIN_MOTOR_PWMB  5
#define PIN_MOTOR_IN1B  6
#define PIN_MOTOR_IN2B  7
#define PIN_MOTOR_STBY  8

// Speed encoder pins
#define PIN_SPEED_ENCODER_A 2
#define PIN_SPEED_ENCODER_B 3

// Bluetooth pins
#define PIN_BLE_TX  A0
#define PIN_BLE_RX  A1


// Motor controller
HBridgeMotorController motorController(
    PIN_MOTOR_PWMA, PIN_MOTOR_IN1A, PIN_MOTOR_IN2A,
    PIN_MOTOR_PWMB, PIN_MOTOR_IN1B, PIN_MOTOR_IN2B,
    PIN_MOTOR_STBY);


// Bluetoth serial
SoftwareSerial bleSerial(PIN_BLE_RX, PIN_BLE_TX); // RX, TX

// Setup
void setup() {

	// Start rotary encoder
	RotaryEncoderController::begin(PIN_SPEED_ENCODER_A, PIN_SPEED_ENCODER_B);
 
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial);

  Serial.println("BLE Smart Car");

  // Initialize serial com to bluetoth
  bleSerial.begin(9600);
}

// Loop
void loop() {

	// Loop rotary encoder
	RotaryEncoderController::loop();

	// Test motor controller
	testMotorControllerLoop();

  // Test serial receive
  if (bleSerial.available()) {
    Serial.write(bleSerial.read());
  }
  if (Serial.available()) {
    bleSerial.write(Serial.read());
  }
}


/*
 * Test - Motor Controller
 */

void testMotorControllerLoop() {

  // Read potentiometer
  uint16_t pot = analogRead(5);

  // Change speed
  int16_t speed = map(pot, 0, 1023, -255, 255);
  motorController.motor(HBRIDGE_MOTOR_A).setSpeed(speed);
}

