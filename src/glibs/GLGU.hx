package glibs;

import h2d.Bitmap;
import h2d.Tile;

class GLGU {
    static var stamp:Float;

    /**
     * WARNING: This is mostly inaccurate when targeting HL
     */
    public static function startStamp(?message:String) {
        stamp = Sys.time();
        GLogger.info(message);
    }

    /**
     * WARNING: This is mostly inaccurate when targeting HL
     */
    public static function endStamp() {
        trace('Finished process (${Sys.time() - stamp})');
    }

    public static function makeTile(x:Float, y:Float, width:Int, height:Int, color:Int = 0xFF000000):Bitmap {
        var bitmap:Bitmap = new Bitmap(Tile.fromColor(color, width, height));
        bitmap.x = x;
        bitmap.y = y;
        return bitmap;
    }
}