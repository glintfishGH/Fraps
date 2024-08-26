package backend;

import haxe.ds.Either;
import sys.io.File;
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
    public static inline function image(key:String, ?returnTile:Bool = true):Dynamic {
        if (returnTile) return Res.load(key + ".png").toImage().toTile();
        return 'res/$key.png';
    }

    public static inline function song(key:String):hxd.snd.Channel {
        var song = Res.load(key + ".ogg").toSound().play();
        song.pause = true;
        return song;
    }

    public static inline function sound(key:String):Sound {
        return Res.load(key + ".ogg").toSound();
    }
}