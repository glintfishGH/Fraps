import h2d.Anim;
import h2d.Bitmap;
import h2d.Tile;

/**
 * TODO: Change this so it extends AnimatedSprite.
 */
class Strumline extends Bitmap {
    public var animArray:Array<Array<Tile>> = [];
    public var leftStrumArray:Array<Tile> = [];
    public var downStrumArray:Array<Tile> = [];
    public var upStrumArray:Array<Tile> = [];
    public var rightStrumArray:Array<Tile> = [];

    var animation:Anim;
    var image:Tile;

    var _xml:Xml;

    public function new(x:Float, y:Float, image:Tile, xml:String, noteToDisplay:Int) {
        super();
        this.x = x;
        this.y = y;
        this.image = image;

        xml += ".xml";

        animArray.push(leftStrumArray);
        animArray.push(downStrumArray);
        animArray.push(upStrumArray);
        animArray.push(rightStrumArray);

        var xmlPath = sys.io.File.getContent("res/shared/images/NOTE_assets.xml");

        _xml = Xml.parse(xmlPath).firstElement();

        getStaticArrows(["arrowLEFT", "arrowDOWN",  "arrowUP",  "arrowRIGHT"],
                        ["left press",  "down press", "up press", "right press"]);

        animation = new Anim(animArray[noteToDisplay], 24, this);
        animation.loop = false;
    }

    private function getStaticArrows(staticAnims:Array<String>, pressNotes:Array<String>, ?confirmNotes:Array<String>) {
        for (child in _xml.elements()) {
            var childSubstr = child.get("name").substring(0, child.get("name").length - 4);
            if (staticAnims.contains(childSubstr) || pressNotes.contains(childSubstr)) {
                var frame:Tile = image.sub( Std.parseInt(child.get("x")), 
                                            Std.parseInt(child.get("y")), 
                                            Std.parseInt(child.get("width")), 
                                            Std.parseInt(child.get("height")),
                                           -Std.parseInt(child.get("frameX")),
                                           -Std.parseInt(child.get("frameY")) );
                frame.setCenterRatio();
                if (childSubstr == staticAnims[0]) {
                    leftStrumArray.push(frame);
                }
                else if (childSubstr == staticAnims[1]) {
                    downStrumArray.push(frame);
                }
                else if (childSubstr == staticAnims[2]) {
                    upStrumArray.push(frame);
                }
                else if (childSubstr == staticAnims[3]) {
                    rightStrumArray.push(frame);
                }
            }
        }
    }

    public function playStrumAnim(strumNumber:Int, ?hit:Bool = false) {
        animation.play(animArray[strumNumber]);
        if (hit) {
            animation.play(animArray[strumNumber], 4);
        }
    }
}