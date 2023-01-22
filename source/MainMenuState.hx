package;

import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxText>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
/*	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		#if !switch 'donate', #end
		'options'
	]; */

	var optionShit:Array<String> = [
		'story_mode',
		'options',
		'credits'
	];

	var optionText:Array<String> = [
		'Start',
		'Settings',
		'Credits',
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var canpress:Bool = false;
	var text1white:Bool = true;
	var text2white:Bool = true;
	var text3white:Bool = true;
	var rectangle:FlxSprite;

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		
		// magenta.scrollFactor.set();

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		rectangle = new FlxSprite(-80, -100);
		rectangle.makeGraphic(350, 950, FlxColor.BLACK);
		rectangle.updateHitbox();
	//	rectangle.antialiasing = true;
		rectangle.angle = 350;
		add(rectangle);

		menuItems = new FlxTypedGroup<FlxText>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxText = new FlxText(100, 250 + (i * 150), 0, optionText[i], 26);
			menuItem.font = Paths.font('opensans.ttf');
			menuItem.ID = i;
			menuItems.add(menuItem);
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

	//	changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		FlxG.mouse.visible = true;
		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8 && !selectedSomethin)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
	//	camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin && iseverythingwhite() == false)
		{
			if (FlxG.mouse.justPressed)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					var optionselected:String = optionShit[curSelected];
					if (optionselected == 'story_mode')
						FlxG.sound.music.fadeOut(1, 0);

					menuItems.forEach(function(spr:FlxText)
					{
						FlxTween.tween(spr, {alpha: 0, x: -100}, 0.5, {
							ease: FlxEase.cubeOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
						new FlxTimer().start(1, function(thefunny:FlxTimer)
						{
							var daChoice:String = optionShit[curSelected];
							switch (daChoice)
							{
								case 'story_mode':
									PlayState.SONG = Song.loadFromJson('strikeback', 'strikeback');
									LoadingState.loadAndSwitchState(new PlayState(), true);
								case 'credits':
									MusicBeatState.switchState(new CreditsState());
								case 'options':
									LoadingState.loadAndSwitchState(new options.OptionsState());
							}
						});
					});
					FlxTween.tween(rectangle, {x: -450}, 0.5, {
						ease: FlxEase.cubeOut
					});
				}
			}
		}
		#if desktop
		if (FlxG.keys.anyJustPressed(debugKeys) && !selectedSomethin)
		{
			selectedSomethin = true;
			MusicBeatState.switchState(new MasterEditorMenu());
		}
		#end

		menuItems.forEach(function(text:FlxText)
		{
			if (FlxG.mouse.overlaps(text))
			{
				curSelected = text.ID;
				trace(text.ID);
				if (curSelected == text.ID)
				{
					text.color = 0xFFE100;
					switch (text.ID)
					{
						case 0:
							text1white = false;
						case 1:
							text2white = false;
						case 2:
							text3white = false;
					}
				}
			}
			else
			{
				text.color = 0xFFFFFF;
			}
			if (text.color == 0xFFFFFF)
			{
				trace(text.ID + " is white");
				switch (text.ID)
				{
					case 0:
						text1white = true;
					case 1:
						text2white = true;
					case 2:
						text3white = true;
				}
			}
		});
		super.update(elapsed);
	}
	function iseverythingwhite():Bool
	{
		if (text1white && text2white && text3white)
			return true;
		else
			return false;
	}
}
