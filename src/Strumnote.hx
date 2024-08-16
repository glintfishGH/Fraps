import Note.NoteDir;
import haxe.ds.Either;
import objects.AnimatedSprite;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Tile;

class Strumnote extends AnimatedSprite {
    public function new(x:Float, y:Float, image:Tile, xml:String, noteToDisplay:Int) {
        super(x, y, image, xml + ".xml");
        this.x = x;
        this.y = y;
        this.image = image;

        xml += ".xml";

        animation.loop = false;

        addAnimation("staticLeft", "arrowLEFT");
        addAnimation("staticDown", "arrowDOWN");
        addAnimation("staticUp", "arrowUP");
        addAnimation("staticRight", "arrowRIGHT");

        addAnimation("hitLeft", "left press");
        addAnimation("hitDown", "down press");
        addAnimation("hitUp", "up press");
        addAnimation("hitRight", "left press");
    }

    public function playStrumAnim(direction:String, hit:Bool) {
        hit ? playAnimation("hit" + direction) : playAnimation("static" + direction);
    }
}