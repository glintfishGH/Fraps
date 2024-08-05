import hxd.Window;
import hxd.Key;
import hxd.snd.Manager;
import hxd.Res;

class Main extends hxd.App {
	/**
	 * Sound manager object. Controls global volume.
	 */
	public static var soundManager:Manager;

	static function main() {
		Res.initEmbed();

		// Initializes the sound manager
		soundManager = Manager.get();
        soundManager.masterVolume = 0.5;

		new TitleState();

		/**
		 * Note that `new TitleState()` HAS to be called before adding event listeners.
		 * Otherwise, the game crashes.
		**/ 
		Window.getInstance().addEventTarget(function (event) {
			if (event.keyCode == Key.NUMPAD_SUB) {
				managerMasterVolume(-0.1);
			}
			else if (event.keyCode == Key.NUMPAD_ADD) {
				managerMasterVolume(0.1);
			}
		});
	}
	
	/**
	 * Change the global volume. 
	 * TODO: Fix an issue where the volume change occurs twice. Seems to not be related to this though?
	 * @param volumeChange Amount to change the volume (0-1)
	 */
	static function managerMasterVolume(volumeChange:Float) {
		soundManager.masterVolume += volumeChange;
		if (soundManager.masterVolume + volumeChange <= 0) {
			soundManager.masterVolume = 0;
		}
		else if (soundManager.masterVolume + volumeChange > 1) {
			soundManager.masterVolume = 1;
		}
		trace(soundManager.masterVolume);
	}
}