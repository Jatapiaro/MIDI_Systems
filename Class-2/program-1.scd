/*
* Syntethizer: Produces the sound either by calculating or by reading a wave table or
* producing distorsion by two signals
* Sampler: Use recordings of a sound at different pitches, and each recording use four arrange of notes
*
*/

MIDIClient.init;
m = MIDIOut(0);

m.noteOn(0, 61, 12);

~maj = Scale.major.degrees;
~maj[0];

//This is how you create a task
(
~tmaj = Task({
	7.do({ |i|
		m.noteOn(0, 60 + ~maj[i], 100);
		1.wait;
	});
});
)

~tmaj.play;
~tmaj.reset;


//This is how you create a task
(
{
	7.do({ |i|
		m.noteOn(0, 60 + ~maj[i], 100);
		1.wait;
	});
}.fork();
)

~tmaj2.play;
~tmaj2.reset;



(
//Task definition
~seqTd = Tdef( \seq, {

	inf.do({ | i |
		var np;
		np = i % 12;
		m.noteOn(0, 60+~maj[i%~maj.size], 100);

		0.125.wait;
	})
})

)

~seqTd.play;
~seqTd.stop;


///-------
//As stream repeat or change the index automatically
p = Pseq(Scale.major.degrees, inf).asStream;
p.next;

~rit = [
	4,
	[1, [2,1]],
	[1, [1,1,1]],
	[1, [2,1]],
	[1, [2,1]]
].convertRhythm();

~pRito = Prand(~rit, inf).asStream;

(
//Task definition
~seqMaj = Tdef( \seq, {

	inf.do({ | i |
		var np, dur;
		np = i % 12;
		m.noteOn(0, 60+p.next, 100);
		dur = ~pRito.next;
		dur.wait;
	})
})
)

~seqMaj.play;
~seqMaj.stop;

