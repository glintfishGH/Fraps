import haxe.Timer;
import objects.AnimatedSprite;
import h2d.Tile;


class Character extends AnimatedSprite {
    var charNameIsolated:String;
    public var playingAnim:Bool;

    public var holdTimer:Float;

    /**
     * In miliseconds.
     */
    var noteHoldTime:Int = 700;

    public function new(x:Float, y:Float, image:Tile, ?xmlPath:String) {
        super(x, y, image, xmlPath);
        charNameIsolated = xmlPath;

        animation.loop = false;

        switch(charNameIsolated) {
            case "res/characters/BOYFRIEND":  
                addAnimation("idle", "BF idle dance");
                addAnimation("left", "BF NOTE LEFT");
                addAnimation("down", "BF NOTE DOWN");
                addAnimation("up", "BF NOTE UP");
                addAnimation("right", "BF NOTE RIGHT");

                addOffsetToAnimation("down",    [12,  49]);
                addOffsetToAnimation("up",      [46, -32]);
                addOffsetToAnimation("right",   [46,  6]);
                addOffsetToAnimation("left",    [-6,  6]);

            case "res/characters/DADDY_DEAREST":  
                addAnimation("idle", "Dad idle dance");
                addAnimation("left", "Dad Sing Note LEFT");
                addAnimation("down", "Dad Sing Note DOWN");
                addAnimation("up", "Dad Sing Note UP");
                addAnimation("right", "Dad Sing Note RIGHT");

                addOffsetToAnimation("down",    [-2,   52]);
                addOffsetToAnimation("up",      [10,  -65]);
                addOffsetToAnimation("right",   [4,  -31]);
                addOffsetToAnimation("left",    [7, -11]);

            case "res/characters/girlfriend":
                // addAnimation("idle", "GF Dancing Beat");
                addAnimationByIndices("danceRight", "GF Dancing Beat", [for (i in 0...15) i]);
                addAnimationByIndices("danceLeft", "GF Dancing Beat", [for (i in 16...30) i]);
            default:
        }
        if (animations.exists("idle")) playAnimation("idle");
        else trace("No idle exists for this character!");
    }

    public function dance() {
        if (!playingAnim)
            animation.play(animations.get("idle"));
    }

    override function update(dt:Float) {
        super.update(dt);
        if (playingAnim) holdTimer += dt;
        if (holdTimer > 0.5) {
            holdTimer = 0;
            playingAnim = false;
            GLogger.info("Resetting to idle");
            this.playAnimation("idle");
        }
    }

    override function playAnimation(name:String) {
        super.playAnimation(name);

        GLogger.info("Playing animation - " + name);

        if (name != "idle") {
            playingAnim = true;
            holdTimer = 0;
        }
    }
}