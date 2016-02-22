/*
 * HBridgeMotorController.cpp
 *
 *  Created on: 3 Feb 2016
 *      Author: Rakesh
 */

#include "HBridgeMotorController.h"


/*
 * HBridgeMotor
 */

// Default Constructor
HBridgeMotor::HBridgeMotor() {
  _pinPWM = NOT_A_PIN;
  _pinIN1 = NOT_A_PIN;
  _pinIN2 = NOT_A_PIN;
}

// Constructor
HBridgeMotor::HBridgeMotor(uint8_t pinPWM, uint8_t pinIN1, uint8_t pinIN2) {
  setPins(pinPWM, pinIN1, pinIN2);
}

// Sets the PINs & initializes them
void HBridgeMotor::setPins(uint8_t pinPWM, uint8_t pinIN1, uint8_t pinIN2) {
  _pinPWM = pinPWM;
  _pinIN1 = pinIN1;
  _pinIN2 = pinIN2;

  // Initialize PINs
  pinMode(_pinPWM, OUTPUT);
  pinMode(_pinIN1, OUTPUT);
  pinMode(_pinIN2, OUTPUT);
}

// Gets motor speed
int16_t HBridgeMotor::speed() {
  return 0;
}

// Set speed
void HBridgeMotor::setSpeed(int16_t speed) {
	speed = constrain(speed, -255, 255);

	// Forward
	if (speed > 0) {
		digitalWrite(_pinIN1, HIGH);
		digitalWrite(_pinIN2, LOW);
	}

	// Reverse
	else if (speed < 0) {
		digitalWrite(_pinIN1, LOW);
		digitalWrite(_pinIN2, HIGH);
		speed = -speed;
	}

	// Short brake
	else {
		digitalWrite(_pinIN1, LOW);
		digitalWrite(_pinIN2, LOW);
	}

	// Write speed
	analogWrite(_pinPWM, speed);
}


/*
 * HBridgeMotorController
 */

// Constructor
HBridgeMotorController::HBridgeMotorController(
		uint8_t pinPWMA, uint8_t pinIN1A, uint8_t pinIN2A,
		uint8_t pinPWMB, uint8_t pinIN1B, uint8_t pinIN2B,
		uint8_t pinStandby
		) {

	// Initialize motors
	_motors[HBRIDGE_MOTOR_A].setPins(pinPWMA, pinIN1A, pinIN2A);
	_motors[HBRIDGE_MOTOR_B].setPins(pinPWMB, pinIN1B, pinIN2B);

	// Initialize standby PIN
	_pinStandby = pinStandby;
  pinMode(_pinStandby, OUTPUT);

  // The standby pin will be LOW. So turn off standby by taking it HIGH
  setStandby(false);
}


// Get motor at index
HBridgeMotor & HBridgeMotorController::motor(uint8_t index) {
	return _motors[index];
}

// Gets controller's standby state
bool HBridgeMotorController::isStandby() {
  return digitalRead(_pinStandby) == LOW;
}

// Set motors on standby
void HBridgeMotorController::setStandby(boolean standby) {
	digitalWrite(_pinStandby, standby ? LOW : HIGH);
}
