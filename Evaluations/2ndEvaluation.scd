
// 1.- Answer the following questions

// a
//What is the difference between a MIDI Command and a MIDI Data?:

"A MIDI command is a defined instruction to execute, like note on, note off, a control change, etc. This command needs MIDI data so it can apply the desired command. For example a 101 or note onneed as data the desired note, the channel in which is going to be played and the velocity of the note.".speak;



// b
// What is the anatomy of a MIDI Message?
/*
* Is composed of three bytes
* The first one is the command with a channel like this: 1001 0000
* The second one is the data byte 1 containing for example a note: 00111100
* And the third and last one could be for example the velocity: 01111111
*/

// Use a NoteOn message with a MIDI note of 60, velocity of 90 on channel 8 as an example
// c
// What is the hexadecimal notation for a NoteOff Command?: 88-3C-5A
// What is the hexadecimal notation for a MIDI Data transporting the number 127?: 88-3C-7F

// Using the two examples before, Can you propose a method to tell a MIDI Command from a MIDI Data by looking at their hexadecimal representation?
"If the first hex number is greather than 7, it means that is a command. If its equal or less than 7 we have a midi data".speak;

// Use your notes from class and complete the following code

MIDIClient.init

// 2.-
// ----------------------------------------------------
// Complete the following line such that it works with your system
// and establishes midi communication with the correct MIDI Bus.
MIDIClient.externalSources;
m = MIDIOut(0);

// 3.-
// ----------------------------------------------------
// Once you have connection with a MIDI out open Reason and
// create pitched instrumento to receive MIDI.
// Remember to assign the MIDI channel to that instrument in the Advanced MIDI panel

// Use the following line to test your connection.

m.noteOn(0, 60, 127);

// 4.-
// ----------------------------------------------------
// Now use the following Tdef to send MIDI messages to the instrument you just
// created in Reason.
// Analyse the code and modify it such that it produces a different melody than the one that
// is already implemented an another rhythm.
Scale.directory
(
~mOne = Tdef(\midiOne, {
	var ppitch, pdur;

	// This line controls the pitches generated as midi notes.
	ppitch = Prand([60, 62, 65, 67, 70],inf).asStream;
	// This line controls the durations for each note generated in seconds
	pdur = Pseq([0.25, 0.25, 0.25, 0.50, 0.75, 0.75, 1],inf).asStream;

	inf.do({|i|
		var note, dur, extra, semitone;
		note = ppitch.next;
		dur = pdur.next;
		extra = rrand(0, i%12);
		semitone = rrand(0, 1);
		if ( semitone == 0, {extra = extra.asInt;});

		extra.postln;

		// Send your MIDI notes here
		m.noteOn(0, note+extra, 127);
		//----------------------

		dur.wait; // For no reason you should remove this line

	})
}).play
)

~mOne.stop


// 5.-
// ----------------------------------------------------
Scale.directory;
(
~tdMaj = Tdef(\tdMajor, {
	var pMaj, pRito, rit;

	// Remember the".convertRhythm"?
	// Can you modify it to produce a better result ?
	// Yes you can!!!
	// Please, go ahead...

	//[beat-count, [rtm-list], repeats]
	rit = [
		6,
		[
			[1, [2, [8, [1, 1, 2]]]],
			1, 1, 2, 3,
			[8, [4, [2, [1, 2, 3]]]]
		],
		8
	].convertRhythm;

	//[2, [subdivisiones]]

	pMaj = Prand(Scale.at(\major).degrees, inf).asStream;
	pRito = Pseq(rit, inf).asStream;

	inf.do({|i|
		var dur;
		m.noteOn(0,69+pMaj.next, rrand(75, 110));
		dur = pRito.next;
		(dur*0.75).wait;

	})
})
)

~tdMaj.play
~tdMaj.stop



// 6.-
// ----------------------------------------------------
MIDIClient.init;
MIDIClient.sources
MIDIIn.connectAll;

// Remember de syntax for a MIDIdef and its most important methods

MIDIdef.noteOn(\respOn, {"key down".postln}).enable
MIDIdef.noteOn(\respOn, {"key down".postln}).disable
MIDIdef.noteOn(\respOn, {"key down".postln}).free

MIDIdef.freeAll

MIDIdef.noteOn(\respOn, {"key down".postln}).permanent_(true) // survives the [cmd + .]
MIDIdef.noteOn(\respOn, {"key down".postln}).permanent_(false)// dies under the [cmd + .]


