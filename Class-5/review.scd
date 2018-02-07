MIDIClient.init;

//You need a nnxt in reason to run this.

m = MIDIOut(0);

m.noteOn(0, 60, 127);


t = TempoClock.default.tempo  = 4;


(

~mel = Tdef( \mel, {

	inf.do({
		|i|
		var indx;
		indx = i%16;

		switch ( indx.asInteger,

			0, { m.noteOn(0, 60, 90); },
			2, { m.noteOn(0, 62, 90); },
			4, { m.noteOn(0, 61, 90); },
			5, { m.noteOn(0, 69, 90); },
			7, { m.noteOn(0, 80, 90); },
			8, { m.noteOn(0, 78, 90); },
			10, { m.noteOn(0, 68, 90); },
			11, { m.noteOn(0, 69, 90); },

		);

		0.5.wait;
	})

})

)


~mel.play(t);
~mel.stop;

m.control(0, 1, 127);