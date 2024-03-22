import h2d.Tile;
import h2d.Bitmap;

class Stage extends Bitmap {
    public function new(x:Float, y:Float, tile:Tile) {
        super();
        this.x = x;
        this.y = y;
        this.tile = tile;
    }
}