package backend;

class Conductor
{
	/**
	 * Beats per minute.
	 */
	public static var bpm:Float = 100;

	/**
	 * Beats in miliseconds.
	 */
	public static var crochet:Float = ((60 / bpm) * 1000);

	/**
	 * Steps in miliseconds.
	 */
	public static var stepCrochet:Float = crochet / 4;
	
	/**
	 * Song position in miliseconds
	 */
	public static var songPosition:Float;
}