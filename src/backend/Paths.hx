package backend;

import h2d.Tile;
import hxd.Res;

class Paths {
    @:deprecated("This function causes a crash!")
    public static inline function image(key:String, ?returnTile:Bool = true):Any {
        return Res.load(key + ".png");
    }
}