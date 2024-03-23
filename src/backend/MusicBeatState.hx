package backend;

import h2d.Text;
import hxd.App;

class MusicBeatState extends App {
	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var oldStep:Int;

	override public function update(dt:Float) {
		Conductor.songPosition += dt * 1000;

		oldStep = curStep;

		// trace("BEFORE: " + "oldStep: " + oldStep + "\ncurStep: " + curStep);
		updateStep();
		// trace("AFTER: " + "oldStep: " + oldStep + "\ncurStep: " + curStep);

		if (oldStep != curStep) {
			stepHit();
		}
		else {}
		super.update(dt);
	}

	function updateStep() {
		curStep = Math.floor(Conductor.songPosition / Conductor.stepCrochet);
	}

	function stepHit() {
		if (curStep % 4 == 0)
			beatHit();
	}

	function beatHit() {
		// override this function to add functionality    duh
	}
}