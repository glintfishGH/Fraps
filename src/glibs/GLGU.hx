package glibs;

class GLGU {
    static var stamp:Float;

    /**
     * WARNING: This is mostly inaccurate when targeting HL
     */
    public static function startStamp() {
        stamp = Sys.time();
    }

    /**
     * WARNING: This is mostly inaccurate when targeting HL
     */
    public static function endStamp() {
        trace('Finished process (${Sys.time() - stamp})');
    }
}