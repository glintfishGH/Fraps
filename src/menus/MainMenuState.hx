package menus;

import backend.Paths;
import hxd.Key;
import hxd.Window;
import objects.AnimatedSprite;
import hxd.Res;
import h2d.Bitmap;
import backend.MusicBeatState;

enum Direction {
    UP;
    DOWN;
    NONE;
}

class MainMenuState extends MusicBeatState {
    var bg:Bitmap;

    var optionsArray:Array<String> = ["story", "freeplay", "options"];

    var menuOptions:Array<AnimatedSprite> = [];
    var storyMode:AnimatedSprite;
    var freeplay:AnimatedSprite;
    var options:AnimatedSprite;

    var curSelected:Int = 0;

    public function new() {
        super();

        bg = new Bitmap(Paths.image("mainMenu/menuBG"));
        addObj(bg);

        for (i in 0...3) {
            var menuOption:AnimatedSprite = new AnimatedSprite(0, 50 + 225 * i, Res.images.mainMenu.mainMenu_png.toTile());
            menuOption.addAnimation("idle", '${optionsArray[i]} small');
            menuOption.addAnimation("selected", '${optionsArray[i]}');
            menuOption.playAnimation("idle");

            if (i == 0) menuOption.setScale(0.75);

            menuOption.x = (Window.getInstance().width - menuOption.getBounds().width) / 2;
            menuOptions.push(menuOption);
            addObj(menuOptions[i]);
        }

        moveSelection(NONE);
    }

    override function update(dt:Float) {
        super.update(dt);
        if (Key.isPressed(Key.DOWN)) moveSelection(DOWN);

        if (Key.isPressed(Key.UP)) moveSelection(UP);

        if (Key.isPressed(Key.ENTER)) {
            // if (TitleState.song != null) TitleState.song.pause = true;
            changeScene(new StoryMenuState());
        }
    }

    function moveSelection(direction:Direction) {
        GLGU.playSound("scrollMenu");
        if (direction != NONE) direction == UP ? curSelected-- : curSelected++;
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