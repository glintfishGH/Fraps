import Note.NoteDir;
import h2d.Object;

/**
 * TODO: Move functions related to note spawning from PlayState to here.
 */
class NoteSpawner extends Object {
    public var attachedStrum:Strumnote;

    public function new(attachedStrum:Strumnote) {
        super();
        this.attachedStrum = attachedStrum;
        this.x = attachedStrum.x;
    }

    public function spawnNote(noteDir:NoteDir, time:Float) {
        var note = new Note(noteDir, time);
        note.parentSpawner = this;
        note.x = attachedStrum.x;
        PlayState.instance.addChild(note);
        PlayState.instance.noteGroup.push(note);
    }
}