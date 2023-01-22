import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class LoadingTextState extends FlxState
{
    var nextstate:FlxState;
    var loading:FlxText;
    var elapsedtime:Float;
    public function new(state:FlxState)
    {
        super();
        nextstate = state;
    }

    override public function create()
    {
        loading = new FlxText(0, 0, 0, "Loading...", 24);
        loading.font = Paths.font("opensans.ttf");
        loading.screenCenter();
        add(loading);
        super.create();
    }

    override public function update(elapsed:Float)
    {
        elapsedtime += elapsed;
        if (elapsedtime >= 0.05)
        {
            FlxG.switchState(nextstate);
        }
        super.update(elapsed);
    }
}