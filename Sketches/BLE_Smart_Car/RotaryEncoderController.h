//
//  RotaryEncoderController.h
//  Created by Rakesh TA on 09/02/12.
//
//  Utility to measure the speed in RPM of 2 rotary encoders using
//  an opto-coupler.
//

#ifndef ROTARYENCODERCONTROLLER_H_
#define ROTARYENCODERCONTROLLER_H_

#include "Arduino.h"

/**
 * Class to manage two rotary encoders.
 */
class RotaryEncoderController {
public:
	static void begin(uint8_t pinA, uint8_t pinB);
	static void loop();
	static void end();
	static uint16_t rpmA();
	static uint16_t rpmB();
};

#endif /* ROTARYENCODERCONTROLLER_H_ */
