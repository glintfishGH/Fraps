package objects;

import h2d.TileGroup;

using StringTools;

/**
 * This class fucking sucks.
 * It extends TileGroup which does not support animated objects, so all letters are static for now.
 */
 class Alphabet extends TileGroup {
    var characters:Array<AlphabetChar> = [];
    var distance:Float = 40;
    var fullDist:Float;
    var yOffset:Float = 0;
    public function new(letters:String) {
        super(Paths.image("alphabet"));
        for (i in 0...letters.length) {
            var letter = new AlphabetChar(letters.charAt(i));
            characters.push(letter);
            yOffset = characters[0].getLetter().height - letter.getLetter().height;
            distance = letter.getLetter().width;
            if (letter.char == " ") {
                distance = 40;
            }
            fullDist += distance;
            add(fullDist, yOffset, letter.getLetter());
        }
    }
}

/**
 * This class sucks even more.
 */
class AlphabetChar extends AnimatedSprite {
	public static var full:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890|~#$%()*+-:;<=>@[]^_.,'!?";

    public static var alphabet:String = "abcdefghijklmnopqrstuvwxyz";

	public static var numbers:String = "1234567890";

    var symbolReferences:Map<String, String> = [
        "#" => "hashtag",
        "$" => "dollarsign",
        "&" => "amp",
        "'" => "apostraphie",
        "," => "comma",
        "." => "period",
        "?" => "question mark",
        "!" => "exclamation point"
    ];
	public static var symbols:String = "|~#$%()*+-:;<=>@[]^_.,'!?";

    public var char:String;
    
    public function new(char:String) {
        super(0, 0, Paths.image("alphabet"));

        this.char = char;

        trace(char);

        for (i in 0...full.length) {
            if (char == full.charAt(i)) {
                for (j in 0...50) {
                    if (char == numbers.charAt(j)) {
                        createNumber();
                        break;
                    }

                    if (char == symbols.charAt(j)) {
                        createSymbol();
                        break;
                    }

                    if (char == alphabet.charAt(j).toUpperCase()) {
                        createBold();
                        break;
                    }
                    if (char == alphabet.charAt(j)) {
                        createLetter();
                        break;
                    }
                }
            }
        }

        if (animations.get(char) == null) {
            GLogger.warning("Char is an invalid character so we're gonna make it a space");
            addBlankAnimation(" ", 100, 50);
        }
    }

    function createSymbol() {
        if (symbolReferences.get(char) == null) addAnimation(char, char, null, true);
        else addAnimation(char, symbolReferences.get(char), null, true);

    }

    function createNumber() {
        addAnimation(char, char, null, true);
    }

    function createLetter() {
        addAnimation(char, char + " lowercase", null, true);
    }

    function createBold() {
        addAnimation(char.toUpperCase(), char.toUpperCase() + " bold", null, true);
    }

    public function getLetter() {
        return this.animations.get(char)[0];
    }
}