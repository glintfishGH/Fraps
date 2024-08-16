import backend.MusicBeatState;
import h3d.mat.BlendMode;
import h3d.mat.Material;
import hxd.Key;
import h3d.scene.Mesh;
import h3d.prim.Cube;
import hxd.App;

class TestState extends MusicBeatState {
    var mesh:Mesh;
    public function new() {
        super();
        var cube:Cube = new Cube();
        cube.translate(-0.5, -0.5, -0.5);
        cube.addUVs();
        cube.addNormals();
        var tex = hxd.Res.images.glint.toTexture();

        var mat = h3d.mat.Material.create(tex);

        mesh = new Mesh(cube, mat, Main.ME.s3d);
        Main.ME.s3d.addChild(mesh);

        // Yes this was copied off the heaps tutorial page
    }

    override function update(dt:Float) {
        if (Key.isPressed(Key.SPACE))
            changeScene(new PlayState());
    }
}