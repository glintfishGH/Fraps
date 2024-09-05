import sys.FileSystem;
import glibs.GLogger;
import hxd.res.DefaultFont;
import h2d.Text;
import slide.easing.Expo;
import slide.Slide;
import glibs.GLGU;
import h2d.Camera;
import objects.Note;
import objects.Note.NoteDir;
import hxd.Key;
import backend.*;
import hxd.snd.Channel;
import hxd.Window;
import objects.NoteSpawner;

class PlayState extends MusicBeatState {
    // OUT OF STATE
    static var songExists:Bool = false;
    static var chartExists:Bool = false;
    static var validChart:Bool = false;

    // DEBUG
    public static var offsetCharacter:String = "girlfriend";
    public static var curSong:String = "bopeebo";
    var needToUpdateStep:Bool = false;

    // SONG
    public static var inst:Channel;
    public static var vocals:Channel;
    public static var vocals2:Channel;
    public static var chart:Dynamic;
    public static var chartMetadata:Dynamic;
    var chartNoteData:Array<Array<SongInfo.NoteData>> = [];
    var chartEventData:Array<Array<SongInfo.Events>> = [];

    var sectionLength:Float = 2000;
    var scrollSpeed:Float = 1.3;

    // CHARACTERS
    private var player:Character;
    private var girlfriend:Character;
    private var opponent:Character;

    // STRUMS
    var strumX:Float = 42;
    var strumY:Float = 50;
    var noteDirs = ["Left", "Down", "Up", "Right"];
    public var playerStrumGroup:Array<Strumnote> = [];
    public var opponentStrumGroup:Array<Strumnote> = [];

    // NOTES
    var maxNotes:Int = 75;
    var noteSpawnerGroup:Array<NoteSpawner> = [];
    public var noteGroup:Array<Note> = [];

    public static var ME:PlayState;

    var wall:Stage;
    var curtains:Stage;
    var floor:Stage;

    var camGame:Camera = new Camera();
    var camHUD:Camera = new Camera();

    var debugText:Text;

    public var downscroll:Bool = true;

    public function new() {
        super();
        ME = this;

        loadSong();

        camera.layerVisible = (layer) -> layer == Layers.layerNul;

        camHUD.layerVisible = (layer) -> layer == Layers.layerUI;
        camGame.layerVisible = (layer) -> layer == Layers.layerGame;
        addCamera(camGame);
        addCamera(camHUD);

        camGame.setAnchor(0.5, 0.5);
        camGame.setScale(0.8, 0.8);

        debugText = new Text(DefaultFont.get());
        debugText.setScale(5);

        chart = Paths.parseChart(curSong);
        chartMetadata = Paths.parseMetadata(curSong);
        trace(chartMetadata);

        wall = new Stage(0, 0, Paths.image("week1/wall"));
        // addObj(wall);

        floor = new Stage(0, 1020, Paths.image("week1/floor"));
        addObj(floor);

        girlfriend = new Character(1000, 400, Paths.image("characters/girlfriend"));
        addObj(girlfriend);

        player = new Character(1555, 800, Paths.image("characters/BOYFRIEND"));
        addObj(player);

        opponent = new Character(705, 415, Paths.image("characters/DADDY_DEAREST"));
        addObj(opponent);

        curtains = new Stage(0, 0, Paths.image("week1/curtains"));
        curtains.setScrollFactor(2, 2);
        // addObj(curtains);

        if (downscroll) strumY = Window.getInstance().height - 150;

        for (i in 0...4) {
            var opponentStrum = new Strumnote(0, strumY, noteDirs[i]);
            opponentStrum.x += 160 * 0.7 * i;
            opponentStrum.x += 50;
            opponentStrumGroup.push(opponentStrum);
            addObj(opponentStrumGroup[i], Layers.layerUI);

            var noteSpawner:NoteSpawner = new NoteSpawner(opponentStrum);
            noteSpawner.ID = i;
            noteSpawner.scrollSpeed = 2.3;
            noteSpawnerGroup.push(noteSpawner);
        }

        for (i in 0...4) {
            var playerStrum = new Strumnote(0, strumY, noteDirs[i]);
            playerStrum.x += 160 * 0.7 * i;
            playerStrum.x += 50 + Window.getInstance().width / 2;
            playerStrumGroup.push(playerStrum);
            addObj(playerStrumGroup[i], Layers.layerUI);

            var noteSpawner:NoteSpawner = new NoteSpawner(playerStrum);
            noteSpawner.ID = i + 4;
            noteSpawner.scrollSpeed = 3;
            noteSpawnerGroup.push(noteSpawner);
        }
    
        for (i => noteSpawner in noteSpawnerGroup) {
            add(noteSpawner, Layers.layerUI);
        }

        GLGU.startStamp("Starting note generation. . .");
        Conductor.changeBPM(chartMetadata.timeChanges[0].bpm);
        
        var noteCorrection:Array<Int> = [4, 5, 6, 7, 0, 1, 2, 3];

        for (i in 0...chart.notes.normal.length) {
            /**
             * Current section we're parsing.
             */
            var curSection:Dynamic = chart.notes.normal[i];

            var noteDataArray:Array<SongInfo.NoteData> = [];
            
            var noteTime:Dynamic = curSection.t;
            var noteStrum:Dynamic = noteCorrection[curSection.d]; // great format
            var noteSustainLength:Dynamic = curSection.l;

            noteDataArray.push({time: noteTime, strum: noteStrum, sustainLength: noteSustainLength});
            chartNoteData.push(noteDataArray);
        }

        // trace(chart.events.length);

        for (i in 0...chart.events.length) {
            var curEvent:Dynamic = chart.events[i];
            if (curEvent.e == "FocusCamera") {
                var eventArray:Array<SongInfo.Events> = [];

                var time:Float = curEvent.t;
                // var event:String = curEvent.e;
    
                var duration:Float = curEvent.v.duration;
                var character:Int = curEvent.v.char;
    
                eventArray.push({duration: duration, character: character, time: time});
                chartEventData.push(eventArray);
            }
            // trace(chartEventData);
        }

        /**
         * Sort `chartNoteData` by note time.
         * This makes note generation smooth.
         */
        chartNoteData.sort((array1, array2) -> Std.int(array1[0].time - array2[0].time));

        trace(Conductor.bpm);

        GLGU.endStamp();

        camGame.x = wall.getSize().width / 2;
        camGame.y = wall.getSize().height / 2;

        // add(debugText, Layers.layerUI);
    }

