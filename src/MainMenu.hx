import backend.Paths;
import hxd.snd.Channel;
import h2d.TileGroup;
import hxd.Key;
import hxd.Window;
import h2d.Tile;
import hxd.BitmapData;
import h2d.Camera;
import objects.AnimatedSprite;
import h3d.anim.Animation.AnimatedObject;
import hxd.Res;
import h2d.Bitmap;
import backend.MusicBeatState;

enum Direction {
    UP;
    DOWN;
    NONE;
}

class MainMenu extends MusicBeatState {
    var bg:Bitmap;

    var optionsArray:Array<String> = ["story", "freeplay", "options"];

    var menuOptions:Array<AnimatedSprite> = [];
    var storyMode:AnimatedSprite;
    var freeplay:AnimatedSprite;
    var options:AnimatedSprite;

    var curSelected:Int = 0;

    override function init() {
        super.init();
        
        bg = new Bitmap(Paths.image("images/mainMenu/menuBG"));
        s2d.addChild(bg);

        for (i in 0...3) {
            var menuOption:AnimatedSprite = new AnimatedSprite(0, 50 + 225 * i, Res.images.mainMenu.mainMenu_png.toTile(), "res/images/mainMenu/mainMenu.xml");
            menuOption.addAnimation("idle", '${optionsArray[i]} small');
            menuOption.addAnimation("selected", '${optionsArray[i]}');
            menuOption.playAnimation("idle");

            if (i == 0) {
                menuOption.setScale(0.75);
            }

            menuOption.x = (Window.getInstance().width - menuOption.getBounds().width) / 2;
            // for (frame in 0...menuOption.animation.frames.length)
            //     menuOption.animation.frames[frame].setCenterRatio();
            menuOptions.push(menuOption);
        }

        moveSelection(NONE);

        for (sprite in menuOptions) {
            s2d.addChild(sprite);
        }
    }

    override function update(dt:Float) {
        if (Key.isPressed(Key.DOWN)) {
            moveSelection(DOWN);
        }
        if (Key.isPressed(Key.UP)) {
            moveSelection(UP);
        }
        if (Key.isPressed(Key.ENTER)) {
            TitleState.song.pause = true;
            new PlayState();
        }
        super.update(dt);
    }

    function moveSelection(direction:Direction) {
        if (direction != NONE)
            direction == UP ? curSelected-- : curSelected++;
        for (i in 0...menuOptions.length) {

            /**
             * TODO: Make this work slightly differently, since the idle animation restarts every time this function is called
             */
            if (i == curSelected)
                menuOptions[curSelected].playAnimation("selected");
            else
                menuOptions[i].playAnimation("idle");
            menuOptions[i].x = (Window.getInstance().width - menuOptions[i].getBounds().width) / 2;
        }
    }
}