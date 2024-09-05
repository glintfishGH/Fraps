package glibs;

import hxd.res.Sound;
import h2d.Bitmap;
import h2d.Tile;

class GLGU {
    static var stamp:Float;
    static var sound:Sound;

    /**
     * WARNING: This is mostly inaccurate when targeting HL
     */
    public static function startStamp(?message:String) {
        stamp = Sys.time();
        GLogger.info("Started process: " + message);
    }

    /**
     * WARNING: This is mostly inaccurate when targeting HL
     */
    public static function endStamp() {
        GLogger.info('Finished process (${Sys.time() - stamp})');
    }

    public static function playSound(soundStr:String, volume:Float = 0.7) {
        sound = Paths.sound(soundStr);
        sound.play(false, volume);
    }

    public static function makeTile(x:Float, y:Float, width:Int, height:Int, color:Int = 0xFF000000):Tile {
        var bitmap:Bitmap = new Bitmap(Tile.fromColor(color, width, height));
        bitmap.x = x;
        bitmap.y = y;
        return bitmap.tile;
    }

    /**
     * Capitalzes a string so its first letter is capital
     * @param string The string to capitalize
     */
    public static function capitalize(string:String):String {
        return string.charAt(0).toUpperCase() + string.substring(1, string.length);
    }

    /**
     * Compares two values with a margin of error, so that something like `500 == 499` with a `margin` of 2 will return true.
     * @param value1 First value to compare.
     * @param value2 Second value to compare.
     * @param margin Margin of error.
     * @return Bool
     */
    public static function compareWithMargin(value1:Float, value2:Float, margin:Float):Bool {
        return (value1 - value2 <= margin || value2 - value1 >= margin);
    }
}