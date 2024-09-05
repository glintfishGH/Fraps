package backend;

/**
 * Layers used for the cameras. 
 * Heaps uses indexes to figure out which layers to render.
 * You don't necessarily have to use these, you can just use numbers, but it's recommended.
 * @see https://github.com/HeapsIO/heaps/blob/master/samples/Camera2D.hx
 */
class Layers {
    public static final layerGame:Int = 0;
    public static final layerUI:Int = 2;

    /**
     * You'll likely never reach this amount of layers, but best be safe.
     */
    public static final layerTransition:Int = 99;

    /**
     * Used for FPS display.
     */
    public static final layerTop:Int = 100;

    /**
     * Idealy when you dont want a camera to be used.
     */
    public static final layerNul:Int = 101;
}