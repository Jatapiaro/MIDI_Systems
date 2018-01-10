
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