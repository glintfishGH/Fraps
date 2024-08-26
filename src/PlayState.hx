import glibs.GLogger;
import hxd.Res;
import hxd.clipper.Rect;
import h2d.col.Collider;
import glibs.GLDebugTools;
import hxd.res.DefaultFont;
import h2d.Text;
import hxd.Math;
import slide.easing.Expo;
import slide.Slide;
import glibs.GLGU;
import h2d.Camera;
import Note.NoteDir;
import haxe.Json;
import hxd.Key;
import backend.*;
import hxd.snd.Channel;
import hxd.Window;

class PlayState extends MusicBeatState {

    // DEBUG
    public static var offsetCharacter:String = "girlfriend";
    public static var curSong:String = "bopeebo";
    var needToUpdateStep:Bool = false;

    // SONG
    public static var inst:Channel;
    public static var vocals:Channel;
    public var chart:Dynamic;
    var chartNoteData:Array<Array<SongInfo.NoteData>> = [];
    var chartSectionData:Array<SongInfo.SectionData> = [];

    var sectionLength:Float = 2000;
    var scrollSpeed:Float = 1.3;

    // CHARACTERS
    private var boyfriend:Character;
    private var girlfriend:Character;
    private var opponent:Character;

    // STRUMS
    var noteDirs = ["Left", "Down", "Up", "Right"];
    public var playerStrumGroup:Array<Strumnote> = [];
    public var opponentStrumGroup:Array<Strumnote> = [];

    // NOTES
    var noteSpawnerGroup:Array<NoteSpawner> = [];
    public var noteGroup:Array<Note> = [];

    public static var instance:PlayState;

    var wall:Stage;
    var curtains:Stage;
    var floor:Stage;

    var camGame:Camera;
    var camHUD:Camera;

    var debugText:Text;

    var trueStep:Int;

    public function new() {
        super();
        instance = this;

        loadSong();

        camera.setAnchor(0.5, 0.5);
        camera.setScale(0.8, 0.8);

        debugText = new Text(DefaultFont.get());
        debugText.setScale(5);

        chart = Json.parse(sys.io.File.getContent("res/songs/" + curSong + "/chart.json".toLowerCase()));

        wall = new Stage(0, 0, Paths.image("images/week1/wall"));
        addChild(wall);

        floor = new Stage(0, 1020, Paths.image("images/week1/floor"));
        addChild(floor);

        // girlfriend = new Character(0, 0, Paths.image("characters/girlfriend"), "res/characters/girlfriend");
        // girlfriend.playAnimation("bopLeft");
        // addChild(girlfriend);

        boyfriend = new Character(1555, 800, Paths.image("characters/BOYFRIEND"), "res/characters/BOYFRIEND");
        addChild(boyfriend);

        opponent = new Character(705, 415, Paths.image("characters/DADDY_DEAREST"), "res/characters/DADDY_DEAREST");
        addChild(opponent);

        curtains = new Stage(0, 0, Paths.image("images/week1/curtains"));
        curtains.setScrollFactor(2, 2);
        addChild(curtains);

        for (i in 0...4) {
            var opponentStrum = new Strumnote(0, 0, Paths.image("images/gameplay/NOTE_assets"), "res/images/gameplay/NOTE_assets", noteDirs[i]);
            var strumWidth = opponentStrum.animations.get("staticLeft")[0].width;
            opponentStrum.x = Window.getInstance().width / 2 - strumWidth * 1.5 + strumWidth * i;
            opponentStrum.x -= 410.5;
            opponentStrumGroup.push(opponentStrum);
            addChild(opponentStrumGroup[i]);

            var noteSpawner:NoteSpawner = new NoteSpawner(opponentStrum);
            noteSpawnerGroup.push(noteSpawner);
        }

        for (i in 0...4) {
            var playerStrum = new Strumnote(0, 0, Paths.image("images/gameplay/NOTE_assets"), "res/images/gameplay/NOTE_assets", noteDirs[i]);
            // playerStrum.setScrollFactor(2, 2);
            var strumWidth = playerStrum.animations.get("staticLeft")[0].width;
            playerStrum.x = Window.getInstance().width / 2 - strumWidth * 1.5 + strumWidth * i;
            playerStrum.x += 260;
            playerStrumGroup.push(playerStrum);
            addChild(playerStrumGroup[i]);

            var noteSpawner:NoteSpawner = new NoteSpawner(playerStrum);
            noteSpawnerGroup.push(noteSpawner);
        }
    
        for (noteSpawner in noteSpawnerGroup) {
            addChild(noteSpawner);
        }

        GLGU.startStamp("Starting note generation. . .");
        Conductor.changeBPM(chart.song.bpm);

        for (i in 0...chart.song.notes.length) {
            /**
             * Current section we're parsing.
             */
            var curSection:Dynamic = chart.song.notes[i];

            /**
             * Pass in data from `curSection` into a sectionData that we'll push to `chartSectionData`.
             * We don't pass in the notes because those have to be handled differently.
             */
            var sectionData:SongInfo.SectionData = {
                lengthInSteps: curSection.lengthInSteps,
                bpm: curSection.bpm,
                mustHitSection: curSection.mustHitSection,
                changeBPM: curSection.changeBPM,
                altAnim: curSection.altAnim
            };

            chartSectionData.push(sectionData);

            /**
             * Parse the sectionNotes in `curSection`
             */
            for (i in 0...curSection.sectionNotes.length) {
                /**
                 * Indicates [note.time, note.strum, note.sustainLength]
                 */
                var notesArray = curSection.sectionNotes[i];

                /**
                 * The array we'll be pushing to `chartNoteData`.
                 */
                var noteDataArray:Array<SongInfo.NoteData> = [];
           
                /**
                 * Gets the time, strum and sustainLength of the currently parsed note.
                 */
                var noteTime:Dynamic = notesArray[0];
                var noteStrum:Dynamic = notesArray[1];
                var noteSustainLength:Dynamic = notesArray[2];

                if (sectionData.mustHitSection) noteStrum += 4;

                noteDataArray.push({time: noteTime, strum: noteStrum, sustainLength: noteSustainLength});
                chartNoteData.push(noteDataArray);
            }
        }

        /**
         * Sort `chartNoteData` by note time.
         * This makes note generation smooth.
         */
        chartNoteData.sort((array1, array2) -> Std.int(array1[0].time - array2[0].time));
        // trace(chartNoteData);

        GLGU.endStamp();
        scrollSpeed = chart.song.speed * 1.35;

        camera.x = wall.getSize().width / 2;
        camera.y = wall.getSize().height / 2;

        moveCamera();

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

        addChild(debugText);
    }

