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
        note.x = this.x - 75;
        PlayState.instance.s2d.addChild(note);
        PlayState.instance.noteGroup.push(note);
    }
}