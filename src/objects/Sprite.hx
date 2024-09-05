package objects;

import h2d.Tile;
import h2d.Bitmap;

/**
 * In testing. Extend FNFObject instead.
 */
class Sprite extends Bitmap {
    public var offsetX:Float;
    public var offsetY:Float;

    public var scrollFactorX:Float = 1;
    public var scrollFactorY:Float = 1; 

    public function new(x:Float, y:Float, tile:Tile) {
        super();
        offsetX = x;
        offsetY = y;

        setPosition(offsetX, offsetY);
        this.tile = tile;
    }

    public function setScrollFactor(x:Float, y:Float) {
        this.scrollFactorX = x;
        this.scrollFactorY = y;
    }

    public function update(dt:Float) {
        this.x = offsetX + hxd.Math.lerpTime(Main.ME.s2d.camera.x, Main.ME.s2d.camera.viewportWidth, scrollFactorX, dt);
        this.y = offsetY + hxd.Math.lerpTime(Main.ME.s2d.camera.y, Main.ME.s2d.camera.viewportHeight, scrollFactorY, dt);
    }
}