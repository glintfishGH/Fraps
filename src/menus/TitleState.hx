package menus;

import objects.Note;
import hxd.res.DefaultFont;
import h2d.Text;
import haxe.Timer;
import slide.Slide;
import objects.AnimatedSprite;
import h2d.Bitmap;
import hxd.snd.Channel;
import backend.*;

class TitleState extends MusicBeatState {
    public static var song:Channel;

    var speakers:AnimatedSprite;
    var logo:AnimatedSprite;
    var enterText:AnimatedSprite;
    var entered:Bool = false;

    var bg:Bitmap;
    public function new() {
        super();

        song = Paths.music("sereneLoop");
        song.loop = true;
        song.pause = false;
        
        attachedSong = song;

        Conductor.changeBPM(88);

        Main.ME.engine.backgroundColor = 0xFF00FF22;

        bg = new Bitmap(Paths.image("menus/titleBG"));
        addObj(bg);

        logo = new AnimatedSprite(0, 0, Paths.image("menus/logoBumpin"));
        logo.animation.loop = false;
        logo.addAnimation("bump", "logo bumpin", null, true);
        addObj(logo);

        speakers = new AnimatedSprite(375, 85, Paths.image("menus/titleDance"));
        speakers.animation.loop = false;
        speakers.addAnimation("bop", "boppy", null, true);
        addObj(speakers);

        enterText = new AnimatedSprite(112.5, 590, Paths.image("menus/titleEnter"));
        enterText.animation.loop = true;
        enterText.addAnimation("loop", "Press Enter to Begin", null, true);
        enterText.addAnimation("enter", "ENTER PRESSED");
        addObj(enterText);
    }

    override function beatHit() {
        super.beatHit();
        logo.playAnimation("bump");
        speakers.playAnimation("bop");
    }

    override function update(dt:Float) {
        super.update(dt);
        Slide.step(dt);
        if (controls.keyPressed("accept") && !entered) {
            entered = true;
            GLGU.playSound("confirmMenu");
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