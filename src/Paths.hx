class Paths{
    public static inline function image(key:String) {
        return Reflect.field(hxd.Res, key).toTile();
    }
}