    function endSong() {
        camera.layerVisible = (layer) -> layer == Layers.layerGame;
        changeScene(new MainMenuState());
    }

    override function update(dt:Float) {
        super.update(dt);

        if (Conductor.songPosition == inst.duration * 1000) {
            endSong();
        }

        for (key in noteDirs) {
            if (controls.keyPressed(key.toLowerCase())) {

                /**
                 * FIXME: This code only gets run when theres at least one note that exists. 
                 *        This has the side-effect of making the strums not play their miss animation at the start of high erect.
                */
                for (note in noteGroup) {
                    if (note.time - Conductor.songPosition >= -300 
                        && note.time - Conductor.songPosition < 150
                        && note.noteDirection == "note" + GLGU.capitalize(key) 
                        && note.parentSpawner.ID > 3) {
                            charPlayAnim(player, key.toLowerCase());
                            noteHit(playerStrumGroup, GLGU.capitalize(note.getPureDirection()), true); 
                            noteGroup.remove(note);
                            note.remove();
                            break;
                    }
                    else {
                        noteHit(playerStrumGroup, GLGU.capitalize(key), false);
                    }
                }
                charPlayAnim(player, key.toLowerCase());
            }
        }

        debugText.text = 'curStep: $curStep\ncurBeat: $curBeat\ncurSection: $curSection\ngoodStepOffset: ${Conductor.curStepOffset}';

        if (Key.isDown(Key.Q)) {
            camHUD.setScale(camHUD.scaleX - 0.01, camHUD.scaleY - 0.01);
        }
        if (Key.isDown(Key.E)) {
            camHUD.setScale(camHUD.scaleX + 0.01, camHUD.scaleY + 0.01);
        }

        if (chartNoteData.length != 0) {
            // Check if the note is off screen, then spawn it. Prevents the notes from spawning too early and having them clip into existence.
            if (chartNoteData[0][0].time - camHUD.y - (camHUD.viewportHeight / camHUD.scaleY) <= Conductor.songPosition && noteGroup.length <= maxNotes) {
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
                var sustainLength:Int = noteToSpawn.sustainLength;
    
                if (noteSpawnerGroup[spawnerToTarget] != null) noteSpawnerGroup[spawnerToTarget].spawnNote(noteDir, noteTime, sustainLength);

                chartNoteData.remove(chartNoteData[0]);
            }
            // else {
            //     var lastNote:Note = noteGroup.pop();
            //     chartNoteData.push([{time: lastNote.time, strum: lastNote.ID, sustainLength: lastNote.length}]);
            //     trace("removed note?");
            //     chartNoteData.sort((array1, array2) -> Std.int(array1[0].time - array2[0].time));
            // }
        }

        if (chartEventData.length != 0) {
            if (chartEventData[0][0].time <= Conductor.songPosition) {
                trace("moving camera");
                trace(chartEventData[0][0].time, Conductor.songPosition);
                moveCamera();
                chartEventData.remove(chartEventData[0]);
            }
        }

        handleInputs();
        moveNotes(dt);
    }

