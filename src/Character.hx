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

                // addOffsetToAnimation("left", [-8, 8]);
                // addOffsetToAnimation("down", [17, 55]);
                // addOffsetToAnimation("up", [49, -32]);
                // addOffsetToAnimation("right", [45, 8]);

            case "res/characters/DADDY_DEAREST":  
                addAnimation("idle", "Dad idle dance");
                addAnimation("left", "Dad Sing Note LEFT");
                addAnimation("down", "Dad Sing Note DOWN");
                addAnimation("up", "Dad Sing Note UP");
                addAnimation("right", "Dad Sing Note RIGHT");
            case "res/characters/gfDanceTitle":
                addAnimation("idle", "gfDance");
        }
        playAnimation("idle");
    }

    public function dance() {
        animation.play(animations.get("idle"));
    }
}