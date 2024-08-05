import hxd.snd.SoundGroup;
import hl.Gc;
import hxd.System;
import sys.Http;
import h2d.Text;
import hxd.File;
import hxd.fs.BytesFileSystem.BytesFileEntry;
import hxd.Window;
import hxd.Key;
import hxd.res.Sound;
import hxd.Res;
import h2d.Camera;
import backend.*;

class PlayState extends MusicBeatState {

    // DEBUG
    public static var offsetCharacter:String = "BOYFRIEND";
    public static var curSong:String = "bopeebo";

    // SOUNDS
    public static var inst:Sound;
    public static var vocals:Sound;

    private var boyfriend:Character;
    private var opponent:Character;
    private var bg:Stage;

    var playerStrumGroup:Array<Strumline> = [];
    var opponentStrumGroup:Array<Strumline> = [];

    override function init() {
        super.init();
        trace(Paths.image(""));

        Conductor.bpm = 100;
        Conductor.songPosition = 0;

        loadSong();

        s2d.defaultSmooth = true;

        bg = new Stage(0, 0, Res.images.week1.stageback.toTile());
        s2d.addChild(bg);

        boyfriend = new Character(0, 0, Res.characters.BOYFRIEND_png.toTile(), "BOYFRIEND");
        boyfriend.setPosition(Window.getInstance().width / 2 - boyfriend.getSize().width / 2 + 300, Window.getInstance().height / 2 - boyfriend.getSize().height / 2 + 100);
        s2d.addChild(boyfriend);

        opponent = new Character(0, 0, Res.characters.DADDY_DEAREST_png.toTile(), "DADDY_DEAREST");
        opponent.setPosition(Window.getInstance().width / 2 - opponent.getSize().width / 2 - 300, Window.getInstance().height / 2 - opponent.getSize().height / 2);
        s2d.addChild(opponent);

        trace(Conductor.stepCrochet);

        for (i in 0...4) {
            var playerStrums = new Strumline(0, 100, Res.shared.images.NOTE_assets_png.toTile(), "NOTE_assets", i);
            playerStrums.x = Window.getInstance().width / 2 - playerStrums.animArray[i][0].width * 1.5 + playerStrums.animArray[i][0].width * i;
            playerStrums.x += 300;
            playerStrumGroup.push(playerStrums);
        }
        for (i in playerStrumGroup) {
            s2d.addChild(i);
        }

        for (i in 0...4) {
            var opponentStrums = new Strumline(0, 100, Res.shared.images.NOTE_assets_png.toTile(), "NOTE_assets", i);
            opponentStrums.x = Window.getInstance().width / 2 - opponentStrums.animArray[i][0].width * 1.5 + opponentStrums.animArray[i][0].width * i;
            opponentStrums.x -= 300;
            opponentStrumGroup.push(opponentStrums);
        }
        for (i in opponentStrumGroup) {
            s2d.addChild(i);
        }

    }

    override function update(dt:Float) {
        super.update(dt);

        if (Key.isPressed(Key.LEFT)) {
            noteHit(playerStrumGroup, 1);
            }
        if (Key.isPressed(Key.DOWN)) {
            noteHit(playerStrumGroup, 2);
            }
        if (Key.isPressed(Key.UP)) {
            noteHit(playerStrumGroup, 3);
            }
        if (Key.isPressed(Key.RIGHT)) {
            noteHit(playerStrumGroup, 4);
            }

        if (Key.isPressed(Key.A)) {
            noteHit(opponentStrumGroup, 1);
            }
        if (Key.isPressed(Key.S)) {
            noteHit(opponentStrumGroup, 2);
            }
        if (Key.isPressed(Key.W)) {
            noteHit(opponentStrumGroup, 3);
            }
        if (Key.isPressed(Key.D)) {
            noteHit(opponentStrumGroup, 4);
            }
        if (Key.isPressed(Key.SPACE)) {
            new OffsetEditor();
        }
    }

    /**
     * TODO: Separate the strum animation player from the characters.
     */
    function noteHit(strum:Array<Strumline>, ?goodHit:Bool, note:Int) {
        strum[note - 1].playStrumAnim(note - 1);
        strum == playerStrumGroup ? boyfriend.playAnim(note) : opponent.playAnim(note);
    }

    override function beatHit() {
        boyfriend.dance();
        opponent.dance();
    }

    function loadSong(?path:String) {
        inst = new Sound(new BytesFileEntry("res/songs/" + curSong + "/inst.ogg", File.getBytes("res/songs/" + curSong + "/inst.ogg")));
        inst.play();

        vocals = new Sound(new BytesFileEntry("res/songs/" + curSong + "/voices.ogg", File.getBytes("res/songs/" + curSong + "/voices.ogg")));
        vocals.play();
    }
}