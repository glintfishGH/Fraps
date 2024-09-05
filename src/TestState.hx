import h3d.Camera;
import h3d.scene.CameraController;
import h3d.prim.Cube;
import objects.Sprite;
import glibs.GLogger;
import backend.MusicBeatState;
import hxd.Key;
import h3d.scene.Mesh;

/**
 * Fuck-off state where i test out stuff.
 * Playground kinda deal.
 */
class TestState extends MusicBeatState {
    var mesh:Mesh;
    var cameraController:CameraController;
    var s3dCamera:Camera;

    var followTarget:Mesh;

    var muh:Sprite;

    var note:Strumnote;
    public function new() {
        super();
        s3dCamera = Main.ME.s3d.camera;
        var cube:Cube = new Cube();
        cube.addUVs();
        cube.addNormals();
        cube.translate(-0.5, -0.5, -0.5);
        var tex = hxd.Res.images.glint.toTexture();

        var mat = h3d.mat.Material.create(tex);
        mat.shadows = false;

        mesh = new Mesh(cube, mat, Main.ME.s3d);
        mesh.setRotation(0, 0, 0);

        followTarget = mesh;
        
        // Yes this was copied off the heaps tutorial page

        Main.ME.engine.backgroundColor = 0xFFE4FF8B;
        Main.ME.s3d.addChild(mesh);

        s3dCamera.up.set(mesh.x, mesh.y, mesh.z);
        // s3dCamera.follow.pos = mesh;
        // s3dCamera.follow.target = mesh;
    }

    override function update(dt:Float) {

        var penis:Float = 5 * dt;

        GLogger.info(s3dCamera.pos);

        if (Key.isDown(Key.LEFT)) {
            mesh.x -= penis;
            // s3dCamera.up.add();
        }
        if (Key.isDown(Key.DOWN)) {
            mesh.z -= penis;
        }
        if (Key.isDown(Key.UP)) {
            mesh.z += penis;
        }
        if (Key.isDown(Key.RIGHT)) {
            mesh.x += penis;
        }

        if (Key.isDown(Key.A)) {
            mesh.y -= penis;
        }
        if (Key.isDown(Key.D)) {
            mesh.y += penis;
        }
        
        if (Key.isPressed(Key.SPACE))
            changeScene(new MainMenuState());
    }
}