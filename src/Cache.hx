package;

class Cache extends MusicBeatState {
    var graphicsToCache:Array<String> = 
    [
        "characters/BOYFRIEND", "characters/DADDY_DEAREST",
        "gameplay/NOTE_assets",
        "menus/titleEnter"
    ];
    var cachedGraphics:Bool = false;

    public function new() {
        super();
        GLogger.info("Caching. . .");
        for (graphic in graphicsToCache) {
            Paths.image(graphic);
        }
        cachedGraphics = true;
    }

    override function update(dt:Float) {
        super.update(dt);
        if (cachedGraphics) changeScene(new TitleState());
    }
}