//
//  RotaryEncoderController.cpp
//  Created by Rakesh TA on 09/02/12.
//
//  Utility to measure the speed in RPM of 2 rotary encoders using
//  an opto-coupler.
//

#include "RotaryEncoderController.h"

// Constants for each rotary encoder
#define ROTARY_ENCODER_A 0
#define ROTARY_ENCODER_B 1

// Constants for RPM computation
#define ROTARY_ENCODER_INTERVAL             1000ul * 1000ul     // In microseconds
#define ROTARY_ENCODER_RPM_MULTIPLIER       60000000.0f / 20.0f // 6x10E7 micros in a min; 20 slots


/*
 * Class to manage a single rotary encoder
 */

class RotaryEncoder {
private:
	volatile uint16_t _counter;
	uint16_t          _rpm;
	uint8_t           _pin;

public:
	void begin(uint8_t pin, void (*ISR)());
	void update();
	void end();
  
	uint16_t rpm();

  void incrementCounter();
};

// Scratch variables for RPM computation. Putting this on the heap
// to avoid allocating it on the stack.
static unsigned long g_startTime;
static unsigned long g_time;
static unsigned long g_delta;


// Setups up the encoder
void RotaryEncoder::begin(uint8_t pin, void (*ISR)()) {

	// Initialize state
	_counter = 0;
	_rpm     = 0;
	_pin     = pin;

	// Attach interrupt
	attachInterrupt(digitalPinToInterrupt(pin), ISR, RISING);
}

// Called to updates RPM periodically.
void RotaryEncoder::update() {
	_rpm     = (float)_counter * ROTARY_ENCODER_RPM_MULTIPLIER / g_delta;
	_counter = 0.0;
}

// Tears down the encoder
void RotaryEncoder::end() {

	// Detach interrupt
	detachInterrupt(digitalPinToInterrupt(_pin));

	// Reset state
	_counter          = 0;
	_rpm              = 0;
	_pin              = 0;
}

// Gets the current RPM
uint16_t RotaryEncoder::rpm() {
	return _rpm;
}

// Called by the ISR to increment the counter
void RotaryEncoder::incrementCounter() {
  _counter++;
}


// The two rotary encoders
static RotaryEncoder g_encoders[2];


// Two separate static ISRs for each encoder
void RotaryEncoderISRA() {
  g_encoders[ROTARY_ENCODER_A].incrementCounter();
}

void RotaryEncoderISRB() {
  g_encoders[ROTARY_ENCODER_B].incrementCounter();
}


// Sets up the two rotary encoders
void RotaryEncoderController::begin(uint8_t pinA, uint8_t pinB) {

	// Initialize start time
	g_startTime = micros();

	// Begin each encoder
	g_encoders[ROTARY_ENCODER_A].begin(pinA, RotaryEncoderISRA);
	g_encoders[ROTARY_ENCODER_B].begin(pinB, RotaryEncoderISRB);
}

// Updates the RPM when necessary
void RotaryEncoderController::loop() {
	noInterrupts();
	{
		// Update RPM if interval has passed
		g_time  = micros();
		g_delta = g_time - g_startTime;
		if (g_delta >= ROTARY_ENCODER_INTERVAL) {

			// Update RPM
			g_encoders[ROTARY_ENCODER_A].update();
			g_encoders[ROTARY_ENCODER_B].update();

			// Reset start time
			g_startTime = g_time;
		}
	}
	interrupts();
}

// Stops the rotary encoders
void RotaryEncoderController::end() {
	g_encoders[ROTARY_ENCODER_A].end();
	g_encoders[ROTARY_ENCODER_B].end();
}

// Gets the RPMs measured by the encoder
uint16_t RotaryEncoderController::rpmA() {
	return g_encoders[ROTARY_ENCODER_A].rpm();
}
uint16_t RotaryEncoderController::rpmB() {
	return g_encoders[ROTARY_ENCODER_B].rpm();
}
