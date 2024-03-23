import hxd.Res;
import haxe.Json;
import hxd.File;
import h2d.Anim;
import h2d.Tile;
import h2d.Bitmap;


class Character extends Bitmap {
    public var animation:Anim;

    public var animArray:Array<Array<Tile>> = [];
    
    var idleArray:Array<Tile> = [];
    var leftNoteArray:Array<Tile> = [];
    var downNoteArray:Array<Tile> = [];
    var upNoteArray:Array<Tile> = [];
    var rightNoteArray:Array<Tile> = [];

    var image:Tile;
    var _xml:Xml;

    var charNameIsolated:String;

    public var playingAnim:Bool;

    public function new(x:Float, y:Float, image:Tile, ?xml:String, ?jsonOffsetFile:String) {
        super();
        this.x = x;
        this.y = y;
        this.image = image;

        initArrays();
        charNameIsolated = xml;
        xml += ".xml";

        var xmlPath = sys.io.File.getContent("res/" + xml);
        _xml = Xml.parse(xmlPath).firstElement();

        switch(xml.substring(0, xml.length - 4)) {
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
        
        if (File.exists("res/" + charNameIsolated + ".json")) {
            trace("checking for actual json offset");
            offsets = Json.parse(sys.io.File.getContent("res/" + charNameIsolated + ".json"));
        }

        else {
            trace("using po offsets");
            offsets = Json.parse(sys.io.File.getContent("res/_po.json"));
        }

        for (child in _xml.elements()) {
            var childSubstr = child.get("name").substring(0, child.get("name").length - 4);
            trace(childSubstr);

            if (animNames.contains(childSubstr)) {
                var frame:Tile = image.sub( Std.parseInt(child.get("x")), 
                                            Std.parseInt(child.get("y")), 
                                            Std.parseInt(child.get("width")), 
                                            Std.parseInt(child.get("height")),
                                           -Std.parseInt(child.get("frameX")),
                                           -Std.parseInt(child.get("frameY")) );

                // GLINT YOU FUCKING HOMOSEXUAL???'????????????
                // PLEASE FIX THIS LATER THIS IS ASS!!!!!!!!!!!!!!!
                if (childSubstr == animNames[0]) {
                    idleArray.push(frame);
                    trace("pushed idle");
                }
                if (childSubstr == animNames[1]) {
                    frame.dx += offsets.leftOffset[0];
                    frame.dy += offsets.leftOffset[1];
                    leftNoteArray.push(frame);
                    trace("pushed left");
                }
                if (childSubstr == animNames[2]) {
                    frame.dx += offsets.downOffset[0];
                    frame.dy += offsets.downOffset[1];
                    downNoteArray.push(frame);
                    trace("pushed down");
                }
                if (childSubstr == animNames[3]) {
                    frame.dx += offsets.upOffset[0];
                    frame.dy += offsets.upOffset[1];
                    upNoteArray.push(frame);
                    trace("pushed up");
                }
                if (childSubstr == animNames[4]) {
                    frame.dx += offsets.rightOffset[0];
                    frame.dy += offsets.rightOffset[1];
                    rightNoteArray.push(frame);
                    trace("pushed right");
                }
            }   
        }
    }

    /**
     * Play an animation!
     * Runs off of animArray, which is an array of an array of tiles
     * To play an animation, feed the function an int
     * IDLE - 0
     * LEFT - 1
     * DOWN - 2
     * UP - 3
     * RIGHT - 4
     * 
     * TODO: add timer that falls back to idle? might do this after making the conductor.
     * fps plus uses the amount of steps passed before returning to idle and i like that so i might yoink the idea
    **/ 
    public function playAnim(_animArray:Int, ?looping:Bool = false, ?fps:Int = 24) {
        animation.play(animArray[_animArray]);
        animation.loop = looping;
        animation.speed = fps;
    }

    private function initArrays() {
        animation = new Anim();

        animArray.push(idleArray);
        animArray.push(leftNoteArray);
        animArray.push(downNoteArray);
        animArray.push(upNoteArray);
        animArray.push(rightNoteArray);
    }
}