package backend;

typedef NoteData = {
    var time:Float;
    var strum:Int;
    var sustainLength:Float;
}

typedef SectionData = {
    var lengthInSteps:Int;
    var bpm:Float;
    var mustHitSection:Bool;
    var altAnim:Bool;
    var changeBPM:Bool;
}

typedef SongInfo = {
    var sectionData:SectionData;

    var boyfriend:String;
    var opponent:String;
    var girlfriend:String;

}