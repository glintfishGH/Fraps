import Note.NoteDir;
import h2d.Object;

/**
 * TODO: This doesn't function as it should... Too bad!
 */
class NoteSpawner extends Object {

    public function new(attachedStrum:Strumline) {
        super();
        this.x = attachedStrum.x;
        this.y = 500;
    }

    public function spawnNote(noteDir:NoteDir, time:Float) {
        var note = new Note(noteDir, time);
        note.parentSpawner = this;
        note.x = this.x;
        PlayState.instance.addChild(note);
        PlayState.instance.noteGroup.push(note);
    }
}