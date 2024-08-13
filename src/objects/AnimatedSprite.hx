package objects;

import h2d.Anim;
import h2d.Tile;
import h2d.Bitmap;

class AnimatedSprite extends Bitmap {
    public var animation:Anim;
    public var animations:Map<String, Array<Tile>> = [];
    public var image:Tile;
    
    var xml:Xml;
    var xmlDirectory:String;
    public function new(x:Float, y:Float, image:Tile, xmlDirectory:String) {
        super();

        setPosition(x, y);

        // Fuck you purple square
        // Yeah don't set this to image btw
        tile = Tile.fromColor(0xFF06E806, 1, 1, 0);

        this.image = image;
        this.xmlDirectory = xmlDirectory;

        animation = new Anim(null, 24, this);

        xml = Xml.parse(sys.io.File.getContent(xmlDirectory)).firstElement();
    }

    public function addAnimation(name:String, nameFromXML:String, ?offset:Array<Int>, ?playAnimAfterAddition:Bool) {
        var anims:Array<Tile> = [];
        for (child in xml.elements()) {
            var childSubstr = child.get("name").substring(0, child.get("name").length - 4);
            if (childSubstr == nameFromXML) {
                var frame:Tile = image.sub( Std.parseInt(child.get("x")), 
                                            Std.parseInt(child.get("y")), 
                                            Std.parseInt(child.get("width")), 
                                            Std.parseInt(child.get("height")),
                                           -Std.parseInt(child.get("frameX")),
                                           -Std.parseInt(child.get("frameY")) );
                if (offset != null) {
                    addOffsetToAnimation(name, offset);
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
     * FIXME: This does not work.
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