package objects;

import glibs.GLogger;
import h2d.Anim;
import h2d.Tile;
import h2d.Bitmap;

class AnimatedSprite extends FNFObject {
    public var animation:Anim;
    public var animations:Map<String, Array<Tile>> = [];
    public var image:Tile;
    
    var xml:Xml;
    var xmlDirectory:String;

    /**
     * @param x The X position of the object.
     * @param y The Y position of the object.
     * @param image The underlying image / spritesheet to use.
     * @param xmlDirectory Path to the XML of this spritesheet.
     */
    public function new(x:Float, y:Float, image:Tile, xmlDirectory:String) {
        super(image);

        setPosition(x, y);

        // Fuck you purple square
        // Yeah don't set this to image btw
        tile = Tile.fromColor(0xFF06E806, 1, 1, 0);

        this.image = image;
        this.xmlDirectory = xmlDirectory;
        xmlDirectory += ".xml";

        animation = new Anim(null, 24, this);

        xml = Xml.parse(sys.io.File.getContent(xmlDirectory)).firstElement();
    }

    /**
     * Add an animation to an object.
     * @param name The name of the animation you wish to add.
     * @param prefix The name of the animation in the XML file.
     * @param offset An X and Y offset to give the animation. Can also be added later by calling `addOffsetToAnimation`.
     * @param playAnimAfterAddition Whether or not to play the animation after being added.
     */
    public function addAnimation(name:String, prefix:String, ?offset:Array<Int>, ?playAnimAfterAddition:Bool) {
        var anims:Array<Tile> = [];
        for (child in xml.elements()) {
            var childSubstr = child.get("name").substring(0, child.get("name").length - 4);
            if (childSubstr == prefix) {
                var frame:Tile = image.sub( Std.parseInt(child.get("x")), 
                                            Std.parseInt(child.get("y")), 
                                            Std.parseInt(child.get("width")), 
                                            Std.parseInt(child.get("height")),
                                           -Std.parseInt(child.get("frameX")),
                                           -Std.parseInt(child.get("frameY")) );
                if (offset != null) {
                    frame.dx += offset[0];
                    frame.dy += offset[1];
                    // addOffsetToAnimation(name, offset);
                }
                anims.push(frame);
            }
        }

        animations.set(name, anims);
        if (playAnimAfterAddition) {
            playAnimation(name);
        }
    }

    /**
     * Add an animation based on an animations indices.
     * Not recommended to use at the moment.
     * FIXME: Indices have to be IN ASCENDING ORDER!!! it does not work otherwise.
     */
    public function addAnimationByIndices(name:String, prefix:String, indices:Array<Int>, ?offset:Array<Int>, ?playAnimAfterAddition:Bool) {
        var anims:Array<Tile> = [];
        var i:Int = 0;
        var lastName:String = "";
        var zerosNum:String = "00";
        for (child in xml.elements()) {
            var childSubstr = child.get("name").substring(0, child.get("name").length - 4);
            if (indices[i] <= 9) zerosNum = "000";
            else zerosNum = "00";

            if (prefix == childSubstr) {
                trace("found animations, doing shit");
                if (childSubstr + zerosNum + indices[i] == child.get("name")) {
                    trace("if you see this then the code is working");
                    var frame:Tile = image.sub( Std.parseInt(child.get("x")), 
                                                Std.parseInt(child.get("y")), 
                                                Std.parseInt(child.get("width")), 
                                                Std.parseInt(child.get("height")),
                                               -Std.parseInt(child.get("frameX")),
                                               -Std.parseInt(child.get("frameY")) );
                    anims.push(frame);
                    i++;
                }
            }
            else trace("wrong anim fuckass! ", childSubstr);
        }
        animations.set(name, anims);
        trace(animations.get(name));
    }

    /**
     * FIXME: Offsets are *ever so slightly* incorrect
     */
    function addOffsetToAnimation(animationName:String, offset:Array<Int>) {
        for (frames in animations.get(animationName)) {
            frames.dx += offset[0];
            frames.dy += offset[1];
        }
    }

    public function playAnimation(name:String) {
        animation.play(animations.get(name));
    }
}