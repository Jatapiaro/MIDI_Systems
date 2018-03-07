#include <MIDI.h>

// Simple tutorial on how to receive and send MIDI messages.
// Here, when receiving any message on channel 4, the Arduino
// will blink a led and play back a note for 1 second.

MIDI_CREATE_DEFAULT_INSTANCE();

static const unsigned ledPin = 13;      // LED pin on Arduino Uno
static const unsigned analogInPin = A0;

int sensorValue = 0;
int outputValue = 0;

void setup()
{
    pinMode(ledPin, OUTPUT);
    MIDI.begin(4);                      // Launch MIDI and listen to channel 4
}

void loop()
{
  digitalWrite(ledPin, HIGH);
  MIDI.sendNoteOn(42, 127, 1);    // Send a Note (pitch 42, velo 127 on channel 1)
  delay(100);                    // Wait for a second
  MIDI.sendNoteOff(42, 0, 1);     // Stop the note
  digitalWrite(ledPin, LOW);

  readAnalogueInput();

  digitalWrite(ledPin, HIGH);
  MIDI.sendNoteOn(outputValue, 127, 1);    // Send a Note (pitch 42, velo 127 on channel 1)
  delay(100);                    // Wait for a second
  MIDI.sendNoteOff(outputValue, 0, 1);     // Stop the note
  digitalWrite(ledPin, LOW);
}

void readAnalogueInput() {
  sensorValue = analogRead(analogInPin);
  // map it to the range of the analog out:
  outputValue = map(sensorValue, 0, 1023, 20, 100);
}
