import glibs.GLogger;
import backend.Paths;
import objects.AnimatedSprite;
import h2d.Tile;

class Strumnote extends AnimatedSprite {
    public var noteToDisplay:String;
    public var noteHoldTimer:Float;

    private var notePressed:Bool;

    public function new(x:Float, y:Float, ?image:Tile, ?xml:String, ?noteToDisplay:String) {
        xml ?? "res/images/gameplay/NOTE_assets";
        super(x, y, image, xml);
        this.x = x;
        this.y = y;
        image ?? Paths.image("images/gameplay/NOTE_assets");
        this.image = image;
        this.noteToDisplay = noteToDisplay;

        xml += ".xml";

        animation.loop = false;

        /**
         * TODO: Change this so it doesnt load all the animations for each one note instance.
         */
        addAnimation("staticLeft", "arrowLEFT");
        addAnimation("staticDown", "arrowDOWN");
        addAnimation("staticUp", "arrowUP");
        addAnimation("staticRight", "arrowRIGHT");

        addAnimation("missLeft", "left press");
        addAnimation("missDown", "down press");
        addAnimation("missUp", "up press");
        addAnimation("missRight", "rightd press");

        addAnimation("hitLeft", "left confirm", [-36, -36]);
        addAnimation("hitDown", "down confirm", [-36, -38]);
        addAnimation("hitUp", "up confirm", [-38, -37]);
        addAnimation("hitRight", "right confirm", [-36, -36]);
    }

    override function update(dt:Float) {
        super.update(dt);
        if (notePressed) noteHoldTimer += dt;

        if (noteHoldTimer > 0.125) {
            noteHoldTimer = 0;
            notePressed = false;
            this.playAnimation("static" + noteToDisplay);
        }
    }

    public function playStrumAnim(direction:String, hit:Bool) {
        hit ? playAnimation("hit" + direction) : playAnimation("static" + direction);
        noteHoldTimer = 0;
        notePressed = true;
    }
}