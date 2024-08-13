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

	override function init() {
        var bg:Stage = new Stage(0, 0, Res.images.week1.stageback.toTile());
        s2d.addChild(bg);

        var text:Text = new Text(DefaultFont.get());
        text.text = "Welcome to the Offset editor.\nUse WASD to change the animation.\nUse the arrow keys to offset the animation";
        text.setPosition(20, 20);
        s2d.addChild(text);

        switch(PlayState.offsetCharacter) {
            case "BOYFRIEND": 
                char = new Character(0, 0, Paths.image("characters/BOYFRIEND"), "res/characters/BOYFRIEND");
            case "DADDY_DEAREST":
                char = new Character(0, 0, Paths.image("characters/DADDY_DEAREST"), "res/characters/DADDY_DEAREST");
        }
        for (anim in char.animations.keys()) {
            animList.push(anim);
        }
        char.playAnimation(animList[0]);
        trace(animList);
        idleTile = new Bitmap();
        s2d.addChild(idleTile);
        setGhost();
        animOffsets = new Text(DefaultFont.get());
        animOffsets.setPosition(20, 100);
        s2d.addChild(animOffsets);
        
        char.setPosition(Window.getInstance().width / 2 - char.getSize().width / 2, Window.getInstance().height / 2 - char.getSize().height / 2);
        s2d.addChild(char);
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

        if (Key.isPressed(Key.Q)) {
            s2d.camera.setScale(s2d.camera.scaleX - 0.01, s2d.camera.scaleY - 0.01);
        }

        if (Key.isPressed(Key.E)) {
            s2d.camera.setScale(s2d.camera.scaleX + 0.01, s2d.camera.scaleY + 0.01);
        }

        if (Key.isPressed(Key.A)) {
            animationIndex--;
            if (animationIndex < 0) {
                animationIndex = animList.length - 1;
            }
            char.playAnimation(animList[animationIndex]);
        }
        if (Key.isDown(Key.SHIFT)) {
            moveAmount = 20;
        }
        else moveAmount = 2;
        if (Key.isPressed(Key.D)) {
            animationIndex++;
            if (animationIndex > animList.length - 1) {
                animationIndex = 0;
            }
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
        updateOffsetText();
    }
}