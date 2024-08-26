package backend;

/**
 * TODO: Change this to allow for multiple conductor instances.
 */
class Conductor
{
	/**
	 * The BPM before it was changed.
	 */
	public static var lastBpm:Float = 0;

	/**
	 * The amount of steps to offset curStep.
	 */
	public static var curStepOffset:Float;
	
	/**
	 * Beats per minute.
	 */
	public static var bpm:Float = 120;

	/**
	 * Beats in miliseconds.
	 */
	public static var crochet:Float = ((60 / bpm) * 1000);

	/**
	 * Steps in miliseconds.
	 */
	public static var stepCrochet:Float = crochet / 4;
	
	/**
	 * Song position in miliseconds.
	 */
	public static var songPosition:Float;

	public static function changeBPM(new_bpm:Float) {
		lastBpm = bpm;
		bpm = new_bpm;
		stepCrochet = ((60 / bpm) * 1000);
	}
}