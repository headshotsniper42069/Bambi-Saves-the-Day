import flixel.addons.plugin.screengrab.FlxScreenGrab;
import openfl.geom.Rectangle;
import openfl.display.Bitmap;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class Ending extends FlxState
{
    var endingimage:FlxSprite;
    var endingscreenshot:FlxSprite;
    var endingtype:String;
    public static var ischeating:Bool = false;
    public function new(type:String = "worst", triedtocheat:Bool = false)
    {
        endingtype = type;
        ischeating = triedtocheat;
        super();
    }
    override public function create()
    {
        super.create();
        if (ischeating)
            new FlxTimer().start(2.5, function(pointandlaugh:FlxTimer){
                screenshotCurrent();
                FlxG.switchState(new Laughing());
            });
        endingimage = new FlxSprite(0, 0);
        endingimage.loadGraphic(Paths.image('strikeback/endings/' + endingtype + ' ending', 'shared'));
        if (!ischeating)
        {
            endingscreenshot = new FlxSprite(0, 0);
            endingscreenshot.pixels = Laughing.screenshit.bitmapData;
            endingscreenshot.antialiasing = true;
        }
        add(endingimage);
        FlxG.sound.playMusic(Paths.music(endingtype + 'Ending'));
        if (!ischeating)
        {
            add(endingscreenshot);
            FlxTween.tween(endingscreenshot, {x: 26, y: -84}, 0.75, {ease:FlxEase.quintOut});
            FlxTween.tween(endingscreenshot.scale, {x: 0.56, y: 0.56}, 0.75, {ease:FlxEase.quintOut});
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ENTER && !ischeating)
        {
            FlxG.sound.music.stop();
            FlxG.switchState(new PlayState());
        }
    }
    public function screenshotCurrent()
    {
        var screenshot:Bitmap;
        var rect:Rectangle = new Rectangle(0, 0, 1280, 720);
        screenshot = FlxScreenGrab.grab(null, false, false);
        Laughing.screenshit = screenshot;
    }
}