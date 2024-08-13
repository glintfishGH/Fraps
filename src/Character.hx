import haxe.Timer;
import objects.AnimatedSprite;
import h2d.Tile;


class Character extends AnimatedSprite {
    var charNameIsolated:String;
    public var playingAnim:Bool;

    var holdTimer:Timer;

    /**
     * In miliseconds.
     */
    var noteHoldTime:Int = 700;

    public function new(x:Float, y:Float, image:Tile, ?xmlPath:String) {
        super(x, y, image, xmlPath + ".xml");
        charNameIsolated = xmlPath;

        holdTimer = new Timer(noteHoldTime);

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

            case "res/characters/gfDanceTitle":
                addAnimation("idle", "gfDance");
        }
        playAnimation("idle");
    }

    public function dance() {
        if (!playingAnim)
            animation.play(animations.get("idle"));
    }

    override function playAnimation(name:String) {
        super.playAnimation(name);

        // playingAnim = true;

        /**
         * Calling `holdTimer.stop()` doesn't allow us to run the timer function again, so we create a new instance.
         * FIXME: This causes a memory leak... too bad!
         */
        // if (name != "idle" && playingAnim) {
        //     holdTimer.run = function() {
        //         playingAnim = false;
        //         dance();
                
        //         // do nothing fuckass
        //         holdTimer.run = function() {}
        //     }
        // }
    }
}