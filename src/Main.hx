import glibs.GLogger;
import backend.MusicBeatState;
import hxd.Window;
import hxd.Key;
import hxd.snd.Manager;
import hxd.Res;
import hxd.App;

class Main extends App {
	/**
	 * Sound manager object. Controls global volume.
	 */
	public static var soundManager:Manager;

	/**
	 * The current Main instance.
	 */
	public static var ME:Main;

	static function main() {
		Res.initEmbed();

		// Initializes the sound manager
		soundManager = Manager.get();
        soundManager.masterVolume = 0.5;

		// Run init
		new Main();
	}

	override function init() {
		super.init();
		trace("Running first init");

		ME = this;

		// Reroute the trace function to use GLogger.
		// Log.trace = function(v:Dynamic, ?infos:haxe.PosInfos) 
		// 	GLogger.general(v);

		/**
		 * FIXME: This checks if the key is down, not if it's been pressed.
		 */
		Window.getInstance().addEventTarget(function (event) {
			if (event.keyCode == Key.NUMPAD_SUB) {
				trace("decreasing volume");
				managerMasterVolume(-0.1);
			}
			if (event.keyCode == Key.NUMPAD_ADD) {
				trace("increasing volume");
				managerMasterVolume(0.1);
			}
		});
		// Window.getInstance().vsync = false;

		setScene(new Cache());
	}

	override function update(dt:Float) {
		super.update(dt);
		for (scene in MusicBeatState.scenesToUpdate) scene.update(dt);
		for (object in MusicBeatState.objectsToUpdate) object.update(dt);
	}

	override function onResize() {
		super.onResize();
		
		// Make sure windowInstance is up-to-date when resizing
		MusicBeatState.windowInstance = Window.getInstance();
	}

	override function onContextLost() {
		trace("lost context");
		super.onContextLost();
	}
	
	/**
	 * Change the global volume.
	 * @param volumeChange Amount to change the volume (0-1)
	 */
	static function managerMasterVolume(volumeChange:Float) {
		GLogger.info("Changed master volume by " + volumeChange);
		soundManager.masterVolume += volumeChange;
		if (soundManager.masterVolume <= 0) {
			soundManager.masterVolume = 0;
		}
		if (soundManager.masterVolume >= 1) {
			soundManager.masterVolume = 1;
		}
	}
}