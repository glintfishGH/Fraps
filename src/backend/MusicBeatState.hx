package backend;

import h2d.Camera;
import hxd.res.DefaultFont;
import h2d.Text;
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

enum Axis {
	X;
	Y;
	XY;
}

enum Style {
	IN;
	OUT;
}

/**
 * `Scene` class with extra functionality. Extend this instead of `Scene`.
 * Also contains helper functions
 */
class MusicBeatState extends Scene {
	/**
	 * Array of objects the game should update.
	 * Updating is done in `Main`.
	 */
	public static var objectsToUpdate:Array<FNFObject> = [];

	/**
	 * Array of MusicBeatStates the game has to update.
	 * Updating is done in `Main`.
	 */
	public static var scenesToUpdate:Array<MusicBeatState> = [];

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var curSection:Int = 0;
	private var oldStep:Float;

	var controls:Controls;

	var timeOffset:Float = 0;
	var stepOffset:Float = 0;

	/**
	 * Song the Conductor should use to calculate songPosition.
	 */
	public var attachedSong:Channel;

	public static var windowInstance:Window = Window.getInstance();
	var flashSprite:Bitmap;
	var transitionSprite:Bitmap;

	var topLayerCamera:Camera = new Camera();
    var fps:Text;

	public function new() {
		super();
		objectsToUpdate = [];
		controls = new Controls();
		flashSprite = new Bitmap(Tile.fromColor(0xFFFFFFFF, window.width, window.height, 1));
		transitionSprite = new Bitmap(Tile.fromColor(0xFF000000, window.width, -window.height - 500, 1));

		topLayerCamera.layerVisible = (layer) -> layer == Layers.layerTop;

		fps = new Text(DefaultFont.get());
        fps.scale(2);
        addObj(fps, Layers.layerTop);
		
		trace("Opened new scene.");
	}

	public function update(dt:Float) {
        Slide.step(dt);	
		fps.text = "FPS: " + Main.ME.engine.fps + 
				"\nMEMORY: " + Std.int(Main.ME.engine.mem.stats().totalMemory / 1048576) + "MBs" +
				"\nTEXTURES: " + Main.ME.engine.mem.stats().textureCount +
				"\nOBJECTS: " + objectsToUpdate.length + 
				"\nOBJECTS IN CACHE: " + Lambda.count(Paths.graphicCache);
		if (attachedSong != null)
			Conductor.songPosition = attachedSong.position * 1000;

		oldStep = curStep;

		updateStep();

		if (oldStep != curStep) {
			stepHit();
		}
	}

	override function onAdd() {
		super.onAdd();
		GLogger.success("Added scene " + Type.getClassName(Type.getClass(this)).split('.').pop());

		scaleMode = ScaleMode.Stretch(1280, 720);
        defaultSmooth = true;

		scenesToUpdate.push(this);
		addCamera(topLayerCamera, Layers.layerTop);
	}

	override function add(s:Object, layer:Int = -1, index:Int = -1) {
		GLogger.warning("Use addObj!");
		super.add(s, layer, index);
	}

	override function addChild(s:Object) {
		GLogger.warning("Use addObj!");
		super.addChild(s);
	}

	/**
	 * Adds an object to a specific layer. 
	 * By default this layer is `Layers.layerGame`.
	 * @param object The object to add.
	 * @param layer This objects layer.
	 */
	function addObj(object:Object, ?layer:Int) {
		if (layer == null) add(object, Layers.layerGame);
		else add(object, layer);
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

	// Should maybe remove this?
	function sectionHit() {
	}

	/**
	 * Set an objects position to the center of the screen.
	 * @param object Object to target
	 * @param axis Axis on which to 
	 */
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

	/**
	 * Flashes the screen.
	 * @param duration Duration of the flash. (Inconsistent?)
	 * @param ease Ease out style. (Doesn't do anything)
	 */
	function flash(duration:Float, ?ease:EaseFunc) {
		ease ?? Quart.easeInOut;
		addObj(flashSprite, Layers.layerTransition);
		Slide.tween(flashSprite).to({alpha: 0}, duration).ease(Quad.easeOut).start();
	}

	/**
	 * Change the current scene. Automatically disposes of the assets of the last scene.
	 * Also removes all the objects in `objectsToUpdate` and removes `this` instance from `scenesToUpdate`
	 * @param scene Which scene to transition to. (new PlayState());
	 * @param transition Should do transition animation? (Unused)
	 * @param dispose Dipose of the scene?
	 */
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