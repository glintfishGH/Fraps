package backend;

import hxd.Key;

typedef Keybind = Array<Int>; 

class Controls {
    public function new() {}
    var keyMap:Map<String, Keybind> = [
        "left" =>   [Key.D],
        "down" =>   [Key.F],
        "up" =>     [Key.J],
        "right" =>  [Key.K],
        "accept" => [Key.ENTER, Key.SPACE],
        "back" =>   [Key.ESCAPE]
    ];

    public function keyPressed(key:String) {
        for (i in 0...keyMap.get(key).length) {
            if (Key.isPressed(keyMap.get(key)[i])) return true;
        }
        return false;
    }    
}