// Use the following code to identify in which channel your keyboard is transmitting
/*
* Is transmitting on chann 0
*/
(MIDIdef.noteOn(\respOn, {|val, num, chan, src|
	[val, num, chan, src].postln;
	"key down".postln
}));


//  Use the following SynthDef to test your code from the following section

// ----------------------------------------------------
(
SynthDef(\note, {|note = 60, amp = 0.3, gate = 1, bend = 0|
	var env, sin;

	env = EnvGen.kr(Env.asr(0.5, 1, 1), gate, doneAction:2);
	sin = Blip.ar((note.midicps)*bend.midiratio, XLine.kr(1, 3, 0.125), amp);

	Out.ar(0, sin*env);

}).add
)

~sn1 = Synth(\note, [\note, 60, \amp, 0.7, \bend, 0]);
~sn1.set(\gate, 0);

// ----------------------------------------------------


//-------------------
// Start by freeing all the MIDIdefs that might be defined in your system

MIDIdef.freeAll
~notes = Array.newClear(128); //I defined it here because inside the parentesis it was allways null
~bend = 0;


// 7.-
// ----------------------------------------------------
// Now you are going to build a MIDIdef to respond polyphonically to your keyboard

(
// a:
// Find the help sheet for the object "Array" and figure out how to use the ".newClear" method
// to generate an empty Array with 128 elements.
// Now, produce an Array with 128 elements and assign it to the variable "~notes"

// Remember that you can access any element N in the Array using the syntax
// ~notes[N]
// So you would access the element number 10 in the following manner ~notes[10]

// b:
// Add to the MIDIdef.noteOn function a line that produces an instance of the Synth(\note)
// with a midi note, and velocity that corresponds to the note and velocity that you are receiving
// as arguments to the MIDIdef funtion.
// Finally, assing this instance to the element "N" in the Array ~notes
// such that N is equal to the MIDI note produced by the keyboard.
~mDefNOn = MIDIdef.noteOn(\poliNote, {|val, num, chan, src|
	[val, num, chan, src].postln;
	~notes[num] = Synth(\note, [\note, num, \amp, val.linlin(0, 127, 0.0, 0.1), \bend, ~bend]);
});

// c:
// You might notice that until now you can turn any note on using your keyboard, but it does not
// turn off.
// So now we are going to implement the MIDIdef's ".noteOff" function.

// In the following lines you will find the syntax to implement the MIDIdef's ".noteOff" function.
// In that function use the ~notes array to call the ".set(\gate, 0)" message for the corresponding note
// to the key that is being lifted from the keyboard.
// ie.
// If the key being liftes corresponds to the note 77, we expect the following function to affect the
// Synth stored in the element 77 in the array ~notes.
// Finally, assign the value "nil" to the element you just turned off.
//
~mDefNOff = MIDIdef.noteOff(\poliNoteOff, {|val, num, chan, src|
	//[val, num, chan, src].postln;
	~notes[num].set(\gate, 0);
	~notes[num] = nil;
});

// d:
// Now, for some extra point, should you need them, we will implement a responder for the
// "MIDIdef.bend" function.

// Create a variable called ~bend

// Your variable here:



// Now, run the bend function as it is implemented in the following lines
// and review the values that you are getting from the bend controller in
// the keyboard.
// What can you comment on the range of values you are getting?
~mDefBend = MIDIdef.bend(\bnd, {|val, cha, src|

	[val,cha,src].postln;

	// Here, assign to the variable "~bend" the value from the keyboard controller
	// using the ".linlin(input min, input max, output min, output max );" method
	// to map the input values to change from -2 semitone to +2 semitones.
	// If you  are not sure how to use the ".linlin()" method, ask me or look for
	// it in the help browser.

	// Your code here:

	// If you have done everything as instructed, by uncommenting the
	// following lines your bending should be functional.

	/*
	~notes.do({|sy|
		sy.set(\bend, ~bend);
	});
	*/

	// Now write a short comment explaining what is happening in the last 3 lines
	// you uncommented

	~bend = val.linlin(0, 16383, -2, 2);
	//For every element/synth in the array we set the bend value
	~notes.do({|sy|
		if ( sy != nil, {
			sy.set(\bend, ~bend);
		});
	});

})


)

