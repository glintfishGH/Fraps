import sys.FileSystem;
import h2d.Video;
import backend.MusicBeatState;

class InitState extends MusicBeatState {
    override function init() {
        super.init();
        new TitleState();
    }
}