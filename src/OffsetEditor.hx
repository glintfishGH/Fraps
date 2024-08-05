import hxd.res.DefaultFont;
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

    var animationIndex:Int = 0;

    var moveX:Int;
    var moveY:Int;

    var charOffsetX:Int;
    var charOffsetY:Int;

	override function init() {
        var bg:Stage = new Stage(0, 0, Res.images.week1.stageback.toTile());
        s2d.addChild(bg);

        var text:Text = new Text(DefaultFont.get());
        text.text = "Welcome to the Offset editor.\nUse WASD to change the animation.\nUse the arrow keys to offset the animation";
        text.setPosition(20, 20);
        s2d.addChild(text);

        switch(PlayState.offsetCharacter) {
            case "BOYFRIEND": 
                char = new Character(0, 0, Res.characters.BOYFRIEND_png.toTile(), "BOYFRIEND");
            case "DADDY_DEAREST":
                char = new Character(0, 0, Res.characters.DADDY_DEAREST_png.toTile(), "DADDY_DEAREST");
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
        trace(animationIndex);
        
        if (animationIndex > char.animArray.length - 1) {
            trace("arrayIndex is higher than the amount of arrays! going back!");
            animationIndex = 0;
            char.playAnim(animationIndex, false, 24);
        }

        if (animationIndex < 0) {
            trace("arrayIndex is under 0!");
            animationIndex = char.animArray.length - 1;
            char.playAnim(animationIndex, false, 24);
        }

        if (Key.isPressed(Key.D)) {
            animationIndex++;
            char.playAnim(animationIndex, false, 24);
        }
        if (Key.isPressed(Key.A)) {
            animationIndex--;
            char.playAnim(animationIndex, false, 24);
        }

        if (Key.isDown(Key.SHIFT)) {
            moveX = 10;
            moveY = 10;
        }
        else {
            moveX = 1;
            moveY = 1;
        }
        
        // Loops through all the frames in the animation and offsets them by move[Dir]
        // This code is ages old so dont eat my ass lmao
        if (Key.isPressed(Key.UP)) {
            for (frame in char.animArray[animationIndex]) {
                frame.dy -= moveY;
            }
            char.playAnim(animationIndex, false, 24);
        }
        if (Key.isPressed(Key.DOWN)) {
            charOffsetY++;
            for (frame in char.animArray[animationIndex]) {
                frame.dy += moveY;
            }
            char.playAnim(animationIndex, false, 24);
        }

        if (Key.isPressed(Key.LEFT)) {
            charOffsetX--;
            for (frame in char.animArray[animationIndex]) {
                frame.dx -= moveX;
            }
            char.playAnim(animationIndex, false, 24);
        }
        if (Key.isPressed(Key.RIGHT)) {
            charOffsetX++;
            for (frame in char.animArray[animationIndex]) {
                frame.dx += moveX;
            }
            char.playAnim(animationIndex, false, 24);
        }

        if (Key.isPressed(Key.ENTER))
            {
                var jsonData = {
                    leftOffset: [char.animArray[1][0].dx + charOffsetX, char.animArray[1][0].dy + charOffsetX],
                    downOffset: [char.animArray[2][0].dx + charOffsetX, char.animArray[2][0].dy + charOffsetX],
                    upOffset: [char.animArray[3][0].dx + charOffsetX, char.animArray[3][0].dy + charOffsetX],
                    rightOffset: [char.animArray[4][0].dx + charOffsetX, char.animArray[4][0].dy + charOffsetX]
                };
                var _json:String = Json.stringify(jsonData, "\t");
                sys.io.File.saveContent("res/characters/" + PlayState.offsetCharacter + ".json", _json);
                PlayState.inst.stop();
                PlayState.vocals.stop();
                new PlayState();
            }
    }
}