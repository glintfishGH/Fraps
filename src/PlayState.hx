import sys.thread.Thread;
import haxe.Timer;
import h3d.scene.Mesh;
import haxe.Json;
import h3d.prim.Cube;
import hxd.Key;
import hxd.res.Sound;
import hxd.Res;
import backend.*;
import hxd.snd.Channel;
import hxd.Window;

class PlayState extends MusicBeatState {

    // DEBUG
    public static var offsetCharacter:String = "BOYFRIEND";
    public static var curSong:String = "bopeebo";

    // SOUNDS
    public static var inst:Channel;
    public static var vocals:Channel;

    private var boyfriend:Character;
    private var opponent:Character;
    private var bg:Stage;

    public var playerStrumGroup:Array<Strumline> = [];
    public var opponentStrumGroup:Array<Strumline> = [];

    var noteSpawnerGroup:Array<NoteSpawner> = [];
    public var noteGroup:Array<Note> = [];

    var scrollSpeed:Float = 1.3;

    public static var instance:PlayState;

    var needToUpdateStep:Bool = false;

    override function init() {
        super.init();
        instance = this;

        loadSong();

        Conductor.changeBPM(95);

        bg = new Stage(0, 0, Res.images.week1.stageback.toTile());
        s2d.addChild(bg);

        boyfriend = new Character(0, 0, Paths.image("characters/BOYFRIEND"), "res/characters/BOYFRIEND");
        screenCenter(boyfriend, XY);
        s2d.addChild(boyfriend);

        opponent = new Character(0, 0, Paths.image("characters/DADDY_DEAREST"), "res/characters/DADDY_DEAREST");
        opponent.setPosition(Window.getInstance().width / 2 - opponent.getSize().width / 2 - 300, Window.getInstance().height / 2 - opponent.getSize().height / 2);
        s2d.addChild(opponent);

        scrollSpeed = 1.3;
        
        for (i in 0...4) {
            var opponentStrum = new Strumline(0, 100, Paths.image("shared/images/NOTE_assets"), "NOTE_assets", i);
            opponentStrum.x = Window.getInstance().width / 2 - opponentStrum.animArray[i][0].width * 1.5 + opponentStrum.animArray[i][0].width * i;
            opponentStrum.x -= 300;
            opponentStrumGroup.push(opponentStrum);

            var noteSpawner:NoteSpawner = new NoteSpawner(opponentStrum);
            noteSpawnerGroup.push(noteSpawner);
        }
        for (strum in opponentStrumGroup) {
            s2d.addChild(strum);
        }

        for (i in 0...4) {
            var playerStrum = new Strumline(0, 100, Paths.image("shared/images/NOTE_assets"), "NOTE_assets", i);
            playerStrum.x = Window.getInstance().width / 2 - playerStrum.animArray[i][0].width * 1.5 + playerStrum.animArray[i][0].width * i;
            playerStrum.x += 300;
            playerStrumGroup.push(playerStrum);
            s2d.add(playerStrum);

            var noteSpawner:NoteSpawner = new NoteSpawner(playerStrum);
            noteSpawnerGroup.push(noteSpawner);
        }
        // for (strum in playerStrumGroup) {
        //     s2d.addChild(strum);
        // }
    
        for (noteSpawner in noteSpawnerGroup)
            s2d.addChild(noteSpawner);


        // These were tested on base game bopeebo
        // Keyword TESTED
        // noteSpawnerGroup[2].spawnNote(UP,    0);
        // noteSpawnerGroup[3].spawnNote(RIGHT, 600);
        // noteSpawnerGroup[3].spawnNote(RIGHT, 1200);

        // noteSpawnerGroup[6].spawnNote(UP,    2400);
        // noteSpawnerGroup[7].spawnNote(RIGHT, 3000);
        // noteSpawnerGroup[7].spawnNote(RIGHT, 3600);

        // noteSpawnerGroup[1].spawnNote(DOWN,    4800);
        // noteSpawnerGroup[0].spawnNote(LEFT, 5400);
        // noteSpawnerGroup[3].spawnNote(RIGHT, 6000);

        // noteSpawnerGroup[5].spawnNote(DOWN,    7200);
        // noteSpawnerGroup[4].spawnNote(LEFT, 7800);
        // noteSpawnerGroup[7].spawnNote(RIGHT, 8400);
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
            inst.stop();
            inst.position = 0;
            vocals.stop();
            vocals.position = 0;
            new OffsetEditor();
        }


        for (note in noteGroup) {
            note.y = (note.time - Conductor.songPosition) * 0.45 * scrollSpeed;
            if (Conductor.songPosition - note.time >= 0.0) {
                noteGroup.remove(note);
                note.remove();
            }
            if (note.y < -500) {
                noteGroup.remove(note);
                note.remove();
            }
        }
    }
    
    /**
     * FIXME: This just doesn't work. Will rework this later down the line anyways.
     */
    function noteHit(strum:Array<Strumline>, ?goodHit:Bool, note:Int) {
        strum[note - 1].playStrumAnim(note - 1);
        // strum == playerStrumGroup ? boyfriend.playAnim(note) : opponent.playAnim(note);
    }

    override function beatHit() {
        super.beatHit();
        boyfriend.dance();
        opponent.dance();
    }

    override function stepHit() {
        if (needToUpdateStep) {
            /**
             * referrs to the misaligned step when changing bpms
             * ie. 
             * Conductor.changeBPM(Conductor.bpm * 2);
             * curStep goes from 7 to like 15 i forget how much it is exactly
             */
             
            var badStep:Float = curStep + 1;

            /**
             * The multiplier of the bpm change.
             */
            var bpmChangeMult:Float = Conductor.bpm / Conductor.lastBpm;

            /**
             * The amount of steps required to take away from `badStep` to get to the correct curStep.
             */
            var goodStepOffset = Std.int(badStep / bpmChangeMult);
            Conductor.curStepOffset = badStep - goodStepOffset;
            needToUpdateStep = false;
        }
        super.stepHit();
    }

    function loadSong(?path:String) {
        inst = Paths.song("songs/" + curSong + "/inst");
        inst.position = 0;
        inst.pause = false;

        vocals = Paths.song("songs/" + curSong + "/voices");
        vocals.position = 0;
        vocals.pause = false;
    }
}