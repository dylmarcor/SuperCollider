s.boot;

SynthDef(\sinGrain, { |out = 0, freq = 440, amp = 0.5, dur = 1|
	Out.ar(out, SinOsc.ar(freq, 0 , amp) * EnvGen.kr(Env.sine(1), timeScale:dur));
}).add;

2.do({ |chan|
	var rout;
	rout = Routine({
		var freq;
		{   freq = 0;
			rrand(400, 1000).do({ freq = freq + 1});
			[thisThread.clock.beats, thisThread.clock.elapsedBeats].postln;
			Synth(\sinGrain, [\out, chan, \freq, freq, \dur, 0.005]);
			0.1.wait;
		}.loop;
	});
	TempoClock.default.schedAbs(TempoClock.default.elapsedBeats.roundUp(1), rout);
});
