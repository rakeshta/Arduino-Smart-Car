//
//  SmartCar.cpp
//  Created by Rakesh TA on 05/03/2016.
//
//  The main class that is the brain of the smart car.
//

#include "Arduino.h"
#include "Pins.h"
#include "SmartCar.h"
#include "HBridgeMotorController.h"

// The motor controller
HBridgeMotorController g_motorController(
    PIN_MOTOR_PWMA, PIN_MOTOR_IN1A, PIN_MOTOR_IN2A,
    PIN_MOTOR_PWMB, PIN_MOTOR_IN1B, PIN_MOTOR_IN2B,
    PIN_MOTOR_STBY);


// Set target speed on the left & right
void SmartCar::setSpeed(int16_t left, int16_t right) {
  g_motorController.motor(HBRIDGE_MOTOR_A).setSpeed(left);
  g_motorController.motor(HBRIDGE_MOTOR_B).setSpeed(right);
}


// Triggers a sonar ping
void SmartCar::sonarPing() {
  // TODO: Implement this
}


