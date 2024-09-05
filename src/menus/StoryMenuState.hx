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

    /**
     * Used for loading the thumbnails
     */
    var weekNums:Array<Int> = [0, 1, 2, 7];

    /**
     * Background colors
     */
    var weekColors:Array<Int> = [0xFFb588ff, 0xFFffacc5, 0xFF52b1a0, 0xFFbe84aa];

    /**
     * Songs to load. Based on curSelected
     */
    var songs:Array<String> = ["slasher", "high", "workaround", "fresh"];

    var thumbnails:TileGroup;
    var weekNumber:Bitmap;

    // Public due to weekNumber positioning.
    var bottomBar:Bitmap;

    public function new() {
        super();
        thumbnails = new TileGroup();
        
        for (i in 0...weekNums.length) {
            // Ugly but gets the job done.
            var bgToGet:String = 'storyMenu/week${weekNums[i]}bg';
            if (FileSystem.exists('res/images/storyMenu/week${weekNums[i]}bg.png')) {
                var bitmapToPush:Bitmap = new Bitmap(Paths.image(bgToGet));
                thumbnails.add(bitmapToPush.getSize().width * i, 0, bitmapToPush.tile);
            }
        }
        // thumbnails.invalidate();
        addObj(thumbnails);

        var topBar:Bitmap = new Bitmap(GLGU.makeTile(0, 0, window.width, 120));
        addObj(topBar);

        var topBarTrans:Bitmap = new Bitmap(GLGU.makeTile(0, topBar.getSize().height, window.width, 12));
        topBarTrans.y = topBar.getSize().height; // no clue why this has to be set on a separate line
        topBarTrans.alpha = 0.5;
        addObj(topBarTrans);

        bottomBar = new Bitmap(GLGU.makeTile(0, 0, window.width, 120));
        bottomBar.y = window.height - bottomBar.getSize().height;
        addObj(bottomBar);

        var bottomBarTrans:Bitmap = new Bitmap(GLGU.makeTile(0, 0, window.width, 12));
        bottomBarTrans.y = bottomBar.y - bottomBarTrans.getSize().height;
        bottomBarTrans.alpha = 0.5;
        addObj(bottomBarTrans);

        weekNumber = new Bitmap(Paths.image('storyMenu/week$curSelected'));
        screenCenter(weekNumber, X);
        weekNumber.y = bottomBar.y + (bottomBar.getSize().height - weekNumber.getSize().height) / 2;
        addObj(weekNumber);

        changeBGColor();
    }

    override function update(dt:Float) {
        super.update(dt);

        pressKey();

        if (Key.isPressed(Key.ENTER)) {
            PlayState.curSong = songs[curSelected];
            if (TitleState.song != null) TitleState.song.pause = true;
            changeScene(new PlayState());
            // if (PlayState.assetCheck()) {
            //     if (TitleState.song != null) TitleState.song.pause = true;
            //     changeScene(new PlayState());
            // }
            // else GLogger.error("Tried loading into a song with invalid data!");
        }
    }

    function pressKey() {
        if (Key.isPressed(Key.A) || Key.isPressed(Key.LEFT)) {
            curSelected--;
            thumbnails.x += 1280;

            changeBGColor();
            changeWeekNumber();
        }

        if (Key.isPressed(Key.D) || Key.isPressed(Key.RIGHT)) {
            curSelected++;
            thumbnails.x -= 1280;

            changeBGColor();
            changeWeekNumber();
        }

        if (curSelected > thumbnails.count() - 1) {
            curSelected = 0;
            thumbnails.x = 0;

            changeBGColor();
            changeWeekNumber();
        }

        if (curSelected < 0) {
            trace("curselected is under 0");
            curSelected = 3;
            thumbnails.x = (thumbnails.count() - 1) * -1280;

            changeBGColor();
            changeWeekNumber();
        }
    }

    /**
     * TODO: Change this so it doesnt update the tile every single fucking frame
     */
    function changeWeekNumber() {
        weekNumber.tile = Paths.image('storyMenu/week${weekNums[curSelected]}', true);
        screenCenter(weekNumber, X);
        weekNumber.y = bottomBar.y + (bottomBar.getSize().height - weekNumber.getSize().height) / 2;
    }
    
    function changeBGColor() {
        Main.ME.engine.backgroundColor = weekColors[curSelected];
    }
}