package backend;

import h2d.Text;
import hxd.App;

class MusicBeatState extends App {
	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	override public function update(dt:Float) {
		Conductor.songPosition += dt * 1000;

		var oldStep:Int = curStep;

		updateStep();
		super.update(dt);
	}

	function updateStep() {
		curStep = Math.floor(Conductor.songPosition / Conductor.stepCrochet);
	}

	public function stepHit() {
		trace(curStep);
		if (curStep % 4 == 0)
			beatHit();
	}

	function beatHit() {

	}
}