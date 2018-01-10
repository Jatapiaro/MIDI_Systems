
/*
* Initializes the MIDIClient, checks which available MIDI sources and destinations there are,
* and opens as many connections as desired.
*/
MIDIClient.init;

m = MIDIOut(0);

//arguments( Chanel, note and velocity )
m.noteOn(0, 60, 12);

(

~seqTd = Tdef( \seq, {

	var melody;
	/*
	* Pitch class will define notes
	* according to the octave position
	* [0, 1, 2, 3] -> [ C, C#, D, D#]
	* And also we can add some values
	*/
	melody = [0, 5, 4, 4, 9, 8, 9, 12, 11, 7, 0, 2, 3, 8, 9, 12];

	inf.do({ | i |
		var np;
		np = i % 16;
		np.postln;
		//arguments( Chanel, note and velocity )
		m.noteOn(0, 30 + np, 64);
		0.25.wait;
		//m.noteOff(0,30,64);
	})

})

)

~seqTd.play;
~seqTd.stop;