package objects;

import objects.SustainNote;
import objects.Note.NoteDir;
import h2d.Object;

/**
 * TODO: Move functions related to note spawning from PlayState to here.
 * ^ Maybe don't do this? So this object can be used outside of PlayState and be given custom logic.
 */
class NoteSpawner extends Object {
    /**
     * The strumnote this spawner spawns notes for.
     */
    public var attachedStrum:Strumnote;

    /**
     * When spawning a note, this value is used for the notes scrollspeed
     */
    public var scrollSpeed:Float;

    /**
     * When spawning a note, this value is used for the notes ID.
     */
    public var ID:Int;

    public function new(attachedStrum:Strumnote) {
        super();
        this.attachedStrum = attachedStrum;
        this.x = attachedStrum.x;
    }

    /**
     * TODO: Change this so it doesn't rely on PlayState.
     */
    public function spawnNote(noteDirection:NoteDir, time:Float, ?length:Int = 0) {
        var note = new Note(noteDirection, time, length);
        note.parentSpawner = this;
        note.ID = this.ID;
        note.scrollSpeed = this.scrollSpeed;

        // Make sure the spawned note has the same x position as the strum its being spawned for
        note.x = attachedStrum.x; 

        // Make sure the note has the same scale as the attached strum 
        note.setScale(attachedStrum.scaleX);
        PlayState.ME.add(note, Layers.layerUI);
        PlayState.ME.noteGroup.push(note);
    }

    public function spawnSustain(time:Float, length:Int) {
        var sustainNote:SustainNote = new SustainNote(LEFT, time, length);
        PlayState.ME.addChild(sustainNote);
    }
}