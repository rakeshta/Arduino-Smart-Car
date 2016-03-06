//
//  Pins.h
//  Created by Rakesh TA on 04/03/16.
//
//  Constants for pins used on the board.
//


#ifndef __PINS_H__
#define __PINS_H__

#include "Arduino.h"


// H-bridge motor controller pins
#define PIN_MOTOR_PWMA 11
#define PIN_MOTOR_IN2A 10
#define PIN_MOTOR_IN1A  9
#define PIN_MOTOR_STBY  8
#define PIN_MOTOR_IN1B  7
#define PIN_MOTOR_IN2B  6
#define PIN_MOTOR_PWMB  5

// Speed encoder pins
#define PIN_SPEED_ENCODER_A 2
#define PIN_SPEED_ENCODER_B 3

// Bluetooth pins
#define PIN_BLE_TX  A0
#define PIN_BLE_RX  A1


#endif // __PINS_H__
