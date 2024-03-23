import hxd.File;
import hxd.fs.BytesFileSystem.BytesFileEntry;
import hxd.Window;
import hxd.Key;
import hxd.res.Sound;
import hxd.Res;
import h2d.Camera;
import backend.*;

class PlayState extends MusicBeatState {
    private var camera:Camera;

    public static var offsetCharacter:String = "BOYFRIEND";

    private var boyfriend:Character;
    private var opponent:Character;
    private var bg:Stage;

    var playerStrumGrp:Array<Strumline>;
    var opponentStrumGrp:Array<Strumline>;

    var sound:Sound;

    var timer:Int;

    override function init() {
        super.init();

        Conductor.bpm = 100;
        Conductor.songPosition = 0;

        sound = new Sound(new BytesFileEntry("res/music/bop.ogg", File.getBytes("res/music/bop.ogg")));
        // sound = Res.music.freakyMenu;
        sound.stop();
        sound.play(true);

        s2d.defaultSmooth = true;

        bg = new Stage(0, 0, Res.images.week1.stageback.toTile());
        s2d.addChild(bg);

        boyfriend = new Character(0, 0, Res.BOYFRIEND_png.toTile(), "BOYFRIEND");
        boyfriend.setPosition(Window.getInstance().width / 2 - boyfriend.getSize().width / 2 + 300, Window.getInstance().height / 2 - boyfriend.getSize().height / 2 + 100);
        s2d.addChild(boyfriend);

        opponent = new Character(0, 0, Res.DADDY_DEAREST_png.toTile(), "DADDY_DEAREST");
        opponent.setPosition(Window.getInstance().width / 2 - opponent.getSize().width / 2 - 300, Window.getInstance().height / 2 - opponent.getSize().height / 2);
        s2d.addChild(opponent);

        trace(Conductor.stepCrochet);

        playerStrumGrp = new Array<Strumline>();
        opponentStrumGrp = new Array<Strumline>();

        for (i in 0...4) {
            var playerStrums = new Strumline(0, 100, Res.shared.images.NOTE_assets_png.toTile(), "NOTE_assets", i);
            playerStrums.x = Window.getInstance().width / 2 - playerStrums.animArray[i][0].width * 1.5 + playerStrums.animArray[i][0].width * i;
            playerStrums.x += 300;
            playerStrumGrp.push(playerStrums);
        }
        for (i in playerStrumGrp) {
            s2d.addChild(i);
        }

        for (i in 0...4) {
            var opponentStrums = new Strumline(0, 100, Res.shared.images.NOTE_assets_png.toTile(), "NOTE_assets", i);
            opponentStrums.x = Window.getInstance().width / 2 - opponentStrums.animArray[i][0].width * 1.5 + opponentStrums.animArray[i][0].width * i;
            opponentStrums.x -= 300;
            opponentStrumGrp.push(opponentStrums);
        }
        for (i in opponentStrumGrp) {
            s2d.addChild(i);
        }

    }

    override function update(dt:Float) {
        super.update(dt);

		if (Key.isPressed(Key.NUMPAD_SUB) || Key.isPressed((Key.QWERTY_MINUS)))
		    Main.managerMasterVolume(-0.1);
		else if (Key.isPressed(Key.NUMPAD_ADD))
			Main.managerMasterVolume(0.1);

        if (Key.isPressed(Key.LEFT)) {
            noteHit(playerStrumGrp, 0);
            }
        if (Key.isPressed(Key.DOWN)) {
            noteHit(playerStrumGrp, 1);
            }
        if (Key.isPressed(Key.UP)) {
            noteHit(playerStrumGrp, 2);
            }
        if (Key.isPressed(Key.RIGHT)) {
            noteHit(playerStrumGrp, 3);
            }

        if (Key.isPressed(Key.A)) {
            noteHit(opponentStrumGrp, 0);
            }
        if (Key.isPressed(Key.S)) {
            noteHit(opponentStrumGrp, 1);
            }
        if (Key.isPressed(Key.W)) {
            noteHit(opponentStrumGrp, 2);
            }
        if (Key.isPressed(Key.D)) {
            noteHit(opponentStrumGrp, 3);
            }
        if (Key.isPressed(Key.SPACE)) {
            offsetCharacter = "BOYFRIEND";
            new OffsetEditor();
        }
    }

    function noteHit(strum:Array<Strumline>, ?goodHit:Bool, note:Int) {
        if (strum == playerStrumGrp) {
            strum[note].playStrumAnim(note);
            boyfriend.playAnim(note + 1); // we add one here, because note 0 for boyfriend.playAnim() is his idle, so we offset by one
        }
        else {
            strum[note].playStrumAnim(note);
            opponent.playAnim(note + 1);
        }
    }

    override function beatHit() {
        boyfriend.playAnim(0);
        opponent.playAnim(0);
    }
}