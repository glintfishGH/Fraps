import hxd.res.Sound;
import hxd.snd.Manager;
import hxd.Res;

class Main extends hxd.App {
	public static var loadTime:Float = 0;

	var sound:Sound;

	public static var manager:Manager;
	static function main() {
		Res.initEmbed();
		manager = Manager.get();
        manager.masterVolume = 0.5;
		new PlayState();
	}

	override public function update(dt:Float) {
		super.update(dt);
	}
	
	public static function managerMasterVolume(volumeChange:Float) {
		manager.masterVolume += volumeChange;
		if (manager.masterVolume + volumeChange <= 0) {
			manager.masterVolume = 0;
		}
		else if (manager.masterVolume + volumeChange > 1) {
			manager.masterVolume = 1;
		}
	}
}