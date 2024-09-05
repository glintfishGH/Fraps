package backend;

typedef NoteData = {
    var time:Float;
    var strum:Int;
    var sustainLength:Int;
}

typedef SectionData = {
    var lengthInSteps:Int;
    var bpm:Float;
    var mustHitSection:Bool;
    var altAnim:Bool;
    var changeBPM:Bool;
}

typedef Events = {
    var time:Float;
    @:optional var event:String;
    var duration:Float;
    var character:Int;
}

typedef SongInfo = {
    var sectionData:SectionData;

    var player:String;
    var opponent:String;
    var girlfriend:String;

}