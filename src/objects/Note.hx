package objects;

import h2d.SpriteBatch;
import h2d.TileGroup;
import objects.SustainNote;
import objects.Sprite;
import hxd.Res;
import h2d.Tile;
import h2d.Bitmap;

enum abstract NoteDir(String) from String to String {
    var LEFT =  "noteLeft";
    var DOWN =  "noteDown";
    var UP =    "noteUp";
    var RIGHT = "noteRight";
}

/**
 * A pressable note object.
 */
class Note extends SpriteBatch {
    /**
     * Direction of this note.
     */
    public var noteDirection:NoteDir;

    /**
     * This notes scroll speed.
     */
    public var scrollSpeed:Float;

    /**
     * This notes ID. Used for checking if the player should be able to press a note.
     */
    public var ID:Int;
    
    public var time:Float;
    public var length:Int;

    public var note:Bitmap;
    public var sustain:SustainNote;
    public var downscroll:Bool = true;

    public var batchNote:BatchElement;
    public var batchSustain:BatchElement;


    /**
     * The note spawner that spawned this note.
     */
    public var parentSpawner:NoteSpawner;
    public function new(noteDirection:NoteDir, time:Float, length:Int) {
        this.time = time;
        this.noteDirection = noteDirection;
        this.length = length;
        this.y = time;
        loadNote(noteDirection);
        super(note.tile);
    }

    private function loadNote(noteDirection:NoteDir) {
        note = new Bitmap(Paths.image("gameplay/" + noteDirection, true));
        if (length != 0) {
            var sustainNote:SustainNote = new SustainNote(noteDirection, time, length);
            var sustainYPos:Float;

            if (this.downscroll) sustainYPos = note.y + note.getSize().height / 2 - sustainNote.getSize().height;
            else sustainYPos = note.y + note.getSize().height / 2; 

            batchSustain = alloc(sustainNote.tile);
            batchSustain.x = (note.getSize().width - sustainNote.getSize().width ) / 2;
            batchSustain.y = sustainYPos;
            add(batchSustain);
        }
        batchNote = alloc(note.tile);
        add(batchNote);
    }

    /**
     * Returns the note direction along with the "note" prefix ("noteLeft", "noteDown", "noteUp", "noteRight")
     */
    public function getNoteDir():String {
        return Std.string(this.noteDirection);
    }

    /**
     * Returns ONLY the direction of the note as a string ("Left", "Down", "Up", "Right")
     */
    public function getPureDirection():String {
        return Std.string(this.noteDirection).substring(4, Std.string(this.noteDirection).length);
    }
}