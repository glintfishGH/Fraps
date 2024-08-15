package backend;

import hxd.SceneEvents.InteractiveScene;
import h2d.Scene;
import h2d.Tile;
import slide.easing.Quart;
import slide.easing.Quad;
import slide.tweens.Tween.EaseFunc;
import slide.Slide;
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

class MusicBeatState extends Scene {
	public static var scenesToUpdate:Array<MusicBeatState> = [];

	private var curStep:Float = 0;
	private var curBeat:Float = 0;
	private var oldStep:Float;

	public var attachedSong:Channel;

	public var windowInstance:Window = Window.getInstance();
	var flashSprite:Bitmap;

	public function new() {
		super();
		trace("Opened new scene.");
	}

	public function update(dt:Float) {
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

	override function onAdd() {
		super.onAdd();
		trace("added scene " + Type.getClassName(Type.getClass(this)).split('.').pop());

		scaleMode = ScaleMode.AutoZoom(Window.getInstance().width, Window.getInstance().height);
		// x = (Window.getInstance().width - width) / 2; 
        defaultSmooth = true;

		scenesToUpdate.push(this);
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

	function flash(duration:Float, ?ease:EaseFunc) {
		ease ?? Quart.easeInOut;
		flashSprite = new Bitmap(Tile.fromColor(0xFFFFFFFF, Window.getInstance().width, Window.getInstance().height, 1));
		add(flashSprite);
		Slide.tween(flashSprite).to({alpha: 0}, duration).ease(Quad.easeOut).start();
	}

	public function changeScene(scene:InteractiveScene, dispose:Bool = true) {
		Main.ME.setScene(scene, true);
		if (dispose) {
			MusicBeatState.scenesToUpdate.remove(this);
		}
	}
}