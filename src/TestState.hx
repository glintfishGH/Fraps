import h3d.prim.Cylinder;
import h3d.prim.Plane2D;
import h3d.prim.Cube;
import glibs.GLDebugTools;
import objects.Sprite;
import glibs.GLogger;
import backend.Paths;
import backend.MusicBeatState;
import hxd.Key;
import h3d.scene.Mesh;

class TestState extends MusicBeatState {
    var mesh:Mesh;

    var muh:Sprite;

    var note:Strumnote;
    public function new() {
        super();
        var cube:Cube = new Cube(1, 1, 1);
        cube.addUVs();
        cube.addNormals();
        cube.translate(-0.5, -0.5, -0.5);
        var tex = hxd.Res.images.glint.toTexture();

        var mat = h3d.mat.Material.create(tex);
        mat.shadows = false;

        mesh = new Mesh(cube, mat, Main.ME.s3d);
        mesh.setRotation(0, 0, 0);
        // Yes this was copied off the heaps tutorial page

        Main.ME.engine.backgroundColor = 0xFFE4FF8B;
        // Main.ME.s3d.addChild(mesh);

        note = new Strumnote(640, 360, Paths.image("images/gameplay/NOTE_assets"), "res/images/gameplay/NOTE_assets", "Left");
        screenCenter(note, XY);
        addChild(note);
    }

    override function update(dt:Float) {
        note.update(dt);

        mesh.rotate(5 * dt, 2 * dt, 2.663 * dt);

        if (Key.isPressed(Key.LEFT)) {
            note.noteToDisplay = "Left";
            note.playStrumAnim("Left", true);
        }
        if (Key.isPressed(Key.DOWN)) {
            note.noteToDisplay = "Down";
            note.playStrumAnim("Down", true);
        }
        if (Key.isPressed(Key.UP)) {
            note.noteToDisplay = "Up";
            note.playStrumAnim("Up", true);
        }
        if (Key.isPressed(Key.RIGHT)) {
            note.noteToDisplay = "Right";
            note.playStrumAnim("Right", true);
        }
        
        if (Key.isPressed(Key.SPACE))
            changeScene(new MainMenuState());
    }
}