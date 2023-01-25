import Discord.DiscordClient;
import flixel.addons.plugin.screengrab.FlxScreenGrab;
import openfl.geom.Rectangle;
import openfl.display.Bitmap;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class Ending extends MusicBeatState
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
        endingimage.loadGraphic(Paths.image('strikeback/endings/' + endingtype.toLowerCase() + ' ending', 'shared'));
        endingscreenshot = new FlxSprite(0, 0);
        endingscreenshot.pixels = Laughing.screenshit.bitmapData;
        endingscreenshot.antialiasing = true;
        add(endingimage);
        FlxG.sound.playMusic(Paths.music(endingtype.toLowerCase() + 'Ending'));
        add(endingscreenshot);
        FlxTween.tween(endingscreenshot, {x: 26, y: -84}, 0.75, {ease:FlxEase.quintOut});
        FlxTween.tween(endingscreenshot.scale, {x: 0.56, y: 0.56}, 0.75, {ease:FlxEase.quintOut});
        DiscordClient.changePresence("In the Endings Screen: " + endingtype + ' Ending', null);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if ((FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE) && endingtype == "Worst")
        {
            FlxG.sound.music.stop();
            FlxG.switchState(new PlayState());
        }
        if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.SPACE && endingtype != "Worst" || FlxG.keys.justPressed.ENTER && endingtype != "Worst")
        {
            FlxG.sound.music.stop();
            PlayState.retrying = false;
            FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
            FlxG.switchState(new MainMenuState());
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