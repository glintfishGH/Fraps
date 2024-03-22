import h2d.Text;
import hxd.Key;
import h2d.Bitmap;
import hxd.Res;
import Character;
import haxe.Json;
import hxd.Window;
import backend.*;

class OffsetEditor extends MusicBeatState {
	var char:Character;
    var idleTile:Bitmap;

    var arrayIndex_:Int = 0;

    var offsetX:Int;
    var offsetY:Int;

	override function init() {
        var bg:Stage = new Stage(0, 0, Res.images.week1.stageback.toTile());
        s2d.addChild(bg);

        switch(PlayState.offsetCharacter) {
            case "BOYFRIEND": 
                char = new Character(0, 0, Res.BOYFRIEND_png.toTile(), "BOYFRIEND");
            case "PICO":
                char = new Character(0, 0, Res.DADDY_DEAREST_png.toTile(), "DADDY_DEAREST");
            
        }
        idleTile = new Bitmap();
        s2d.addChild(idleTile);
        setGhost();
        
        char.setPosition(Window.getInstance().width / 2 - char.getSize().width / 2, Window.getInstance().height / 2 - char.getSize().height / 2);
        s2d.addChild(char);
	}

	/**
     * Sets up the "Ghost". Assumes idleArray is the first array in animArray
	 */
	function setGhost() {
        idleTile.tile = char.animArray[0][0];
        idleTile.alpha = 0.4;
        idleTile.setPosition(Window.getInstance().width / 2 - char.getSize().width / 2, Window.getInstance().height / 2 - char.getSize().height / 2);
	}

    override function update(dt:Float) {
        super.update(dt);
        
        if (arrayIndex_ > char.animArray.length - 1) {
            trace("arrayIndex is higher than the amount of arrays! going back!");
            char.playAnim(arrayIndex_, false, 24);
            arrayIndex_ = 0;
        }

        if (arrayIndex_ < 0) {
            trace("arrayIndex is under 0!");
            char.playAnim(arrayIndex_, false, 24);
            arrayIndex_ = char.animArray.length - 1;
        }

        if (Key.isPressed(Key.D)) {
            arrayIndex_++;
            char.playAnim(arrayIndex_, false, 24);
        }
        if (Key.isPressed(Key.A)) {
            arrayIndex_--;
            char.playAnim(arrayIndex_, false, 24);
        }

        if (Key.isDown(Key.SHIFT)) {
            offsetX = 10;
            offsetY = 10;
        }
        else {
            offsetX = 1;
            offsetY = 1;
        }
        
        if (Key.isPressed(Key.UP)) {
            for (frame in 0...char.animArray[arrayIndex_].length) {
                char.animArray[arrayIndex_][frame].dy -= offsetY;
            }
            char.playAnim(arrayIndex_, false, 24);
        }
        if (Key.isPressed(Key.DOWN)) {
            for (frame in 0...char.animArray[arrayIndex_].length) {
                char.animArray[arrayIndex_][frame].dy += offsetY;
            }
            char.playAnim(arrayIndex_, false, 24);
        }

        if (Key.isPressed(Key.LEFT)) {
            for (frame in 0...char.animArray[arrayIndex_].length) {
                char.animArray[arrayIndex_][frame].dx -= offsetX;
            }
            char.playAnim(arrayIndex_, false, 24);
        }
        if (Key.isPressed(Key.RIGHT)) {
            for (frame in 0...char.animArray[arrayIndex_].length) {
                char.animArray[arrayIndex_][frame].dx += offsetX;
            }
            char.playAnim(arrayIndex_, false, 24);
        }

        if (Key.isPressed(Key.ENTER))
            {
                var jsonData = {
                    leftOffset: [char.animArray[1][0].dx, char.animArray[1][0].dy],
                    downOffset: [char.animArray[2][0].dx, char.animArray[2][0].dy],
                    upOffset: [char.animArray[3][0].dx, char.animArray[3][0].dy],
                    rightOffset: [char.animArray[4][0].dx, char.animArray[4][0].dy]
                };
                var _json:String = Json.stringify(jsonData, "\t");
                sys.io.File.saveContent("res/" + PlayState.offsetCharacter + ".json", _json);
                new PlayState();
            }
    }
}