package menus;

import haxe.Timer;
import hxd.res.Sound;
import slide.Slide;
import glibs.GLDebugTools;
import objects.AnimatedSprite;
import h2d.Bitmap;
import hxd.snd.Channel;
import hxd.Key;
import backend.*;

class TitleState extends MusicBeatState {
    public static var song:Channel;

    var speakers:AnimatedSprite;
    var logo:AnimatedSprite;
    var enterText:AnimatedSprite;

    var bg:Bitmap;
    var confirm:Sound;
    public function new() {
        super();

        song = Paths.song("music/sereneLoop");
        song.loop = true;
        song.pause = false;
        
        attachedSong = song;

        confirm = Paths.sound("sounds/confirmMenu");

        Conductor.changeBPM(88);

        bg = new Bitmap(Paths.image("images/menus/titleBG"));
        addChild(bg);

        logo = new AnimatedSprite(0, 0, Paths.image("images/menus/logoBumpin"), "res/images/menus/logoBumpin");
        logo.animation.loop = false;
        logo.addAnimation("bump", "logo bumpin", null, true);
        addChild(logo);

        speakers = new AnimatedSprite(375, 85, Paths.image("images/menus/titleDance"), "res/images/menus/titleDance");
        speakers.animation.loop = false;
        speakers.addAnimation("bop", "boppy", null, true);
        addChild(speakers);

        enterText = new AnimatedSprite(112.5, 590, Paths.image("images/menus/titleEnter"), "res/images/menus/titleEnter");
        enterText.animation.loop = true;
        enterText.addAnimation("loop", "Press Enter to Begin", null, true);
        enterText.addAnimation("enter", "ENTER PRESSED");
        addChild(enterText);
    }

    override function beatHit() {
        super.beatHit();
        logo.playAnimation("bump");
        speakers.playAnimation("bop");
    }

    override function update(dt:Float) {
        super.update(dt);
        Slide.step(dt);
        if (Key.isPressed(Key.ENTER)) {
            confirm.play();
            enterText.playAnimation("enter");
            enterText.setPosition(119.5, 596);
            flash(3);
            var timer:Timer = new Timer(2000);
            timer.run = () -> {
                changeScene(new MainMenuState());
                timer.stop();
            };
        }
    }
}