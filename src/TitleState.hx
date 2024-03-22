import sys.io.File;
import hxd.res.Sound;
import hxd.Window;
import hxd.fs.BytesFileSystem.BytesFileEntry;
import hxd.Key;
import hxd.Res;
import Character;
import backend.*;

class TitleState extends MusicBeatState {
    var sound:Sound;
    override function init() {
        var gfSpeakers:Character = new Character(0, 0, Res.gfDanceTitle_png.toTile(), "gfDanceTitle");
        gfSpeakers.setPosition(Window.getInstance().width / 2 - gfSpeakers.getSize().width / 2, Window.getInstance().height / 2 - gfSpeakers.getSize().height / 2);
        gfSpeakers.animation.loop = true;
        s2d.addChild(gfSpeakers);

    }

    override function update(dt:Float) {
        if (Key.isPressed(Key.SPACE))
            new PlayState();
    }
}