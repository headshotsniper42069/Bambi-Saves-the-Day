import flixel.FlxG;
import openfl.display.Bitmap;
import flixel.FlxState;
import flixel.FlxSprite;

class Laughing extends FlxState
{
    var laughing:FlxSprite;
    public static var screenshit:Bitmap;
    var screenshotsprite:FlxSprite;
    override public function create()
    {
        super.create();
        laughing = new FlxSprite(0, 0);
        laughing.frames = Paths.getSparrowAtlas('laughing', 'shared');
        laughing.animation.addByPrefix('laughing', 'laughing', 33, false);
        laughing.setGraphicSize(1280);
        laughing.updateHitbox();
        add(laughing);
        screenshotsprite = new FlxSprite(0, 0);
        screenshotsprite.pixels = screenshit.bitmapData;
        screenshotsprite.setGraphicSize(Std.int(screenshotsprite.width * 0.5));
        laughing.animation.play('laughing');
        add(screenshotsprite);
        screenshotsprite.antialiasing = true;
        screenshotsprite.setPosition(320, 180);
        FlxG.sound.play(Paths.sound('laughing', 'preload'), 1, false, null, false, function(){
            Sys.exit(0);
        });
    }
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}