    override function update(dt:Float) {
        super.update(dt);
        Slide.step(dt);

        boyfriend.update(dt);
        opponent.update(dt);

        for (strum in opponentStrumGroup) {
            strum.update(dt);
        }

        debugText.text = 'curStep: $curStep\ntrueStep: $trueStep\ncurBeat: $curBeat\ncurSection: $curSection\ngoodStepOffset: ${Conductor.curStepOffset}';

        if (Key.isDown(Key.Q)) {
            camera.setScale(camera.scaleX - 0.01, camera.scaleY - 0.01);
        }
        if (Key.isDown(Key.E)) {
            camera.setScale(camera.scaleX + 0.01, camera.scaleY + 0.01);
        }

        if (Key.isDown(Key.A)) {
            camera.x -= 10;
        }
        if (Key.isDown(Key.D)) {
            camera.x += 10;
        }
        if (Key.isDown(Key.W)) {
            camera.y -= 10;
        }
        if (Key.isDown(Key.S)) {
            camera.y += 10;
        }

        // if (Key.isDown(Key.LEFT)) {
        //     curtains.offsetX -= 10;
        // }
        // if (Key.isDown(Key.RIGHT)) {
        //     curtains.offsetX += 10;
        // }
        // if (Key.isDown(Key.UP)) {
        //     curtains.offsetY -= 10;
        // }
        // if (Key.isDown(Key.DOWN)) {
        //     curtains.offsetY += 10;
        // }

        curtains.update(dt);
        // trace(dt);

        // trace("Song progression: " + Conductor.songPosition / inst.duration / 1000);

        // trace(curSection, chartSectionData[curSection].sectionNotes);

        if (chartNoteData.length != 0) {
            if (chartNoteData[0][0].time - camera.y - (camera.viewportHeight / camera.scaleY) <= Conductor.songPosition) {
                var noteDir:NoteDir = LEFT;
                var noteToSpawn = chartNoteData[0][0];
    
                switch(noteToSpawn.strum) {
                    case 0 | 4:
                        noteDir = LEFT;
                    case 1 | 5:
                        noteDir = DOWN;
                    case 2 | 6:
                        noteDir = UP;
                    case 3 | 7:
                        noteDir = RIGHT;
                }
                
                var spawnerToTarget:Int = noteToSpawn.strum;
                var noteTime:Float = noteToSpawn.time;
    
                // trace(noteSpawnerGroup[spawnerToTarget], spawnerToTarget, noteDir, noteTime);
                if (noteSpawnerGroup[spawnerToTarget] != null)
                    noteSpawnerGroup[spawnerToTarget].spawnNote(noteDir, noteTime);
                chartNoteData.remove(chartNoteData[0]);
            }
        }

        handleInputs();
        moveNotes();
    }
    
    function noteHit(strum:Array<Strumnote>, direction:String, note:Int, ?goodHit:Bool) {
        strum[note].playStrumAnim(direction, goodHit);
        // strum == playerStrumGroup ? boyfriend.playAnim(note) : opponent.playAnim(note);
    }

