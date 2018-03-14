MIDIClient.init;
MIDIIn.connectAll;

//--------

MIDIdef.noteOn(\respOn, {"keydown".postln}).disable;
MIDIdef.noteOn(\respOn, {"keydown".postln}).free;

MIDIdef.freeAll;

MIDIdef.noteOn

(
~mDef = MIDIdef.noteOn(\respOn, {|val, num, chan,src|

	"keydown".postln;
	{ EnvGen.kr(Env.perc, doneAction:2) * SinOsc.ar() }.play;

})
)

~mDef.enable;
~mDef.disable;


//--------

(
SynthDef(\synth, {|note = 60, amp = 0.3, gate = 1, bend = 0|

	var env, sin, myNote;

	env = EnvGen.kr(Env.asr(0.5, 1, 1), gate, doneAction: 2);

	/*
	** Midiratio produce a value that gen your multiply a freq by that,
	** the result freq, is the number of intervals that I have to move
	*/
	myNote = note.midicps * bend.midiratio;

	sin = SinOsc.ar(myNote, 0, amp);

	Out.ar(0, sin*env);

}).add
)

~sn1 = Synth(\synth)
~sn1.set(\synth, 0);

MIDIdef.freeAll;
~synth = Array.newClear(128);
~bend = 8192;

(
~mDefNoteOn = MIDIdef.noteOn(\poliNoteOn, {|val, num, chan, src|
	~synth[num] = Synth(\synth, [\note, num, \amp, val.linlin(0, 127, 0.0, 0.1), \bend, ~bend]);
});

~mDefNoteOff = MIDIdef.noteOff(\poliNoteOff, {|val, num, chan, src|
	~synth[num].set(\gate, 0);
	~synth[num] = nil;
});

// 0 - 8192 - 16383
~mDefBend = MIDIdef.bend(\poliNoteBend, {|val, chan, src|
	[val, chan, src].postln;
	~bend = val.linlin(0, 16383, -2, 2);
	//For every element in the array I'm going to modify what i have there
	~synth.do({|sy|
		sy.set(\bend, ~bend);
	});
});

)

//----------
/*
** For MIDI files instal wslib
*/
Quarks.gui;


