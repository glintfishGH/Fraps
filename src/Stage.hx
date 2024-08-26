import objects.Sprite;
import h2d.Tile;

/**
 * Most basic class. Loads a bitmap of an image.
 * This can realistically be used for whatever since it has no logic in it, but we'll ignore that for now.
 */
class Stage extends Sprite {
    public function new(x:Float, y:Float, tile:Tile) {
        super(x, y, tile);
    }
}