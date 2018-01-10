
/*
* Initializes the MIDIClient, checks which available MIDI sources and destinations there are,
* and opens as many connections as desired.
*/
MIDIClient.init;

m = MIDIOut(0);

//arguments( Chanel, note and velocity )
m.noteOn(0, 60, 12);


//Drums have values from 35 to 45

Scale.directory;
Scale.mahur.degrees;

(

~seqTd = Tdef( \seq, {

	var melody, amplitude, scale;
	/*
	* Pitch class will define notes
	* according to the octave position
	* [0, 1, 2, 3] -> [ C, C#, D, D#]
	* And also we can add some values
	*/
	melody = [0, 5, 4, 4, 9, 8, 9, 12, 11, 7, 0, 2, 3, 8, 9, 12].scramble;
	amplitude = [1, 0, 0 ,0 , 0, 1 , 1 , 0, 1, 0, 1, 0, 1, 0, 1, 0];
	scale = Scale.mahur.degrees;

	inf.do({ | i |
		var np;
		np = i % 16;
		//np.postln;
		//arguments( Chanel, note and velocity )
		m.noteOn(0, 55 + scale[ melody[np] % scale.size ], amplitude[np] * 127);
		m.noteOn(1,  (36+scale[melody[np]%scale.size]) % 45, amplitude[np] * 127);
		m.control(1, (19), rrand(0,127));


		if ( np == 0,
			{
				melody = melody.scramble;
				amplitude = amplitude.scramble;
				"scrambling".postln;
			}
		);

		0.125.wait;
		//m.noteOff(0,30,64);
	})

})

)

~seqTd.play;
~seqTd.stop;