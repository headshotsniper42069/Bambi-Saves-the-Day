import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class FakeTitleState extends FlxState
{
    var text:FlxText;
    override public function create()
    {
        super.create();
        text = new FlxText(0, 0, 0, "the title menu isnt finished so here's a cool song instead", 24);
        text.font = Paths.font("opensans.ttf");
        text.screenCenter();
        FlxG.sound.music.stop();
        FlxG.sound.play(Paths.music("sike", "preload"), 1, false, null, false, function(){
            FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
            FlxG.switchState(new MainMenuState());
        });
        add(text);
    }
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ENTER)
        {
            FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
			FlxG.switchState(new MainMenuState());
        }
    }
}