    override function stepHit() {
        super.stepHit();
        if (curStep % 8 == 0) {
            player.dance();
            opponent.dance();
        }
    }

    override function beatHit() {
        super.beatHit();
    }

    override function sectionHit() {
        super.sectionHit();
        resyncVocals();
    }
    
    function noteHit(strums:Array<Strumnote>, direction:String, ?goodHit:Bool) {
        for (strum in strums) {
            if (strum.noteToDisplay == direction) strum.playStrumAnim(GLGU.capitalize(direction), goodHit);
        }
    }

    function charPlayAnim(char:Character, animToPlay:String) {
        char.playAnimation(animToPlay);
    }

    function moveCamera() {
        if (chartEventData.length != 0) {
            var cameraTarget:Character;
            cameraTarget = switch(chartEventData[0][0].character) {
                case 0:
                    player;
                case 1:
                    opponent;
                case 2:
                    girlfriend;
                case _:
                    player; // Why is this needed?
            };

            Slide.stop(camGame);
            Slide.tween(camGame)
            .to({x: cameraTarget.x + cameraTarget.getSize().width / 2, y: cameraTarget.y + cameraTarget.getSize().height / 2}, chartEventData[0][0].duration)
            .ease(Expo.easeOut)
            .start();
        }
    }

    function loadSong() {
        inst = Paths.song(curSong + "/inst".toLowerCase());
        inst.position = -5000;
        inst.pause = false;

        vocals = Paths.song(curSong + "/voices-opp".toLowerCase());
        vocals.position = inst.position;
        vocals.pause = false;

        vocals2 = Paths.song(curSong + "/voices-boy".toLowerCase());
        vocals2.position = inst.position;
        vocals2.pause = false;

        attachedSong = inst;
    }

    function generateStrum(character:Character) {
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
        /**
         * Pauses the song.
         */
        if (controls.keyPressed("back")) {
            inst.pause = !inst.pause;
            vocals.pause = !vocals.pause;
            vocals2.pause = !vocals2.pause;
            Conductor.songPosition = inst.position * 1000;
        }
    }

    function moveNotes(?dt:Float) {
        for (note in noteGroup) {
            var notePos:Float = (note.time - Conductor.songPosition) * 0.45 * note.scrollSpeed;
            note.y = note.parentSpawner.attachedStrum.y;
            note.y += (!downscroll) ? notePos : -notePos;
            note.x = note.parentSpawner.attachedStrum.x;

            if (Conductor.songPosition >= note.time && note.ID < 4) {
                noteGroup.remove(note);
                note.remove();

                charPlayAnim(opponent, note.getPureDirection().toLowerCase());
                noteHit(opponentStrumGroup, GLGU.capitalize(note.getPureDirection()), true);
            }

            if (note.time < Conductor.songPosition - 200) {
                noteGroup.remove(note);
                note.remove();
            }
        }
    }

    public static function assetCheck():Bool {
        if (FileSystem.exists(Paths.songCheck(curSong + "/inst".toLowerCase())) &&
            FileSystem.exists(Paths.songCheck(curSong + "/voices-boy".toLowerCase()))) {
                songExists = true;
        }

        if (Paths.parseChart(curSong) != null) chartExists = true;

        chart = Paths.parseChart(curSong);

        if (chart.version == "2.0.0" && chart.notes.nightmare.length != 0) validChart = true;

        if (songExists && chartExists && validChart)
            return true;

        GLogger.error('Asset check failed\nSong - $songExists\nChart - $chartExists\nValidChart - $validChart');
        return false;
    }
}