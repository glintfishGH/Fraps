import hxd.Window;
import hxd.Key;
import hxd.Res;
import Character;
import backend.*;

class TitleState extends MusicBeatState {
    override function init() {
        var gfSpeakers:Character = new Character(0, 0, Paths.image("characters/gfDanceTitle"), "res/characters/gfDanceTitle");
        gfSpeakers.animation.loop = true;
        s2d.addChild(gfSpeakers);

        trace(gfSpeakers.x, gfSpeakers.y, gfSpeakers.getSize().width, gfSpeakers.getSize().height);

        screenCenter(gfSpeakers);
    }

    override function update(dt:Float) {
        if (Key.isPressed(Key.SPACE))
            new TestState();
    }
}