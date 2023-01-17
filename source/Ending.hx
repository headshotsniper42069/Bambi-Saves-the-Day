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
    public function new(type:String = "worst")
    {
        endingtype = type;
        super();
    }
    override public function create()
    {
        super.create();
        endingimage = new FlxSprite(0, 0);
        endingimage.loadGraphic(Paths.image('strikeback/endings/' + endingtype + ' ending', 'shared'));
        endingscreenshot = new FlxSprite(0, 0);
        endingscreenshot.pixels = Laughing.screenshit.bitmapData;
        endingscreenshot.antialiasing = true;
        add(endingimage);
        add(endingscreenshot);
        FlxG.sound.playMusic(Paths.music(endingtype + 'Ending'));
    //    endingscreenshot.setPosition(26, -84);
    //    endingscreenshot.scale.set(0.56, 0.56);
        FlxTween.tween(endingscreenshot, {x: 26, y: -84}, 0.75, {ease:FlxEase.quintOut});
        FlxTween.tween(endingscreenshot.scale, {x: 0.56, y: 0.56}, 0.75, {ease:FlxEase.quintOut});
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FlxG.keys.pressed.DOWN)
            endingscreenshot.scale.set(endingscreenshot.scale.x - 0.001, endingscreenshot.scale.y - 0.001);
        if (FlxG.keys.pressed.UP)
            endingscreenshot.scale.set(endingscreenshot.scale.x + 0.001, endingscreenshot.scale.y + 0.001);
        if (FlxG.keys.pressed.D)
            endingscreenshot.x += 1;
        if (FlxG.keys.pressed.A)
            endingscreenshot.x -= 1;
        if (FlxG.keys.pressed.W)
            endingscreenshot.y -= 1;
        if (FlxG.keys.pressed.S)
            endingscreenshot.y += 1;
        trace(endingscreenshot.x);
        trace(endingscreenshot.y);
        trace(endingscreenshot.scale.x);
        trace(endingscreenshot.scale.y);
    }
}