package backend;

import h2d.Scene;
import slide.Slide;
import hxd.Timer;
import haxe.CallStack;
import format.png.Data.Color;
import h2d.Tile;
import h2d.Bitmap;
import hxd.Window;
import h2d.Object;
import hxd.snd.Channel;
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

	public var attachedSong:Channel;

	public var windowInstance:Window = Window.getInstance();
	var flashSprite:Bitmap;

	override public function init() {
		super.init();
		trace("eat my asssssss");
	}

	override public function update(dt:Float) {
		super.update(dt);
        Slide.step(dt);
		if (attachedSong != null)
			Conductor.songPosition = attachedSong.position * 1000;

		oldStep = curStep;

		updateStep();

		// Stole this from ninjamuffin <3
		if (oldStep != curStep) {
			stepHit();
		}
	}

	function updateStep() {
		// trace(Conductor.songPosition, Conductor.stepCrochet);
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
		else if (axis == Y)
			object.y = (Window.getInstance().height - object.getSize().height) / 2;
		else {
			object.x = (Window.getInstance().width - object.getSize().width) / 2;
			object.y = (Window.getInstance().height - object.getSize().height) / 2;
		}
	}

	// function flash(duration:Float, color:Int) {
	// 	flashSprite.alpha = 1;
	// 	s2d.addChild(flashSprite);

	// 	while (duration < 20) {
	// 		duration += Timer.dt;
	// 		trace(duration);
	// 		trace("whileing");
	// 		flashSprite.alpha = hxd.Math.lerp(1, 0, 0.06);
	// 	}
	// }
}