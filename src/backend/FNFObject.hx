package backend;

import h2d.Object;
import h2d.Tile;
import h2d.Bitmap;

/**
 * An object that allows for automatic updating.
 */
class FNFObject extends Bitmap {
    public function new(?tile:Tile, ?parent:Object) {
        super(tile, parent);
        MusicBeatState.objectsToUpdate.push(this);
    }
    public function update(dt:Float) { }
}