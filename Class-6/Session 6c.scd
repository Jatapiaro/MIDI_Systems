MIDIClient.init
MIDIClient.sources

MIDIIn.connectAll

MIDIIn.connect(0, MIDIClient.sources.at(5))
MIDIIn.disconnect(0, MIDIClient.sources.at(5))

MIDIIn.findPort("Mbox", "External")



MIDIClient.sources.at(5)
MIDIClient.sources[1]

~mf = MIDIFunc.noteOn({|vel, num, chan, src|
	[vel, num, chan, src].postln;
})

//-----------------------------------------

~noteOn = {|src, chan, num, vel|
	[src, chan, num, vel].postln;
	~s1 = Synth(\default, [\freq, num.midicps, \amp, vel.linlin(0, 127, 0, 0.63)]);
	~s2 = Synth(\default, [\freq, (num+4).midicps, \amp, vel.linlin(0, 127, 0, 0.63)]);
	~s3 = Synth(\default, [\freq, (num+7).midicps, \amp, vel.linlin(0, 127, 0, 0.63)]);

}

~noteOn1 = {|src, chan, num, vel|
	[src, chan, num, vel].postln;
	Synth(\default, [\freq, (7+num).midicps]);
}

~noteOn.value()

MIDIIn.addFuncTo(\noteOn, ~noteOn);
MIDIIn.replaceFuncTo(\noteOn, ~noteOn, ~noteOn2);
MIDIIn.addFuncTo(\noteOn, ~noteOn1);
MIDIIn.removeFuncFrom(\noteOn, ~noteOn2)
MIDIIn.removeFuncFrom(\noteOn, ~noteOn)

~noteOff = {|src, chan, num, vel|
	[src, chan, num, vel].postln;
	~s1.set(\gate, 0);
	~s2.set(\gate, 0);
	~s3.set(\gate, 0);

}

MIDIIn.addFuncTo(\noteOff, ~noteOff);
MIDIIn.removeFuncFrom(\noteOff, ~noteOff);

~piano = Array.newClear(127);
~piano.size

~noteOn = {|rsc, chan, num, vel|
	[rsc, chan, num, vel].postln;

	~piano[num] = Synth(\default, [\freq, num.midicps, \amp, vel.linlin(0, 127, 0, 1)]);
}
~noteOff = {|src, chan, num, vel|
	~piano[num].set(\gate, 0);
}

MIDIIn.addFuncTo(\noteOn, ~noteOn);
MIDIIn.addFuncTo(\noteOff, ~noteOff);

MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
MIDIIn.removeFuncFrom(\noteOff, ~noteOff);



(
~mf = MIDIFunc.noteOn({|vel, num, chan, src|
	[vel, num, chan, src].postln;
	~piano[num] = Synth(\default, [\freq, num.midicps, \amp, vel.linlin(0, 127, 0, 1)]);
});

~mfOff = MIDIFunc.noteOff({|vel, num, chan, src|
	[vel, num, chan, src].postln;
	~piano[num].set(\gate,0);
});
)






