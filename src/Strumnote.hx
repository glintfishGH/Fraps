import glibs.GLogger;
import backend.Paths;
import objects.AnimatedSprite;
import h2d.Tile;

using StringTools;

/**
 * Gonna document this later im tired.
 */
class Strumnote extends AnimatedSprite {
    public var noteToDisplay:String;

    public var noteHoldTimer:Float;
    private var notePressed:Bool;

    var noteOffsets:Map<String, Array<Int>> = [
        "left"  => [-36, -36],
        "down"  => [-36, -38],
        "up"    => [-38, -37],
        "right" => [-36, -36]
    ];

    public function new(x:Float, y:Float, noteToDisplay:String) {
        image = Paths.image("gameplay/NOTE_assets"); // Change this if you want to use another note skin

        super(x, y, image);
        this.x = x;
        this.y = y;
        this.noteToDisplay = noteToDisplay;

        animation.loop = false;

        // addAnimation("staticLeft", "arrowLEFT");
        addAnimation("static" + GLGU.capitalize(noteToDisplay), "arrow" + noteToDisplay.toUpperCase(), null, true);

        //addAnimation("missLeft", "left press");
        addAnimation("miss" + GLGU.capitalize(noteToDisplay), noteToDisplay.toLowerCase() + " press");

        //addAnimation("hitLeft", "left confirm");
        addAnimation( "hit" + GLGU.capitalize(noteToDisplay), noteToDisplay.toLowerCase() + " confirm", 
                      noteOffsets.get(noteToDisplay.toLowerCase()) );

        this.setScale(0.7);
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
        hit ? playAnimation("hit" + direction) : playAnimation("miss" + direction);
        noteHoldTimer = 0;
        notePressed = true;
    }
}