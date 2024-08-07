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

    var menuOptions:Array<AnimatedSprite> = [];
    var storyMode:AnimatedSprite;
    var freeplay:AnimatedSprite;
    var options:AnimatedSprite;

    var curSelected:Int = 0;

    override function init() {
        super.init();
        
        bg = new Bitmap(Res.images.mainMenu.menuBG.toTile());
        s2d.addChild(bg);

        moveSelection(NONE);

        for (i in 0...3) {
            var menuOption:AnimatedSprite = new AnimatedSprite(0, 225 * i, Res.images.mainMenu.mainMenu_png.toTile(), "res/images/mainMenu/mainMenu.xml");
            switch (i) {
                case 0:
                    menuOption.addAnimation("idle", "story");
                    menuOption.addAnimation("selected", "story small");
                case 1:
                    menuOption.addAnimation("idle", "freeplay");
                    menuOption.addAnimation("selected", "freeplay small");
                case 2:
                    menuOption.addAnimation("idle", "options");
                    menuOption.addAnimation("selected", "options small");
            }
            menuOption.playAnimation("idle");
            menuOption.x = (Window.getInstance().width - menuOption.animation.getFrame().width) / 2;
            // for (frame in 0...menuOption.animation.frames.length)
            //     menuOption.animation.frames[frame].setCenterRatio();
            menuOptions.push(menuOption);
        }

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
        super.update(dt);
    }

    function moveSelection(direction:Direction) {
        if (direction != NONE)
            direction == UP ? curSelected-- : curSelected++;
        for (i in 0...menuOptions.length) {
            if (i == curSelected)
                menuOptions[curSelected].playAnimation("selected");
            else menuOptions[i].playAnimation("idle");
        }
    }
}