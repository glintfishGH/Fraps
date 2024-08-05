package backend;

import h2d.Text;
import hxd.App;

class MusicBeatState extends App {
	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var oldStep:Int;

	override public function update(dt:Float) {
		/**
		 * Heaps doesn't have a `position` paramater for sounds, so this will have to do for now.
		 */
		Conductor.songPosition += dt * 1000;

		oldStep = curStep;

		updateStep();

		// Stole this from ninjamuffin <3
		if (oldStep != curStep) {
			stepHit();
		}
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
		// Override this with your custom functionality
	}
}