(
SynthDef("clicky", {arg freq=50, spd=0.5, lvl=0.6, tms=4, mx=0.4, rm=0.6;
var env = EnvGen.kr(Env.new([0, lvl, lvl, 0], [tms, tms-2, tms]), doneAction:2);
var snd = RLPF.ar(Pulse.ar(spd, 0.5,0.1), freq, 0.15)*env;
var vrb = FreeVerb.ar(snd, mx, rm);
Out.ar([0,1], vrb);
}).add;

SynthDef("droney", {arg freq=50, mx=0.3, lvl=0.5, tms=5;
var env, lfof, lfoa, saws, sound, vrb;

env = EnvGen.kr(Env.new([0, lvl, lvl, 0], [tms, tms-2, tms]), doneAction:2);
lfof = Array.fill(5, {LFNoise1.kr(1, 0.005*freq, 0) + PinkNoise.kr(0.008)});
lfoa = Array.fill(5, {LFNoise1.kr(15, 0.1, 1)});
saws = Array.new(5);

5.do({|i| saws.add(Saw.ar(freq + lfof[i], env*lfoa[i]) + RLPF.ar(PinkNoise.ar(),freq,0.01, 0.01))});
sound = Mix(saws);
vrb = FreeVerb.ar(Splay.ar(RLPF.ar(saws, 1000)), mx);
Out.ar(0, vrb);
}).add;

SynthDef("kuh-droney", {arg freq=50, mx=0.3, lvl=0.5, tms=5, lfa=4; var env, lfof, lfoa, saws, sound, cmp, vrb;
env = EnvGen.kr(Env.new([0, lvl, lvl, 0], [tms, tms-2, tms]), doneAction:2); lfof = Array.fill(5, {LFNoise1.kr(1, 0.005*freq, 0) + PinkNoise.kr(0.008)}); lfoa = Array.fill(5,
{LFNoise1.kr(15, 0.1, 1)}); saws = Array.new(5); 5.do({|i| saws.add(Saw.ar(freq + lfof[i], env*lfoa[i]) + RLPF.ar(PinkNoise.ar(),freq, 0.01, 0.01))}); saws = Mix(saws); cmp =
Compander.ar(saws, saws, thresh: 0.2, slopeBelow: 1, slopeAbove: 0.5, clampTime: 0.01, relaxTime: 0.01)* Saw.kr(lfa);
vrb = FreeVerb.ar(PanAz.ar(2, RLPF.ar(cmp, 3000)), mx);
Out.ar(0, vrb);
}).add; )

(
{
~sections = Array(3); ~array1 = [50,100,200,400,500,600,700,800,900,1000,1100]; ~array2 = [50,100,200,300,400,500,600,700,800]; ~array3 = [1000, 1100, 1200, 1300];
~sections.add({ "***Section 1***".postln; 3.do({ Synth("droney", [\freq, ~array1.choose, \mx, rrand(0.4,0.9), \lvl, rrand(0.7,1), \tms, rrand(6,12)]); [Silent.ar(), Synth("droney",
[\freq, [1000, 1100, 1200, 1300].choose, \mx, rrand(0.4,0.9), \lvl, rrand(0.4,0.6), \tms, rrand(6,12)])].choose; Synth("droney", [\freq, [50,100].choose, \mx, rrand(0.4,0.9), \lvl,
rrand(0.7,1), \tms, rrand(6,12)]); 10.wait; });

Synth("droney", [\freq, ~array1.choose, \mx, rrand(0.4,0.9), \lvl, rrand(0.7,1), \tms, rrand(6,12)]); [Silent.ar(), Synth("droney", [\freq, ~array3.choose, \mx, rrand(0.4,0.9), \lvl, rrand(0.4,0.6), \tms, rrand(6,12)])].choose; Synth("droney", [\freq, [50,100].choose, \mx, rrand(0.4,0.9), \lvl, rrand(0.7,1), \tms, rrand(6,12)]); 10.wait; // 0:30-0:40
});
~sections.add({ "***Section 2 -- 0:40***".postln;
Synth("clicky", [\freq, ~array2.choose, \spd, [0.25, 0.5, 0.75, 1, 2].choose, \lvl, rrand(0.2,0.4), \tms, rrand(6,12), \mx, rrand(0.2,0.9), \rm, rrand(0.7, 1.0)]);
Synth("droney", [\freq, ~array1.choose, \mx, rrand(0.4,0.9), \lvl, rrand(0.7,1), \tms, rrand(6,12)]);
Synth("droney", [\freq, ~array3.choose, \mx, rrand(0.4,0.9), \lvl, rrand(0.4,0.6), \tms, rrand(6,12)]);
Synth("droney", [\freq, [50,100].choose, \mx, rrand(0.4,0.9), \lvl, rrand(0.7,1), \tms, rrand(6,12)]);

10.wait; // 0:40-0:50
}
);

~sections.add({ "***Section 3 -- 0:50***".postln;
Synth("clicky", [\freq, 33, \spd, [0.25, 0.5].choose, \lvl, rrand(0.4,0.6), \tms, rrand(6,12), \mx, rrand(0.2,0.4), \rm, rrand(0.7, 1.0) ]);
Synth("droney", [\freq, ~array1.choose, \mx, rrand(0.4,0.9), \lvl, rrand(0.7,1), \tms, rrand(6,12)]); Synth("droney", [\freq, ~array3.choose, \mx, rrand(0.4,0.9), \lvl, rrand(0.4,0.6), \tms, rrand(6,12)]); Synth("droney", [\freq, [33,33].choose, \mx, rrand(0.4,0.9), \lvl, rrand(0.7,1), \tms, rrand(6,12)]); Synth("kuh-droney", [\freq, [33,33].choose, \mx, rrand(0.2,0.3), \lvl, rrand(0.7,1), \tms, rrand(6,12)]);
10.wait; // 0:50-1:00

"***ALL DONE***".postln;
});

~sections[0].();
~sections[1].();
~sections[2].();
}.fork;
)