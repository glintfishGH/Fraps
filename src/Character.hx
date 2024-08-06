import haxe.Json;
import hxd.File;
import h2d.Anim;
import h2d.Tile;
import h2d.Bitmap;


class Character extends Bitmap {
    /**
     * Animation object. Used to... play animations.
     */
    public var animation:Anim;

    /**
     * Contains all the animations for the character.
     */
    public var animArray:Array<Array<Tile>> = [];
    
    var idleArray:Array<Tile> = [];
    var leftNoteArray:Array<Tile> = [];
    var downNoteArray:Array<Tile> = [];
    var upNoteArray:Array<Tile> = [];
    var rightNoteArray:Array<Tile> = [];

    /**
     * The image / tile to use for this character.
     */
    var image:Tile;

    /**
     * The XML file to parse.
     */
    var xml:Xml;

    /**
     * The characters name with no .xml extension.
     * Set by using the `xmlPath` param in the constructor.
     * Probably a bad idea?
     */
    var charNameIsolated:String;

    /**
     * If the character is playing an animation. Used for making the character play their idle after pressing a note.
     */
    public var playingAnim:Bool;

    public function new(x:Float, y:Float, image:Tile, ?xmlPath:String, ?jsonOffsetFile:String) {
        super();
        this.x = x;
        this.y = y;
        this.image = image;

        // Sets the tile to a green transparent pixel.
        // This fixes the issue where there'd be a pink tile on the top left of the frame
        tile = Tile.fromColor(0xFF06E806, 1, 1, 0);

        initArrays();
        charNameIsolated = xmlPath;
        xmlPath += ".xml";
        trace(charNameIsolated, xmlPath);

        var xmlDirectory = sys.io.File.getContent("res/characters/" + xmlPath);
        xml = Xml.parse(xmlDirectory).firstElement();

        switch(charNameIsolated) {
            case "BOYFRIEND": 
                getAnim(["BF idle dance", "BF NOTE LEFT", "BF NOTE DOWN", "BF NOTE UP", "BF NOTE RIGHT"]);
            case "DADDY_DEAREST":
                getAnim(["Dad idle dance", "Dad Sing Note LEFT", "Dad Sing Note DOWN", "Dad Sing Note UP", "Dad Sing Note RIGHT"]);
            case "gfDanceTitle":
                getAnim(["gfDance"]);
            default:
                getAnim(["BF idle dance", "BF NOTE LEFT", "BF NOTE DOWN", "BF NOTE UP", "BF NOTE RIGHT"]);
        }
        
        animation = new Anim(idleArray, 24, this);
        animation.loop = false;
    }

    /**
     * Get animations from XML. USE THE FOLLOWING FORMAT: IDLE, UP, DOWN, LEFT, RIGHT, UP MISS, DOWN MISS, ...
     * @param animNames Array of animation names from the XML
     */
    private function getAnim(animNames:Array<String>) {
        var offsets;
        
        // Checks if the offset file exists.
        File.exists("res/characters/" + charNameIsolated + ".json") ? {
            // It does, return it.
            trace('Found offset file for $charNameIsolated');
            offsets = Json.parse(sys.io.File.getContent("res/characters/" + charNameIsolated + ".json"));
        } : {
            // It does not, use placeholder offset file
            trace('Couldn\'t find offset file for $charNameIsolated, using default.');
            offsets = Json.parse(sys.io.File.getContent("res/characters/_po.json"));
        }

        /**
         * Goes through the xml and gets the elements. 
         * We then loop through the data of an element and assign it to a Tile
         * We push that Tile into an array depending on the name.
         * This is a *somewhat* okay way of adding the animations, since you only need to loop through it once.
         */
        for (child in xml.elements()) {
            // Gets the animation name and cuts the 0s at the end
            // TODO: Make this work differently, since some animations might have 5 or more leading 0s
            var childSubstr = child.get("name").substring(0, child.get("name").length - 4);
            trace(childSubstr);

            if (animNames.contains(childSubstr)) {
                // Creates a frame from the xml data.
                var frame:Tile = image.sub( Std.parseInt(child.get("x")), 
                                            Std.parseInt(child.get("y")), 
                                            Std.parseInt(child.get("width")), 
                                            Std.parseInt(child.get("height")),
                                           -Std.parseInt(child.get("frameX")),
                                           -Std.parseInt(child.get("frameY")) );
                trace(frame.dx, frame.dy);

                // This is ass but I don't know how to do a switch with array members
                if (childSubstr == animNames[0]) {
                    idleArray.push(frame);
                    trace("pushed idle");
                }
                if (childSubstr == animNames[1]) {
                    frame.dx += offsets.leftOffset[0];
                    frame.dy += offsets.leftOffset[1];
                    trace(frame.dx, frame.dy);
                    leftNoteArray.push(frame);
                    trace("pushed left");
                }
                if (childSubstr == animNames[2]) {
                    frame.dx += offsets.downOffset[0];
                    frame.dy += offsets.downOffset[1];
                    trace(frame.dx, frame.dy);
                    downNoteArray.push(frame);
                    trace("pushed down");
                }
                if (childSubstr == animNames[3]) {
                    frame.dx += offsets.upOffset[0];
                    frame.dy += offsets.upOffset[1];
                    trace(frame.dx, frame.dy);
                    upNoteArray.push(frame);
                    trace("pushed up");
                }
                if (childSubstr == animNames[4]) {
                    frame.dx += offsets.rightOffset[0];
                    frame.dy += offsets.rightOffset[1];
                    trace(frame.dx, frame.dy);
                    rightNoteArray.push(frame);
                    trace("pushed right");
                }
            }   
        }
    }

    /**
     * Plays an animation.
     * Runs off of animArray, which is an array of an array of tiles
     * To play an animation, feed the function an int
     * LEFT - 1
     * DOWN - 2
     * UP - 3
     * RIGHT - 4
     * 
     * TODO: add timer that falls back to idle? might do this after making the conductor. This also needs to be remade along with the way the animations are handled to allow you to pass in strings here for which animation to play
    **/ 
    public function playAnim(_animArray:Int, ?priority:Bool = true, ?looping:Bool = false, ?fps:Int = 24) {
        animation.play(animArray[_animArray]);
        animation.loop = looping;
        animation.speed = fps;
        playingAnim = true;
    }

    // Plays the idle animation.
    public function dance() {
        if (!playingAnim)
            animation.play(animArray[0]);
    }

    /**
     * Pushes the pose arrays to `animArray`. Makes the code slightly less cluttered.
     */
    private function initArrays() {
        animArray.push(idleArray);
        animArray.push(leftNoteArray);
        animArray.push(downNoteArray);
        animArray.push(upNoteArray);
        animArray.push(rightNoteArray);
    }
}