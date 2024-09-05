package backend;

import haxe.Json;
import hxd.res.Sound;
import h2d.Tile;
import hxd.Res;

using StringTools;
class Paths {
    public static var graphicCache:Map<String, Tile> = [];

    /**
     * @param key The asset you want to load. DO NOT include "res/" in the key
     * @param returnTile Whether or not to return the loaded image as a tile.
     */
    public static function image(key:String, ?dontLog:Bool = false, ?returnTile:Bool = true):Dynamic {
        if (graphicCache.exists(key)) {
            if (!dontLog) GLogger.info("Returned graphic from cache - " + key);
            return graphicCache.get(key);
        }

        var tileToReturn = Res.load("images/" + key + ".png").toImage().toTile();

        graphicCache.set(key, tileToReturn);
        GLogger.info('Set $key in graphicCache');

        if (returnTile) return tileToReturn;

        return 'res/$key.png';
    }

    public static function cacheGraphic(key:String) {
        if (!graphicCache.exists(key)) {
            var tileToReturn = Res.load("images/" + key + ".png").toImage().toTile();
            graphicCache.set(key, tileToReturn);
            GLogger.success('Sucessfully cached graphic ($key)');
        }
        else GLogger.warning('The tile you\'re trying to cache already exists in the cache ($key)');
    }

    /**
     * Returns a Channel (`songs/key.ogg`)
     */
    public static function song(key:String, ?returnString:Bool):hxd.snd.Channel {
        var song = Res.load("songs/" + key + ".ogg").toSound().play();
        song.pause = true;
        return song;
    }

    /**
     * Returns a Channel (`music/key.ogg`)
     */
    public static function music(key:String, ?returnString:Bool):hxd.snd.Channel {
        var song = Res.load("music/" + key + ".ogg").toSound().play();
        song.pause = true;
        return song;
    }

    /**
     * Returns a Sound (`sounds/key.ogg`)
     */
    public static function sound(key:String):Sound {
        return Res.load("sounds/" + key + ".ogg").toSound();
    }

    public static function parseChart(key:String):Dynamic {
        return Json.parse(sys.io.File.getContent("res/songs/" + key + "/chart.json".toLowerCase()));
    }

    public static function parseMetadata(key:String):Dynamic {
        return Json.parse(sys.io.File.getContent("res/songs/" + key + "/metadata.json".toLowerCase()));
    }

    /**
     * Returns the full path of an image.
     */
    public static function getTexPath(image:Tile):String {
        return "res/" + image.getTexture().name;
    }

    /**
     * Returns only the file file name of an image with no file extension
     */
     public static function getTexName(image:Tile):String {
        return Paths.getTexPath(image).split("/").pop().split(".").shift();
    }

    /**
     * Returns the full path of an xml.
     * TODO: Consolidate this function with getTexPath()
     */
     public static function getXmlPath(image:Tile):String {
        return "res/" + image.getTexture().name.replace(".png", ".xml");
    }

    public static function songCheck(key:String):String {
        return "res/songs/" + key + ".ogg";
    }
}