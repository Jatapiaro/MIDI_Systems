~mf = SimpleMIDIFile.read("schumann_humming_song.mid");

~mf.play;


//Install fomus
Quarks.gui

MIDIClient.init;
~mOut = MIDIOut.newByName("Driver IAC", "Bus 1").latency_(Server.default.latency);

(

~pat = Pdef(\pat,

	Pbind(\type, \midi, \midicmd, \noteOn, \midiOut,  ~mOut, \chan, 1, \note,
		Pseq([[0,7], 4, [2,5], [4, 12], 5, [7, 11], [7,9], 4, [9, -3], 12, -3, 4, 0], inf),
		\dur, Pseq([0.5, 0.7]*0.5, inf),
		\amp, Pseq([0.58, 0.28], inf))

)

)

~pat.play;
~pat.stop;



