package objects;

import glibs.GLogger;
import h2d.Anim;
import h2d.Tile;
import h2d.Bitmap;

class AnimatedSprite extends FNFObject {
    /**
     * The animation object used for playing animations.
     * Not to be confused with `animations`, which contains all the animation data.
     */
    public var animation:Anim;

    /**
     * Contains all the animation data for this object.
     * Access animations by doing `animations.get("myAnimation")`.
     */
    public var animations:Map<String, Array<Tile>> = [];

    /**
     * The spritesheet used for this object.
     */
    public var image:Tile;
    
    /**
     * The XML of this object. Used for animation parsing.
     */
    public var xml:Xml;

    /**
     * @param x The X position of the object.
     * @param y The Y position of the object.
     * @param image The underlying image / spritesheet to use.
     */
    public function new(x:Float, y:Float, image:Tile) {
        super(image);

        setPosition(x, y);

        // Fuck you purple square
        // Yeah don't set this to image btw
        tile = Tile.fromColor(0xFF06E806, 1, 1, 0);

        this.image = image;
        var xmlDirectory:String = Paths.getXmlPath(image);

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
        // The animations we'll push to the animations map
        var anims:Array<Tile> = [];
        for (child in xml.elements()) {
            // The element we're parsing.
            var thisChild:String = child.get("name");

            // Removes the leading 0s at the end of the animation name.
            var childSubstr = thisChild.substring(0, thisChild.length - 4);

            // Does the name we're parsing match that of the prefix?
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
                }
                anims.push(frame);
            }
        }

        // We're done parsing the XML, push the Tiles array to the map
        animations.set(name, anims);

        if (playAnimAfterAddition) {
            playAnimation(name);
        }
    }

    /**
     * Only used on the alphabet.
     */
    function addBlankAnimation(name:String, width:Int, height:Int, alpha:Float = 0) {
        var anim:Array<Tile> = [];
        var bitmap:Bitmap = new Bitmap(Tile.fromColor(0xFFFFFFFF, width, height, alpha));
        anim.push(bitmap.tile);

        animations.set(name, anim);
    }

    /**
     * Add an animation based on an animations indices.
     * Not recommended to use at the moment.
     * FIXME: Indices have to be IN ASCENDING ORDER!!! it does not work otherwise.
     */
    public function addAnimationByIndices(name:String, prefix:String, indices:Array<Int>, ?offset:Array<Int>, ?playAnimAfterAddition:Bool) {
        // I am aware that "unintended happenings" is not a real word but im keeping this warning in purely because of how fucking stupid it is.
        GLogger.warning("addAnimationByIndices does not work properly at the moment and may result in unintended happenings.");
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