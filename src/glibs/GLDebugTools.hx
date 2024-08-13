package glibs;

import hxd.Key;
import h2d.Object;

/**
 * Contains utils for moving objects, getting positions, scales, etc.
 * This exists purely because I got tired of copy pasting the same functions over and over again.
 * Its kind of ass but it gets the job done.
 */
class GLDebugTools {
    /**
     * Move an `Object` by a `moveAmount` amount using `movementKeys`
     * @param object The object you want to move
     * @param moveAmount The amount of pixels the object will move. Holding SHIFT will make the object move 10x further
     */
    public static function moveItem(object:Object, moveAmount:Float = 2) {
        if (Key.isPressed(Key.LEFT)){
            object.x -= (Key.isDown(Key.SHIFT)) ? moveAmount * 10 : moveAmount;
            trace('x: ${object.x} | y: ${object.y}');
        }
        if (Key.isPressed(Key.DOWN)){
            object.y += (Key.isDown(Key.SHIFT)) ? moveAmount * 10 : moveAmount;
            trace('x: ${object.x} | y: ${object.y}');
        }
        if (Key.isPressed(Key.UP)){
            object.y -= (Key.isDown(Key.SHIFT)) ? moveAmount * 10 : moveAmount;
            trace('x: ${object.x} | y: ${object.y}');
        }
        if (Key.isPressed(Key.RIGHT)){
            object.x += (Key.isDown(Key.SHIFT)) ? moveAmount * 10 : moveAmount;
            trace('x: ${object.x} | y: ${object.y}');
        }
    }
    /**
     * 
     * Rotates an `Object`
     * @param object The object you want to rotate.
     * @param rotationAmount The amount the object will rotate. By default, this is 2
     */
    public static function rotateItem(object:Object, rotationAmount:Int = 2) {
        if (Key.isPressed(Key.Q)) {
            object.rotation -= rotationAmount;
            trace('angle: ${object.rotation}');
        }
        if (Key.isPressed(Key.E)) {
            object.rotation += rotationAmount;
            trace('angle: ${object.rotation}');
        }
    }

    public static function scaleItem(object:Object, scaleAmount:Float = 0.1) {
        if (Key.isPressed(Key.Q)) {
            object.scaleX -= scaleAmount;
            object.scaleY -= scaleAmount;
            trace('scale: ${object.scaleX}'); // Works because you're adjusting both the x and y scale, so you can use either of them
        }
        if (Key.isPressed(Key.E)) {
            object.scaleX += scaleAmount;
            object.scaleY += scaleAmount;
            trace('scale: ${object.scaleX}');
        }
    }
}