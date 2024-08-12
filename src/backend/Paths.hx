package backend;

import hxsl.Channel;
import hxd.res.Sound;
import h2d.Tile;
import hxd.Res;

class Paths {
    /**
     * @param key The asset you want to load. DO NOT include "res/" in the key
     * @param returnTile Whether or not to return the loaded image as a tile.
     * @return Any
     */
    public static inline function image(key:String, ?returnTile:Bool = true):Tile {
        return Res.load(key + ".png").toImage().toTile();
    }

    public static inline function song(key:String):hxd.snd.Channel {
        var song = Res.load(key + ".ogg").toSound().play();
        song.pause = true;
        return song;
    }
}