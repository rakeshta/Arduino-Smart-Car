//
//  HBridgeMotorController.h
//  Created by Rakesh TA on 13/01/12.
//
//  Utility to control DC motors using H-bridge controllers like
//  L298N, TB6612FNG etc.
//

#ifndef HBRIDGEMOTORCONTROLLER_H_
#define HBRIDGEMOTORCONTROLLER_H_

#include "Arduino.h"

// Override this constant to use less or more DC motors
#ifndef HBRIDGE_MOTOR_COUNT
#define HBRIDGE_MOTOR_COUNT 2
#endif

// Convenience constants for 2 motor controllers
#define HBRIDGE_MOTOR_A 0
#define HBRIDGE_MOTOR_B 1


/**
 * Controller class for a single H-Bridge controlled DC motor.
 */
class HBridgeMotor {
private:
	uint8_t _pinPWM;
	uint8_t _pinIN1;
	uint8_t _pinIN2;

  // Default constructor
  HBridgeMotor();

  // Sets the PINs & initializes them
  void setPins(uint8_t pinPWM, uint8_t pinIN1, uint8_t pinIN2);

  // HBridgeMotorController is a friend
  friend class HBridgeMotorController;

public:

  // Constructor
  HBridgeMotor(uint8_t pinPWM, uint8_t pinIN1, uint8_t pinIN2);

  // Gets motor speed
  int16_t speed();

  // Sets motor speed
  void setSpeed(int16_t speed);
};


/**
 * Motor controller for multiple DC motors using a single
 * H-bridge controller.
 */
class HBridgeMotorController {
private:
	HBridgeMotor _motors[HBRIDGE_MOTOR_COUNT];
	uint8_t      _pinStandby;

public:

	// Creates a motor controller for 2 motors
	HBridgeMotorController(
			uint8_t pinPWMA, uint8_t pinIN1A, uint8_t pinIN2A,
			uint8_t pinPWMB, uint8_t pinIN1B, uint8_t pinIN2B,
			uint8_t pinStandby);

	// Gets motor at index.
	// Use constants `HBRIDGE_MOTOR_A` and `HBRIDGE_MOTOR_B` for 2 motor controllers.
	HBridgeMotor & motor(uint8_t index);

	// Gets controller's standby state
	bool isStandby();

	// Sets controller on standby if true
	void setStandby(boolean standby);
};

#endif /* HBRIDGEMOTORCONTROLLER_H_ */

