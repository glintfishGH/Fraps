package menus;

import glibs.GLGU;
import h2d.TileGroup;
import sys.FileSystem;
import hxd.Key;
import backend.Paths;
import h2d.Bitmap;
import backend.MusicBeatState;

class StoryMenuState extends MusicBeatState {
    var curSelected:Int = 0;
    var weekNums:Array<Int> = [0, 1, 2, 7];
    var weekColors:Array<Int> = [0xFFb588ff, 0xFFffacc5, 0xFF52b1a0, 0xFFbe84aa];
    var songs:Array<String> = ["bopeebo", "cocoa", "bopeebo", "cocoa"];
    var weekImages:TileGroup;
    var weekNumber:Bitmap;

    var bottomBar:Bitmap;

    public function new() {
        super();
        weekImages = new TileGroup();
        
        for (i in 0...weekNums.length) {
            var bgToGet:String = 'images/storyMenu/week${weekNums[i]}bg';
            if (FileSystem.exists('res/images/storyMenu/week${weekNums[i]}bg.png')) {
                var bitmapToPush:Bitmap = new Bitmap(Paths.image(bgToGet));
                weekImages.add(bitmapToPush.getSize().width * i, 0, bitmapToPush.tile);
            }
        }
        // weekImages.invalidate();
        addChild(weekImages);

        var topBar:Bitmap = GLGU.makeTile(0, 0, window.width, 120);
        addChild(topBar);

        var topBarTrans:Bitmap = GLGU.makeTile(0, topBar.getSize().height, window.width, 12);
        topBarTrans.alpha = 0.5;
        addChild(topBarTrans);

        bottomBar = GLGU.makeTile(0, 0, window.width, 120);
        bottomBar.y = window.height - bottomBar.getSize().height;
        addChild(bottomBar);

        var bottomBarTrans:Bitmap = GLGU.makeTile(0, 0, window.width, 12);
        bottomBarTrans.y = bottomBar.y - bottomBarTrans.getSize().height;
        bottomBarTrans.alpha = 0.5;
        addChild(bottomBarTrans);

        weekNumber = new Bitmap(Paths.image('images/storyMenu/week$curSelected'));
        screenCenter(weekNumber, X);
        weekNumber.y = bottomBar.y + (bottomBar.getSize().height - weekNumber.getSize().height) / 2;
        addChild(weekNumber);

        changeBGColor();
    }

    override function update(dt:Float) {
        super.update(dt);

        pressKey();

        if (Key.isPressed(Key.ENTER)) {
            if (TitleState.song != null) TitleState.song.pause = true;

            PlayState.curSong = songs[curSelected];
            changeScene(new PlayState());
        }
    }

    function pressKey() {
        if (Key.isPressed(Key.A) || Key.isPressed(Key.LEFT)) {
            curSelected--;
            weekImages.x += 1280;
        }

        if (Key.isPressed(Key.D) || Key.isPressed(Key.RIGHT)) {
            curSelected++;
            weekImages.x -= 1280;
        }

        if (curSelected > weekImages.count() - 1) {
            curSelected = 0;
            weekImages.x = 0;
        }

        if (curSelected < 0) {
            trace("curselected is under 0");
            curSelected = 3;
            weekImages.x = (weekImages.count() - 1) * -1280;
        }
        
        changeBGColor();
        changeWeekNumber();
    }

    function changeWeekNumber() {
        trace(curSelected);
        weekNumber.tile = Paths.image('images/storyMenu/week${weekNums[curSelected]}');
        screenCenter(weekNumber, X);
        weekNumber.y = bottomBar.y + (bottomBar.getSize().height - weekNumber.getSize().height) / 2;
    }
    
    function changeBGColor() {
        Main.ME.engine.backgroundColor = weekColors[curSelected];
    }
}