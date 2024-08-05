import h2d.Tile;
import h2d.Bitmap;

/**
 * Most basic class. Loads a bitmap of an image.
 * This can realistically be used for whatever since it has no logic in it, but we'll ignore that for now.
 */
class Stage extends Bitmap {
    public function new(x:Float, y:Float, tile:Tile) {
        super();
        this.x = x;
        this.y = y;
        this.tile = tile;
    }
}