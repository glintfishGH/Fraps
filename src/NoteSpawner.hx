import Note.NoteDir;
import h2d.Object;

/**
 * TODO: Move functions related to note spawning from PlayState to here.
 */
class NoteSpawner extends Object {

    public function new(attachedStrum:Strumnote) {
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