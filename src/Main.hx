import hxd.res.DefaultFont;
import h2d.Text;
import h2d.Scene;
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

		// Calls init().
		new Main();

		Window.getInstance().addEventTarget(function (event) {
			if (event.keyCode == Key.NUMPAD_SUB) {
				managerMasterVolume(-0.1);
			}
			else if (event.keyCode == Key.NUMPAD_ADD) {
				managerMasterVolume(0.1);
			}
		});
	}

	override function init() {
		super.init();
		trace("ran first init");
		ME = this;

		setScene(new TitleState());
		
		// ME.s2d.scaleMode = ScaleMode.AutoZoom(Window.getInstance().width, Window.getInstance().height);
		// s2d.x = (Window.getInstance().width - s2d.width) / 2; 
        // ME.s2d.defaultSmooth = true;
	}

	override function update(dt:Float) {
		super.update(dt);
		for (scene in MusicBeatState.scenesToUpdate) {
			scene.update(dt);
		}
		// MusicBeatState.update();
	}
	
	/**
	 * Change the global volume. 
	 * TODO: Fix an issue where the volume change occurs twice. Seems to not be related to this though?
	 * FIXME: Whatever you put into the volumeChange argument, it'll get divided by 2 to alleviate this issue^
	 * @param volumeChange Amount to change the volume (0-1)
	 */
	static function managerMasterVolume(volumeChange:Float) {
		soundManager.masterVolume += volumeChange / 2;
		if (soundManager.masterVolume <= 0) {
			soundManager.masterVolume = 0;
		}
		else if (soundManager.masterVolume >= 1) {
			soundManager.masterVolume = 1;
		}
		trace(soundManager.masterVolume);
	}
}