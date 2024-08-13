import hxd.Res;
import h2d.Tile;
import h2d.Bitmap;

enum abstract NoteDir(String) from String to String {
    var LEFT =  "noteLeft";
    var DOWN =  "noteDown";
    var UP =    "noteUp";
    var RIGHT = "noteRight";
}

class Note extends Bitmap {
    public var time:Float;
    public var parentSpawner:NoteSpawner;
    public function new(note:NoteDir, time:Float) {
        super();
        this.time = time;
        loadNote(note);
        this.y = time;
    }

    private function loadNote(note:NoteDir) {
        tile = Res.load("images/gameplay/" + note + ".png").toImage().toTile();
    }
}