    function charPlayAnim(char:Character, animToPlay:String) {
        // char.playingAnim = true;
        char.playAnimation(animToPlay);
    }

    override function beatHit() {
        super.beatHit();
    }

    override function sectionHit() {
        super.sectionHit();
        chartSectionData.remove(chartSectionData[0]);
        boyfriend.dance();
        opponent.dance();
        moveCamera();
        resyncVocals();
    }

    function moveCamera() {
        if (chartSectionData.length != 0) {
            var cameraTarget:Character = (chartSectionData[0].mustHitSection) ? boyfriend : opponent;

            Slide.tween(camera)
            .to({x: cameraTarget.x + cameraTarget.getSize().width / 2, y: cameraTarget.y + cameraTarget.getSize().height / 2}, 1.9)
            .ease(Expo.easeOut)
            .start();
        }
    }

    override function stepHit() {
        trueStep++;
        // trace(curStep, trueStep);

        super.stepHit();
    }

    function loadSong(?path:String) {
        inst = Paths.song("songs/" + curSong + "/inst".toLowerCase());
        inst.position = 0;
        inst.pause = false;

        vocals = Paths.song("songs/" + curSong + "/voices".toLowerCase());
        vocals.position = 0;
        vocals.pause = false;

        attachedSong = inst;
    }

    function generateStrums(character:Character) {
        // var strumGroup:Array<Strumnote> = [];

        // var characterStrum:Strumnote = new Strumnote(0, 0, Paths.image("images/gameplay/NOTE_assets"), "res/images/gameplay/NOTE_assets");
        // var strumWidth = characterStrum.animations.get("staticLeft")[0].width;


        // for (i in 0...4) {
        //     characterStrum.x = windowInstance.width / 2 - strumWidth * 1.5 + strumWidth * i;
        //     (character == opponent) ? characterStrum.x -= 410.5 : characterStrum.x += 260;

        //     characterStrum.noteToDisplay = i;
        //     strumGroup.push(characterStrum);

        //     var noteSpawner:NoteSpawner = new NoteSpawner(characterStrum);
        //     noteSpawnerGroup.push(noteSpawner);
        // }

        // character == opponent ? opponentStrumGroup = strumGroup : playerStrumGroup = strumGroup;
    }

    function resyncVocals() {
        // vocals.position = inst.position;
    }

    function handleInputs() {
        if (Key.isPressed(Key.LEFT)) {
            charPlayAnim(boyfriend, "left");
            noteHit(playerStrumGroup, "Left", 0);            
        }
        if (Key.isPressed(Key.DOWN)) {
            charPlayAnim(boyfriend, "down");
            noteHit(playerStrumGroup, "Down", 1);
        }
        if (Key.isPressed(Key.UP)) {
            charPlayAnim(boyfriend, "up");
            noteHit(playerStrumGroup, "Up", 2);
        }

        if (Key.isPressed(Key.RIGHT)) {
            charPlayAnim(boyfriend, "right");
            noteHit(playerStrumGroup, "Right", 3);            
        }

        if (Key.isPressed(Key.SPACE)) {
            inst.stop();
            inst.position = 0;
            vocals.stop();
            vocals.position = 0;
            changeScene(new PlayState());
        }
    }

    function moveNotes() {
        for (note in noteGroup) {
            note.y = note.parentSpawner.attachedStrum.y + (note.time - Conductor.songPosition) * 0.45 * scrollSpeed /*+ vocals.position * 1000 - note.time*/;
            note.x = note.parentSpawner.attachedStrum.x;

            if (Conductor.songPosition - note.time >= note.parentSpawner.attachedStrum.y) {
                noteGroup.remove(note);
                note.remove();

                // trace("hit note at time " + note.time, Conductor.songPosition);
                
                if (note.parentSpawner == noteSpawnerGroup[0]) {
                    charPlayAnim(opponent, "left");
                    noteHit(opponentStrumGroup, "Left", 0, true);
                }
                if (note.parentSpawner == noteSpawnerGroup[1]) {
                    charPlayAnim(opponent, "down");
                    noteHit(opponentStrumGroup, "Down", 1, true);
                }
                if (note.parentSpawner == noteSpawnerGroup[2]) {
                    charPlayAnim(opponent, "up");
                    noteHit(opponentStrumGroup, "Up", 2, true);
                }
                if (note.parentSpawner == noteSpawnerGroup[3]) {
                    charPlayAnim(opponent, "right");
                    noteHit(opponentStrumGroup, "Right", 3, true);
                }
                
                // vocals.position = note.time / 1000;
                // inst.position = note.time / 1000;

                // These should all be the same
                // trace(note.time + (vocals.position * 1000 - note.time), Std.int(vocals.position * 1000), Std.int(inst.position * 1000));
            }

            if (note.y < note.parentSpawner.attachedStrum.y - 500) {
                noteGroup.remove(note);
                note.remove();
            }
        }
    }
}
