import glibs.GLDebugTools;
import Note.NoteDir;
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
    public static var offsetCharacter:String = "DADDY_DEAREST";
    public static var curSong:String = "bopeebo";

    // SOUNDS
    public static var inst:Channel;
    public static var vocals:Channel;
    public var chart:Dynamic;

    private var boyfriend:Character;
    private var opponent:Character;
    private var bg:Stage;

    public var playerStrumGroup:Array<Strumline> = [];
    public var opponentStrumGroup:Array<Strumline> = [];

    var noteSpawnerGroup:Array<NoteSpawner> = [];
    public var noteGroup:Array<Note> = [];

    var noteTimeData:Array<Array<Dynamic>> = [];

    var scrollSpeed:Float = 1.3;

    public static var instance:PlayState;

    var needToUpdateStep:Bool = false;

    override function init() {
        super.init();
        instance = this;

        loadSong();

        Conductor.changeBPM(120);

        bg = new Stage(0, 0, Res.images.week1.stageback.toTile());
        s2d.addChild(bg);

        chart = Json.parse(sys.io.File.getContent("res/songs/" + curSong + "/chart.json"));

        boyfriend = new Character(0, 0, Paths.image("characters/BOYFRIEND"), "res/characters/BOYFRIEND");
        screenCenter(boyfriend, XY);
        s2d.addChild(boyfriend);

        opponent = new Character(0, 0, Paths.image("characters/DADDY_DEAREST"), "res/characters/DADDY_DEAREST");
        opponent.setPosition(Window.getInstance().width / 2 - opponent.getSize().width / 2 - 300, Window.getInstance().height / 2 - opponent.getSize().height / 2);
        s2d.addChild(opponent);
        
        for (i in 0...4) {
            var opponentStrum = new Strumline(0, 0, Paths.image("images/gameplay/NOTE_assets"), "res/images/gameplay/NOTE_assets", i);
            var strumWidth = opponentStrum.animations.get("staticLeft")[0].width;
            opponentStrum.x = Window.getInstance().width / 2 - strumWidth * 1.5 + strumWidth * i;
            opponentStrum.x -= 410.5;
            opponentStrumGroup.push(opponentStrum);
            s2d.add(opponentStrumGroup[i]);

            var noteSpawner:NoteSpawner = new NoteSpawner(opponentStrum);
            noteSpawnerGroup.push(noteSpawner);
        }

        for (i in 0...4) {
            var playerStrum = new Strumline(0, 0, Paths.image("images/gameplay/NOTE_assets"), "res/images/gameplay/NOTE_assets", i);
            var strumWidth = playerStrum.animations.get("staticLeft")[0].width;
            playerStrum.x = Window.getInstance().width / 2 - strumWidth * 1.5 + strumWidth * i;
            playerStrum.x += 260;
            playerStrumGroup.push(playerStrum);
            s2d.add(playerStrumGroup[i]);

            var noteSpawner:NoteSpawner = new NoteSpawner(playerStrum);
            noteSpawnerGroup.push(noteSpawner);
        }
    
        for (noteSpawner in noteSpawnerGroup) {
            trace(noteSpawner.x);
            s2d.addChild(noteSpawner);
        }

        /**
         * sectionData referrs to sections of the chart with this structure:
         * {sectionNotes : [[375,3,250,],[750,3,375,],[0,2,0,]], lengthInSteps : 16, bpm : 0, mustHitSection : false}
         * 
         * first we have to iterate over all of those to get the section notes.
         */
        for (i in 0...chart.song.notes.length) {
            // Easier to write.
            var sectionData = chart.song.notes[i];

            for (i in 0...sectionData.sectionNotes.length) {
                /**
                 * noteData refers to the notes in sectionNotes.
                 * [time, strum, sustainLength]
                 * time - noteData[0]
                 * strum - noteData[1]
                 * sustainLength - noteData[2]
                 */ 

                var noteData = sectionData.sectionNotes[i];
                noteTimeData.push(noteData);

                /**
                 * Most of this codebase refers to FPS Plus and how it works.
                 * Since FPS Plus uses the legacy chart format, it comes with its kinks.
                 * If only one side has notes in a section, it'll use strums 0, 1, 2 and 3 for both the opponent and player
                 * but if its a mustHitSection, it'll ues 4, 5, 6 and 7?
                 * This is dumb.
                 */

                var noteDir:NoteDir = LEFT;

                switch(noteData[1]) {
                    case 0 | 4:
                        noteDir = LEFT;
                    case 1 | 5:
                        noteDir = DOWN;
                    case 2 | 6:
                        noteDir = UP;
                    case 3 | 7:
                        noteDir = RIGHT;
                }
                /**
                 * "this will definitely come and bite me in the ass later" -Glint
                 */
                if (sectionData.mustHitSection && noteData[1] <= 3) {
                    noteSpawnerGroup[noteData[1] + 4].spawnNote(noteDir, noteData[0]);
                }
                else noteSpawnerGroup[noteData[1]].spawnNote(noteDir, noteData[0]);
            }
        }
        scrollSpeed = chart.song.speed * 1.35;

        // Ass code but it works for now
        // All this does it make the notes appear when spawned, since they dont play their animation instantly
        noteHit(playerStrumGroup, "Left", 0);
        noteHit(playerStrumGroup, "Down", 1);
        noteHit(playerStrumGroup, "Up", 2);
        noteHit(playerStrumGroup, "Right", 3);
        noteHit(opponentStrumGroup, "Left", 0);
        noteHit(opponentStrumGroup, "Down", 1);
        noteHit(opponentStrumGroup, "Up", 2);
        noteHit(opponentStrumGroup, "Right", 3);

    }

    override function update(dt:Float) {
        super.update(dt);

        if (Key.isPressed(Key.LEFT)) {
            newNoteHit(boyfriend, "left");
            noteHit(playerStrumGroup, "Left", 0);            
            }
        if (Key.isPressed(Key.DOWN)) {
            newNoteHit(boyfriend, "down");
            noteHit(playerStrumGroup, "Down", 1);
            }
        if (Key.isPressed(Key.UP)) {
            newNoteHit(boyfriend, "up");
            noteHit(playerStrumGroup, "Up", 2);            

            // noteHit(playerStrumGroup, 3);
            }
        if (Key.isPressed(Key.RIGHT)) {
            newNoteHit(boyfriend, "right");
            noteHit(playerStrumGroup, "Right", 3);            
            // noteHit(playerStrumGroup, 4);
            }

        if (Key.isPressed(Key.A)) {
            newNoteHit(opponent, "left");
            noteHit(opponentStrumGroup, "Left", 0);
            }
        if (Key.isPressed(Key.S)) {
            newNoteHit(opponent, "down");
            noteHit(opponentStrumGroup, "Down", 1);
            }
        if (Key.isPressed(Key.W)) {
            newNoteHit(opponent, "up");
            noteHit(opponentStrumGroup, "Up", 2);

            // noteHit(opponentStrumGroup, 3);
            }
        if (Key.isPressed(Key.D)) {
            newNoteHit(opponent, "right");
            noteHit(opponentStrumGroup, "Right", 3);

            // noteHit(opponentStrumGroup, 4);
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

                if (note.parentSpawner == noteSpawnerGroup[0]) 
                        newNoteHit(opponent, "left");
                if (note.parentSpawner == noteSpawnerGroup[1])
                        newNoteHit(opponent, "down");
                if (note.parentSpawner == noteSpawnerGroup[2]) 
                        newNoteHit(opponent, "up");
                if (note.parentSpawner == noteSpawnerGroup[3])
                        newNoteHit(opponent, "right");

                if (note.parentSpawner == noteSpawnerGroup[4])
                        newNoteHit(boyfriend, "left");
                if (note.parentSpawner == noteSpawnerGroup[5]) 
                        newNoteHit(boyfriend, "down");
                if (note.parentSpawner == noteSpawnerGroup[6])
                        newNoteHit(boyfriend, "up");
                if (note.parentSpawner == noteSpawnerGroup[7])
                        newNoteHit(boyfriend, "right");
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
    function noteHit(strum:Array<Strumline>, direction:String, note:Int, ?goodHit:Bool) {
        strum[note].playStrumAnim(direction, goodHit);
        // strum == playerStrumGroup ? boyfriend.playAnim(note) : opponent.playAnim(note);
    }

    function newNoteHit(char:Character, animToPlay:String) {
        // char.playingAnim = true;
        char.playAnimation(animToPlay);
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

        attachedSong = inst;
    }
}