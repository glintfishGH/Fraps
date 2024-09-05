package objects;

import objects.Note.NoteDir;
import h2d.Tile;
import h2d.Bitmap;

class SustainNote extends Bitmap {
    var time:Float;
    var length:Int;
    public function new(note:NoteDir, time:Float, length:Int) {
        super();
        this.time = time;
        this.y = time;
        this.length = length;

        this.tile = GLGU.makeTile(0, time, 20, length, 0xFFFFFFFF);
    }
}