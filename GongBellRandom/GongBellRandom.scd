b = Buffer.alloc(s, 40, 1);
b.setn(0, Array.fill(40, {1.0.rand2}));
b.plot;
{PlayBuf.ar(1, b, trigger: Impulse.kr(1))}.play

{PinkNoise.ar(EnvGen.kr(Env.perc(0, 0.001), gate: Impulse.kr(1)))}.play;

(
{
var chime, freqSpecs, totalHarm = 10;
var staticBurst, randBurst, blend, burst, trig;
trig = Impulse.kr(1);
staticBurst = PlayBuf.ar(1, b, trigger: trig)*0.2;
randBurst = PinkNoise.ar(EnvGen.kr(Env.perc(0, 0.0001), trig))*5;
blend = MouseX.kr(0, 1.0);
burst = (staticBurst * blend) + (randBurst * (1-blend));

freqSpecs  = `[
	{rrand(100, 1200)}.dup(totalHarm),
	{rrand(0.3, 1.0)}.dup(totalHarm),
	{rrand(2.0, 4.0)}.dup(totalHarm)];
Pan2.ar(
	Klank.ar(freqSpecs, burst)
	*MouseX.kr(0.1, 0.8), 0)
}.play
)
