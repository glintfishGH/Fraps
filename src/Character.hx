import objects.AnimatedSprite;
import haxe.Json;
import hxd.File;
import h2d.Anim;
import h2d.Tile;
import h2d.Bitmap;


class Character extends AnimatedSprite {
    var charNameIsolated:String;
    public var playingAnim:Bool;

    public function new(x:Float, y:Float, image:Tile, ?xmlPath:String) {
        super(x, y, image, xmlPath + ".xml");
        charNameIsolated = xmlPath;

        animation.loop = false;

        switch(charNameIsolated) {
            case "res/characters/BOYFRIEND":  
                addAnimation("idle", "BF idle dance");
                addAnimation("left", "BF NOTE LEFT");
                addAnimation("down", "BF NOTE DOWN");
                addAnimation("up", "BF NOTE UP");
                addAnimation("right", "BF NOTE RIGHT");

                addOffsetToAnimation("down", [13, 57]);
                addOffsetToAnimation("up", [52, -32]);
                addOffsetToAnimation("right", [46, 8]);
                addOffsetToAnimation("left", [-6, 6]);

            case "res/characters/DADDY_DEAREST":  
                addAnimation("idle", "Dad idle dance");
                addAnimation("left", "Dad Sing Note LEFT");
                addAnimation("down", "Dad Sing Note DOWN");
                addAnimation("up", "Dad Sing Note UP");
                addAnimation("right", "Dad Sing Note RIGHT");

                addOffsetToAnimation("down", [0, 37]);
                addOffsetToAnimation("up", [9, -50]);
                addOffsetToAnimation("right", [4, -25]);
                addOffsetToAnimation("left", [10, -10]);

            case "res/characters/gfDanceTitle":
                addAnimation("idle", "gfDance");
        }
        playAnimation("idle");
    }

    public function dance() {
        animation.play(animations.get("idle"));
    }
}