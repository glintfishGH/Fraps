package backend;

import hxd.Window;
import h2d.Object;
import hxd.snd.Channel;
import hxsl.Channel;
import openal.AL;
import h2d.Text;
import hxd.App;

enum Axis {
	X;
	Y;
	XY;
}

class MusicBeatState extends App {
	private var curStep:Float = 0;
	private var curBeat:Float = 0;
	private var oldStep:Float;

	public var windowInstance:Window = Window.getInstance();

	override public function update(dt:Float) {
		Conductor.songPosition = PlayState.inst.position * 1000;

		oldStep = curStep;

		updateStep();

		// Stole this from ninjamuffin <3
		if (oldStep != curStep) {
			stepHit();
		}
		super.update(dt);
	}

	function updateStep() {
		curStep = Math.floor(Conductor.songPosition / Conductor.stepCrochet) - Std.int(Conductor.curStepOffset);
	}

	function stepHit() {
		trace(curStep);
		if (curStep % 4 == 0)
			beatHit();
	}

	function beatHit() {
        trace("beat hit");
		// Override this with your custom functionality
	}

	function screenCenter(object:Object, axis:Axis = XY) {
		if (axis == X) {
			object.x = (Window.getInstance().width - object.getSize().width) / 2;
		}
		if (axis == Y)
			object.y = (Window.getInstance().height - object.getSize().height) / 2;
		else {
			object.x = (Window.getInstance().width - object.getSize().width) / 2;
			object.y = (Window.getInstance().height - object.getSize().height) / 2;
		}
	}
}