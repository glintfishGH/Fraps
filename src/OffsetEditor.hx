import h2d.Camera;
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
    var moveAmount:Int = 2;

    var moveX:Int;
    var moveY:Int;

    var charOffsetX:Int;
    var charOffsetY:Int;

    var animList:Array<String> = [];

    var animOffsets:Text;

	public function new() {
        super();
        var bg:Stage = new Stage(0, 0, Paths.image("images/week1/wall"));
        addChild(bg);

        var text:Text = new Text(DefaultFont.get());
        text.text = "Welcome to the Offset editor.\nUse WASD to change the animation.\nUse the arrow keys to offset the animation";
        text.setPosition(20, 20);
        addChild(text);

        char = new Character(0, 0, Paths.image('characters/${PlayState.offsetCharacter}'), 'res/characters/${PlayState.offsetCharacter}');
        for (anim in char.animations.keys()) {
            animList.push(anim);
        }
        char.playAnimation(animList[0]);
        trace(animList);
        idleTile = new Bitmap();
        addChild(idleTile);
        setGhost();
        animOffsets = new Text(DefaultFont.get());
        animOffsets.setPosition(20, 100);
        addChild(animOffsets);
        
        char.setPosition(Window.getInstance().width / 2 - char.getSize().width / 2, Window.getInstance().height / 2 - char.getSize().height / 2);
        addChild(char);
	}

	/**
     * Sets up the "Ghost.
	 */
	function setGhost() {
        idleTile.tile = char.animations.get("idle")[0];
        idleTile.alpha = 0.4;
        idleTile.setPosition(Window.getInstance().width / 2 - char.getSize().width / 2, Window.getInstance().height / 2 - char.getSize().height / 2);
	}

    function updateOffsetText() {
        animOffsets.text = "";
        for (i in 0...animList.length) {
            animOffsets.text += animList[i] + ": " + char.animations.get(animList[i])[0].dx + " | ";
            animOffsets.text += char.animations.get(animList[i])[0].dy + "\n";
        }
    }

    override function update(dt:Float) {
        super.update(dt);

        if (Key.isDown(Key.Q)) camera.setScale(camera.scaleX - 0.01, camera.scaleY - 0.01);

        if (Key.isDown(Key.E)) camera.setScale(camera.scaleX + 0.01, camera.scaleY + 0.01);

        if (Key.isPressed(Key.A)) {
            animationIndex--;
            if (animationIndex < 0) animationIndex = animList.length - 1;
            char.playAnimation(animList[animationIndex]);
        }
        if (Key.isDown(Key.SHIFT)) moveAmount = 10;
                              else moveAmount = 1;

        if (Key.isPressed(Key.D)) {
            animationIndex++;
            if (animationIndex > animList.length - 1) animationIndex = 0;
            char.playAnimation(animList[animationIndex]);
        }

        if (Key.isPressed(Key.LEFT)) {
            for (frame in char.animations.get(animList[animationIndex])) {
                frame.dx -= moveAmount;
            }
        }

        if (Key.isPressed(Key.RIGHT)) {
            for (frame in char.animations.get(animList[animationIndex])) {
                frame.dx += moveAmount;
            }
        }

        if (Key.isPressed(Key.DOWN)) {
            for (frame in char.animations.get(animList[animationIndex])) {
                frame.dy += moveAmount;
            }
        }

        if (Key.isPressed(Key.UP)) {
            for (frame in char.animations.get(animList[animationIndex])) {
                frame.dy -= moveAmount;
            }
        }

        if (Key.isPressed(Key.ENTER)) {
            changeScene(new PlayState());
        }
        updateOffsetText();
    }
}