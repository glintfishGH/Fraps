package backend;

import haxe.Timer;
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

enum Style {
	IN;
	OUT;
}

class MusicBeatState extends Scene {
	public static var objectsToUpdate:Array<FNFObject> = [];
	public static var scenesToUpdate:Array<MusicBeatState> = [];

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var curSection:Int = 0;
	private var oldStep:Float;

	var timeOffset:Float = 0;
	var stepOffset:Float = 0;


	public var attachedSong:Channel;

	public static var windowInstance:Window = Window.getInstance();
	var flashSprite:Bitmap;
	var transitionSprite:Bitmap;

	public function new() {
		super();
		flashSprite = new Bitmap(Tile.fromColor(0xFFFFFFFF, window.width, window.height, 1));
		transitionSprite = new Bitmap(Tile.fromColor(0xFF000000, window.width, -window.height - 500, 1));
		trace("Opened new scene.");
	}

	public function update(dt:Float) {
        Slide.step(dt);
		if (attachedSong != null)
			Conductor.songPosition = attachedSong.position * 1000;

		oldStep = curStep;

		updateStep();

		if (oldStep != curStep) {
			stepHit();
		}
	}

	override function addChild(s:Object) {
		super.addChild(s);
		// objectsToUpdate.push(s);
	}

	override function onAdd() {
		super.onAdd();
		GLogger.success("Added scene " + Type.getClassName(Type.getClass(this)).split('.').pop());

		scaleMode = ScaleMode.Stretch(1280, 720);
        defaultSmooth = true;

		scenesToUpdate.push(this);
	}

	@:noCompletion
	function updateStep() {
		// trace(Conductor.songPosition, Conductor.stepCrochet);
		curStep = Math.floor(Conductor.songPosition / Conductor.stepCrochet * 4) - Std.int(Conductor.curStepOffset);

		curBeat = Math.floor(curStep / 4);
		curSection = Math.floor(curBeat / 4);
	}

	function stepHit() {
		if (curStep % 4 == 0)
			beatHit();
	}

	function beatHit() {
        if (curBeat % 4 == 0) 
			sectionHit();
	}

	function sectionHit() {
	}

	function screenCenter(object:Object, axis:Axis = XY) {
		if (axis == X) {
			object.x = (window.width - object.getSize().width) / 2;
		}
		else if (axis == Y)
			object.y = (window.height - object.getSize().height) / 2;
		else {
			object.x = (window.width - object.getSize().width) / 2;
			object.y = (window.height - object.getSize().height) / 2;
		}
	}

	function flash(duration:Float, ?ease:EaseFunc) {
		ease ?? Quart.easeInOut;
		add(flashSprite);
		Slide.tween(flashSprite).to({alpha: 0}, duration).ease(Quad.easeOut).start();
	}


	public function changeScene(scene:InteractiveScene, transition:Bool = false, dispose:Bool = true) {
		if (transition) {
			doTransition(OUT, function() {
				Main.ME.setScene(scene, true);
				dispose ? MusicBeatState.scenesToUpdate.remove(this) : trace("Did not dispose scene.");
			});
		}
		else {
			Main.ME.setScene(scene, true);
			dispose ? MusicBeatState.scenesToUpdate.remove(this) : trace("Did not dispose scene.");
		}
	}

	@:noCompletion
	private function doTransition(style:Style, duration:Float = 2, onComplete:Void->Void) {
		// transitionSprite.y = 600;
		Slide.tween(transitionSprite).to({y: windowInstance.height}, duration).ease(Quad.easeOut).onComplete(onComplete).start();
	}
}