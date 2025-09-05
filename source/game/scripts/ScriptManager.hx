package game.scripts;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import game.desktop.DesktopMain;
import lime.app.Application;
#if sys
import sys.FileSystem;
import sys.io.File;
#else
import lime.utils.Assets;
#end

class ScriptManager
{
	public static var SCRIPT_FOLDER:String = 'scripts';

	public static var SCRIPT_EXTS:Array<String> = ['hxc', 'hx', 'haxe', 'hscript'];

	public static var SCRIPTS:Array<Iris> = [];
	public static var SCRIPTS_ERRS:Map<String, Dynamic> = [];

	public static function call(method:String, ?args:Array<Dynamic>)
	{
		if (SCRIPTS.length < 1)
			return;

		for (script in SCRIPTS)
		{
			callSingular(script, method, args);
		}
	}

	public static function callSingular(script:Iris, method:String, ?args:Array<Dynamic>)
	{
		@:privateAccess {
			if (!script.interp.variables.exists(method))
			{
				final errMsg = 'missing method(' + method + ') for script(' + script.config.name + ')';

				if (!SCRIPTS_ERRS.exists('missing_method(' + method + ')_' + script.config.name))
				{
					SCRIPTS_ERRS.set('missing_method(' + method + ')_' + script.config.name, errMsg);
					trace(errMsg);
				}

				return;
			}

			var ny:Dynamic = script.interp.variables.get(method);
			try
			{
				if (ny != null && Reflect.isFunction(ny))
				{
					script.call(method, args);
				}
			}
			catch (e)
			{
				final errMsg = 'error calling method(' + method + ') for script(' + script.config.name + '): ' + e.message;

				if (!SCRIPTS_ERRS.exists('method(' + method + ')_error_' + script.config.name))
				{
					SCRIPTS_ERRS.set('method(' + method + ')_error_' + script.config.name, errMsg);
					trace(errMsg);
				}
			}
		}
	}

	public static function loadAllScripts()
	{
		for (script in SCRIPTS)
		{
			script.destroy();
			SCRIPTS.remove(script);
		}
		SCRIPTS = [];

		#if (sys && debug)
		var print:String = '';
		var classes = [
			funkin.util.macro.ClassMacro.listClassesInPackage('flixel'),
			funkin.util.macro.ClassMacro.listClassesInPackage('lime'),
			funkin.util.macro.ClassMacro.listClassesInPackage('openfl')
		];
		var classNames = ['flixel', 'lime', 'openfl'];
		var bannedContains = [
			'_',

			// flixel
			'FlxBasePoint',
			'FlxTimerManager',
			'LabelValuePair',
			'FlxTypedButton',
			'FlxTweenManager',
			'ScrollBar',
			'GraphicLogo',
			'VirtualInputData',
			'GraphicVirtualInput',
			'FlxTypedPathfinderData',
			'FlxDiagonalPathfinder',
			'FlxTypedPathfinder',
			'FlxPathDrawData',
			'FlxTypedBasePath',
			'FlxCallbackPoint',
			'FlxTypedGamepadMapping',
			'FlxTypedGamepadAnalogStick',
			'FlxTypedSpriteGroup',
			'FlxTypedGroupIterator',
			'BMFontSpacing',
			'BMFontPadding',
			'FlxTypedEmitter',
			'FlxTypedGroup',
			'FlxTypedContainer',
			'DebugWindowsFrontEnd',
			'DebugToolsFrontEnd',
			'TooltipOverlay',
			'Footer',
			'Header',
			'WatchBase',
			'TrackerProfile',
			'FlxTextFormat',
			'FlxTextFormatMarkerPair',
			'flixel.tile.Graphic',
			'FlxTypedTilemap',

			// openfl
			'ByteArrayData',
			'DefaultPreloader',
			'TileData',
			'openfl.display3D.Uniform',

			// lime
			'HTTPRequest',
			'lime.system.JNI',
			'lime.system.Job',
			'JSAsync',
			'ArrayBufferIO',
			'lime.app.FutureWork',
			'lime.app.Event',
			'GLObject',
			'CairoMatrix3',
			'BytePointerData'

		];
		var index = 0;

		for (classGrp in classes)
		{
			print += '';
			for (cls in classGrp)
			{
				if (cls == null)
					continue;
				var className:String = Type.getClassName(cls);

				var passed = 0;

				for (contain in bannedContains)
				{
					if (StringTools.contains(className, contain))
					{
						trace('ignored (' + contain + ')' + className);
						passed--;
					}
				}

				if (passed == 0)
					print += 'script.set(\'' + className + '\', ' + className + ');';
			}
			index++;
		}
		Sys.println(print);
		#end
		loadScriptsByPaths(getAllScriptPaths(SCRIPT_FOLDER));

		call('onAdded');
	}

	public static function loadScriptByPath(path:String)
	{
		var newScript:Iris;

		var noExt:Int = 0;
		for (ext in SCRIPT_EXTS)
		{
			if (!StringTools.endsWith(path, '.' + ext))
				noExt++;
		}
		if (noExt >= SCRIPT_EXTS.length)
			return;

		try
		{
			newScript = new Iris(#if sys File.getContent(path) #else Assets.getText(path) #end, new IrisConfig(path, true, true, []));
		}
		catch (e)
		{
			newScript = null;
			trace('Error loading script(' + path + '): ' + e.message);
			Application.current.window.alert('Error loading script(' + path + '): ' + e.message + '\n\n' + e.details, 'Error loading script');
		}

		if (newScript != null)
		{
			initalizeScriptVariables(newScript);

			trace('Loaded script($path)');

			SCRIPTS.push(newScript);
			// callSingular(newScript, 'onAdded');
		}
	}

	public static function initalizeScriptVariables(script:Iris)
	{
		script.set('ScriptManager', ScriptManager, false);

		script.set('DesktopMain', DesktopMain, false);
		script.set('InitState', InitState, false);

		script.set('Paths', Paths, false);

		scriptImports(script);
	}

	public static function loadScriptsByPaths(paths:Array<String>)
	{
		for (path in paths)
			loadScriptByPath(path);
	}

	public static function getAllScriptPaths(script_folder:String):Array<String>
	{
		#if sys
		var typePaths:Array<String> = [Paths.getGamePath('scripts/'), 'game/scripts/', 'game/'];

		return Paths.getTypeArray('script', 'scripts', SCRIPT_EXTS, typePaths);
		#else
		return [];
		#end
	}

	public static function scriptImports(script:Iris)
	{
		script.set('flixel.util.helpers.FlxRangeBounds', flixel.util.helpers.FlxRangeBounds);
		script.set('flixel.util.helpers.FlxRange', flixel.util.helpers.FlxRange);
		script.set('flixel.util.helpers.FlxPointRangeBounds', flixel.util.helpers.FlxPointRangeBounds);
		script.set('flixel.util.helpers.FlxBounds', flixel.util.helpers.FlxBounds);
		script.set('flixel.util.FlxTimer', flixel.util.FlxTimer);
		script.set('flixel.util.FlxStringUtil', flixel.util.FlxStringUtil);
		script.set('flixel.util.FlxSpriteUtil', flixel.util.FlxSpriteUtil);
		script.set('flixel.util.FlxSort', flixel.util.FlxSort);
		script.set('flixel.util.FlxGradient', flixel.util.FlxGradient);
		script.set('flixel.util.FlxDestroyUtil', flixel.util.FlxDestroyUtil);
		script.set('flixel.util.FlxColorTransformUtil', flixel.util.FlxColorTransformUtil);
		script.set('flixel.util.FlxCollision', flixel.util.FlxCollision);
		script.set('flixel.util.FlxBitmapDataUtil', flixel.util.FlxBitmapDataUtil);
		script.set('flixel.util.FlxBitmapDataPool', flixel.util.FlxBitmapDataPool);
		script.set('flixel.util.FlxArrayUtil', flixel.util.FlxArrayUtil);
		script.set('flixel.ui.FlxButton', flixel.ui.FlxButton);
		script.set('flixel.ui.FlxBar', flixel.ui.FlxBar);
		script.set('flixel.tweens.motion.QuadPath', flixel.tweens.motion.QuadPath);
		script.set('flixel.tweens.motion.QuadMotion', flixel.tweens.motion.QuadMotion);
		script.set('flixel.tweens.motion.LinearPath', flixel.tweens.motion.LinearPath);
		script.set('flixel.tweens.motion.LinearMotion', flixel.tweens.motion.LinearMotion);
		script.set('flixel.tweens.motion.CubicMotion', flixel.tweens.motion.CubicMotion);
		script.set('flixel.tweens.motion.CircularMotion', flixel.tweens.motion.CircularMotion);
		script.set('flixel.tweens.motion.Motion', flixel.tweens.motion.Motion);
		script.set('flixel.tweens.misc.VarTween', flixel.tweens.misc.VarTween);
		script.set('flixel.tweens.misc.ShakeTween', flixel.tweens.misc.ShakeTween);
		script.set('flixel.tweens.misc.NumTween', flixel.tweens.misc.NumTween);
		script.set('flixel.tweens.misc.FlickerTween', flixel.tweens.misc.FlickerTween);
		script.set('flixel.tweens.misc.ColorTween', flixel.tweens.misc.ColorTween);
		script.set('flixel.tweens.misc.AngleTween', flixel.tweens.misc.AngleTween);
		script.set('flixel.tweens.FlxTween', flixel.tweens.FlxTween);
		script.set('flixel.tweens.FlxEase', flixel.tweens.FlxEase);
		script.set('flixel.tile.FlxTilemapBuffer', flixel.tile.FlxTilemapBuffer);
		script.set('flixel.tile.FlxTilemap', flixel.tile.FlxTilemap);
		script.set('flixel.tile.FlxTileblock', flixel.tile.FlxTileblock);
		script.set('flixel.tile.FlxTile', flixel.tile.FlxTile);
		script.set('flixel.tile.FlxBaseTilemap', flixel.tile.FlxBaseTilemap);
		script.set('flixel.text.FlxInputTextManager', flixel.text.FlxInputTextManager);
		script.set('flixel.text.FlxInputText', flixel.text.FlxInputText);
		script.set('flixel.text.FlxText', flixel.text.FlxText);
		script.set('flixel.system.ui.FlxSystemButton', flixel.system.ui.FlxSystemButton);
		script.set('flixel.system.ui.FlxSoundTray', flixel.system.ui.FlxSoundTray);
		script.set('flixel.system.ui.FlxFocusLostScreen', flixel.system.ui.FlxFocusLostScreen);
		script.set('flixel.system.replay.MouseRecord', flixel.system.replay.MouseRecord);
		script.set('flixel.system.replay.CodeValuePair', flixel.system.replay.CodeValuePair);
		script.set('flixel.system.macros.FlxMacroUtil', flixel.system.macros.FlxMacroUtil);
		script.set('flixel.system.frontEnds.VCRFrontEnd', flixel.system.frontEnds.VCRFrontEnd);
		script.set('flixel.system.frontEnds.SoundFrontEnd', flixel.system.frontEnds.SoundFrontEnd);
		script.set('flixel.system.frontEnds.PluginFrontEnd', flixel.system.frontEnds.PluginFrontEnd);
		script.set('flixel.system.debug.watch.WatchEntry', flixel.system.debug.watch.WatchEntry);
		script.set('flixel.system.debug.watch.Tracker', flixel.system.debug.watch.Tracker);
		script.set('flixel.system.debug.watch.Watch', flixel.system.debug.watch.Watch);
		script.set('flixel.system.debug.watch.EditableTextField', flixel.system.debug.watch.EditableTextField);
		script.set('flixel.system.debug.stats.StatsGraph', flixel.system.debug.stats.StatsGraph);
		script.set('flixel.system.debug.stats.Stats', flixel.system.debug.stats.Stats);
		script.set('flixel.system.debug.log.LogStyle', flixel.system.debug.log.LogStyle);
		script.set('flixel.system.debug.log.Log', flixel.system.debug.log.Log);
		script.set('flixel.system.debug.log.BitmapLog', flixel.system.debug.log.BitmapLog);
		script.set('flixel.system.debug.interaction.tools.Transform', flixel.system.debug.interaction.tools.Transform);
		script.set('flixel.system.debug.interaction.tools.TrackObject', flixel.system.debug.interaction.tools.TrackObject);
		script.set('flixel.system.debug.interaction.tools.ToggleBounds', flixel.system.debug.interaction.tools.ToggleBounds);
		script.set('flixel.system.debug.interaction.tools.Pointer', flixel.system.debug.interaction.tools.Pointer);
		script.set('flixel.system.debug.interaction.tools.Mover', flixel.system.debug.interaction.tools.Mover);
		script.set('flixel.system.debug.interaction.tools.LogBitmap', flixel.system.debug.interaction.tools.LogBitmap);
		script.set('flixel.system.debug.interaction.tools.Eraser', flixel.system.debug.interaction.tools.Eraser);
		script.set('flixel.system.debug.interaction.tools.Tool', flixel.system.debug.interaction.tools.Tool);
		script.set('flixel.system.debug.interaction.Interaction', flixel.system.debug.interaction.Interaction);
		script.set('flixel.system.debug.console.ConsoleUtil', flixel.system.debug.console.ConsoleUtil);
		script.set('flixel.system.debug.console.ConsoleHistory', flixel.system.debug.console.ConsoleHistory);
		script.set('flixel.system.debug.console.ConsoleCommands', flixel.system.debug.console.ConsoleCommands);
		script.set('flixel.system.debug.console.Console', flixel.system.debug.console.Console);
		script.set('flixel.system.debug.completion.CompletionListEntry', flixel.system.debug.completion.CompletionListEntry);
		script.set('flixel.system.debug.completion.CompletionList', flixel.system.debug.completion.CompletionList);
		script.set('flixel.system.debug.completion.CompletionHandler', flixel.system.debug.completion.CompletionHandler);
		script.set('flixel.system.debug.Window', flixel.system.debug.Window);
		script.set('flixel.system.debug.VCR', flixel.system.debug.VCR);
		script.set('flixel.system.debug.Tooltip', flixel.system.debug.Tooltip);
		script.set('flixel.system.debug.ScrollSprite', flixel.system.debug.ScrollSprite);
		script.set('flixel.system.debug.Icon', flixel.system.debug.Icon);
		script.set('flixel.system.debug.FlxDebugger', flixel.system.debug.FlxDebugger);
		script.set('flixel.system.debug.DebuggerUtil', flixel.system.debug.DebuggerUtil);
		script.set('flixel.system.FlxQuadTree', flixel.system.FlxQuadTree);
		script.set('flixel.system.FlxPreloader', flixel.system.FlxPreloader);
		script.set('flixel.system.FlxLinkedList', flixel.system.FlxLinkedList);
		script.set('flixel.system.FlxBasePreloader', flixel.system.FlxBasePreloader);
		script.set('flixel.system.FlxBGSprite', flixel.system.FlxBGSprite);
		script.set('flixel.system.FlxAssets', flixel.system.FlxAssets);
		script.set('flixel.sound.FlxSoundGroup', flixel.sound.FlxSoundGroup);
		script.set('flixel.sound.FlxSound', flixel.sound.FlxSound);
		script.set('flixel.path.FlxPath', flixel.path.FlxPath);
		script.set('flixel.math.FlxVelocity', flixel.math.FlxVelocity);
		script.set('flixel.math.FlxMath', flixel.math.FlxMath);
		script.set('flixel.math.FlxAngle', flixel.math.FlxAngle);
		script.set('flixel.input.touch.FlxTouch', flixel.input.touch.FlxTouch);
		script.set('flixel.input.mouse.FlxMouseEventManager', flixel.input.mouse.FlxMouseEventManager);
		script.set('flixel.input.mouse.FlxMouseEvent', flixel.input.mouse.FlxMouseEvent);
		script.set('flixel.input.mouse.FlxMouseButton', flixel.input.mouse.FlxMouseButton);
		script.set('flixel.input.mouse.FlxMouse', flixel.input.mouse.FlxMouse);
		script.set('flixel.input.keyboard.FlxKeyboard', flixel.input.keyboard.FlxKeyboard);
		script.set('flixel.input.keyboard.FlxKeyList', flixel.input.keyboard.FlxKeyList);
		script.set('flixel.input.gamepad.mappings.XInputMapping', flixel.input.gamepad.mappings.XInputMapping);
		script.set('flixel.input.gamepad.mappings.WiiRemoteMapping', flixel.input.gamepad.mappings.WiiRemoteMapping);
		script.set('flixel.input.gamepad.mappings.SwitchProMapping', flixel.input.gamepad.mappings.SwitchProMapping);
		script.set('flixel.input.gamepad.mappings.SwitchJoyconRightMapping', flixel.input.gamepad.mappings.SwitchJoyconRightMapping);
		script.set('flixel.input.gamepad.mappings.SwitchJoyconLeftMapping', flixel.input.gamepad.mappings.SwitchJoyconLeftMapping);
		script.set('flixel.input.gamepad.mappings.PSVitaMapping', flixel.input.gamepad.mappings.PSVitaMapping);
		script.set('flixel.input.gamepad.mappings.PS4Mapping', flixel.input.gamepad.mappings.PS4Mapping);
		script.set('flixel.input.gamepad.mappings.OUYAMapping', flixel.input.gamepad.mappings.OUYAMapping);
		script.set('flixel.input.gamepad.mappings.MayflashWiiRemoteMapping', flixel.input.gamepad.mappings.MayflashWiiRemoteMapping);
		script.set('flixel.input.gamepad.mappings.MFiMapping', flixel.input.gamepad.mappings.MFiMapping);
		script.set('flixel.input.gamepad.mappings.LogitechMapping', flixel.input.gamepad.mappings.LogitechMapping);
		script.set('flixel.input.gamepad.lists.FlxGamepadPointerValueList', flixel.input.gamepad.lists.FlxGamepadPointerValueList);
		script.set('flixel.input.gamepad.lists.FlxGamepadMotionValueList', flixel.input.gamepad.lists.FlxGamepadMotionValueList);
		script.set('flixel.input.gamepad.lists.FlxGamepadButtonList', flixel.input.gamepad.lists.FlxGamepadButtonList);
		script.set('flixel.input.gamepad.lists.FlxGamepadAnalogValueList', flixel.input.gamepad.lists.FlxGamepadAnalogValueList);
		script.set('flixel.input.gamepad.lists.FlxGamepadAnalogStateList', flixel.input.gamepad.lists.FlxGamepadAnalogStateList);
		script.set('flixel.input.gamepad.lists.FlxGamepadAnalogList', flixel.input.gamepad.lists.FlxGamepadAnalogList);
		script.set('flixel.input.gamepad.lists.FlxBaseGamepadList', flixel.input.gamepad.lists.FlxBaseGamepadList);
		script.set('flixel.input.gamepad.FlxGamepadManager', flixel.input.gamepad.FlxGamepadManager);
		script.set('flixel.input.gamepad.FlxGamepadButton', flixel.input.gamepad.FlxGamepadButton);
		script.set('flixel.input.gamepad.FlxGamepad', flixel.input.gamepad.FlxGamepad);
		script.set('flixel.input.FlxSwipe', flixel.input.FlxSwipe);
		script.set('flixel.input.FlxPointer', flixel.input.FlxPointer);
		script.set('flixel.input.FlxKeyManager', flixel.input.FlxKeyManager);
		script.set('flixel.input.FlxInput', flixel.input.FlxInput);
		script.set('flixel.input.FlxBaseKeyList', flixel.input.FlxBaseKeyList);
		script.set('flixel.graphics.tile.FlxGraphicsShader', flixel.graphics.tile.FlxGraphicsShader);
		script.set('flixel.graphics.tile.FlxDrawTrianglesItem', flixel.graphics.tile.FlxDrawTrianglesItem);
		script.set('flixel.graphics.tile.FlxDrawQuadsItem', flixel.graphics.tile.FlxDrawQuadsItem);
		script.set('flixel.graphics.tile.FlxDrawBaseItem', flixel.graphics.tile.FlxDrawBaseItem);
		script.set('flixel.graphics.frames.bmfont.BMFontUtil', flixel.graphics.frames.bmfont.BMFontUtil);
		script.set('flixel.graphics.frames.bmfont.BMFontPage', flixel.graphics.frames.bmfont.BMFontPage);
		script.set('flixel.graphics.frames.bmfont.BMFontKerning', flixel.graphics.frames.bmfont.BMFontKerning);
		script.set('flixel.graphics.frames.bmfont.BMFontInfo', flixel.graphics.frames.bmfont.BMFontInfo);
		script.set('flixel.graphics.frames.bmfont.BMFontCommon', flixel.graphics.frames.bmfont.BMFontCommon);
		script.set('flixel.graphics.frames.bmfont.BMFontChar', flixel.graphics.frames.bmfont.BMFontChar);
		script.set('flixel.graphics.frames.bmfont.BMFont', flixel.graphics.frames.bmfont.BMFont);
		script.set('flixel.graphics.frames.FlxTileFrames', flixel.graphics.frames.FlxTileFrames);
		script.set('flixel.graphics.frames.FlxImageFrame', flixel.graphics.frames.FlxImageFrame);
		script.set('flixel.graphics.frames.FlxFrame', flixel.graphics.frames.FlxFrame);
		script.set('flixel.math.FlxMatrix', flixel.math.FlxMatrix);
		script.set('flixel.graphics.frames.FlxBitmapFont', flixel.graphics.frames.FlxBitmapFont);
		script.set('flixel.graphics.frames.FlxAtlasFrames', flixel.graphics.frames.FlxAtlasFrames);
		script.set('flixel.graphics.frames.FlxFramesCollection', flixel.graphics.frames.FlxFramesCollection);
		script.set('flixel.graphics.atlas.FlxNode', flixel.graphics.atlas.FlxNode);
		script.set('flixel.graphics.atlas.FlxAtlas', flixel.graphics.atlas.FlxAtlas);
		script.set('flixel.graphics.FlxGraphic', flixel.graphics.FlxGraphic);
		script.set('flixel.effects.particles.FlxParticle', flixel.effects.particles.FlxParticle);
		script.set('flixel.effects.FlxFlicker', flixel.effects.FlxFlicker);
		script.set('flixel.animation.FlxPrerotatedAnimation', flixel.animation.FlxPrerotatedAnimation);
		script.set('flixel.animation.FlxAnimationController', flixel.animation.FlxAnimationController);
		script.set('flixel.animation.FlxAnimation', flixel.animation.FlxAnimation);
		script.set('flixel.animation.FlxBaseAnimation', flixel.animation.FlxBaseAnimation);
		script.set('flixel.FlxSubState', flixel.FlxSubState);
		script.set('flixel.FlxSprite', flixel.FlxSprite);
		script.set('flixel.FlxObject', flixel.FlxObject);
		script.set('flixel.system.FlxSplash', flixel.system.FlxSplash);
		script.set('flixel.FlxState', flixel.FlxState);
		script.set('flixel.FlxGame', flixel.FlxGame);
		script.set('flixel.FlxG', flixel.FlxG);
		script.set('flixel.system.frontEnds.WatchFrontEnd', flixel.system.frontEnds.WatchFrontEnd);
		script.set('flixel.system.frontEnds.SignalFrontEnd', flixel.system.frontEnds.SignalFrontEnd);
		script.set('flixel.system.scaleModes.RatioScaleMode', flixel.system.scaleModes.RatioScaleMode);
		script.set('flixel.system.scaleModes.BaseScaleMode', flixel.system.scaleModes.BaseScaleMode);
		script.set('flixel.util.FlxSave', flixel.util.FlxSave);
		script.set('flixel.math.FlxRandom', flixel.math.FlxRandom);
		script.set('flixel.system.frontEnds.LogFrontEnd', flixel.system.frontEnds.LogFrontEnd);
		script.set('flixel.system.frontEnds.InputFrontEnd', flixel.system.frontEnds.InputFrontEnd);
		script.set('flixel.system.frontEnds.DebuggerFrontEnd', flixel.system.frontEnds.DebuggerFrontEnd);
		script.set('flixel.system.frontEnds.ConsoleFrontEnd', flixel.system.frontEnds.ConsoleFrontEnd);
		script.set('flixel.system.frontEnds.CameraFrontEnd', flixel.system.frontEnds.CameraFrontEnd);
		script.set('flixel.system.frontEnds.BitmapLogFrontEnd', flixel.system.frontEnds.BitmapLogFrontEnd);
		script.set('flixel.system.frontEnds.BitmapFrontEnd', flixel.system.frontEnds.BitmapFrontEnd);
		script.set('flixel.system.frontEnds.AssetFrontEnd', flixel.system.frontEnds.AssetFrontEnd);
		script.set('flixel.system.FlxVersion', flixel.system.FlxVersion);
		script.set('flixel.FlxCamera', flixel.FlxCamera);
		script.set('flixel.math.FlxRect', flixel.math.FlxRect);
		script.set('flixel.util.FlxPool', flixel.util.FlxPool);
		script.set('flixel.FlxBasic', flixel.FlxBasic);
		script.set('lime.utils.Preloader', lime.utils.Preloader);
		script.set('lime.utils.Log', lime.utils.Log);
		script.set('lime.utils.Assets', lime.utils.Assets);
		script.set('lime.utils.AssetManifest', lime.utils.AssetManifest);
		script.set('lime.utils.AssetLibrary', lime.utils.AssetLibrary);
		script.set('lime.utils.AssetCache', lime.utils.AssetCache);
		script.set('lime.utils.AssetBundle', lime.utils.AssetBundle);
		script.set('lime.ui.Window', lime.ui.Window);
		script.set('lime.ui.Touch', lime.ui.Touch);
		script.set('lime.ui.Joystick', lime.ui.Joystick);
		script.set('lime.ui.Gamepad', lime.ui.Gamepad);
		script.set('lime.ui.FileDialog', lime.ui.FileDialog);
		script.set('lime.text.harfbuzz.HBSegmentProperties', lime.text.harfbuzz.HBSegmentProperties);
		script.set('lime.text.harfbuzz.HBGlyphPosition', lime.text.harfbuzz.HBGlyphPosition);
		script.set('lime.text.harfbuzz.HBGlyphInfo', lime.text.harfbuzz.HBGlyphInfo);
		script.set('lime.text.harfbuzz.HBFeature', lime.text.harfbuzz.HBFeature);
		script.set('lime.text.harfbuzz.HB', lime.text.harfbuzz.HB);
		script.set('lime.text.GlyphMetrics', lime.text.GlyphMetrics);
		script.set('lime.system.ThreadPool', lime.system.ThreadPool);
		script.set('lime.system.WorkOutput', lime.system.WorkOutput);
		script.set('lime.system.Sensor', lime.system.Sensor);
		script.set('lime.system.DisplayMode', lime.system.DisplayMode);
		script.set('lime.system.Display', lime.system.Display);
		script.set('lime.system.Clipboard', lime.system.Clipboard);
		script.set('lime.system.CFFI', lime.system.CFFI);
		script.set('lime.system.BackgroundWorker', lime.system.BackgroundWorker);
		script.set('lime.net.curl.CURLMultiMessage', lime.net.curl.CURLMultiMessage);
		script.set('lime.net.curl.CURLMulti', lime.net.curl.CURLMulti);
		script.set('lime.net.curl.CURL', lime.net.curl.CURL);
		script.set('lime.media.vorbis.VorbisInfo', lime.media.vorbis.VorbisInfo);
		script.set('lime.media.vorbis.VorbisFile', lime.media.vorbis.VorbisFile);
		script.set('lime.media.vorbis.VorbisComment', lime.media.vorbis.VorbisComment);
		script.set('lime.media.openal.ALC', lime.media.openal.ALC);
		script.set('lime.media.openal.AL', lime.media.openal.AL);
		script.set('lime.media.WebAudioContext', lime.media.WebAudioContext);
		script.set('lime.media.OpenALAudioContext', lime.media.OpenALAudioContext);
		script.set('lime.media.HTML5AudioContext', lime.media.HTML5AudioContext);
		script.set('lime.media.FlashAudioContext', lime.media.FlashAudioContext);
		script.set('lime.media.AudioSource', lime.media.AudioSource);
		script.set('lime.media.AudioManager', lime.media.AudioManager);
		script.set('lime.media.AudioContext', lime.media.AudioContext);
		script.set('lime.media.AudioBuffer', lime.media.AudioBuffer);
		script.set('lime.math.Vector4', lime.math.Vector4);
		script.set('lime.graphics.opengl.GL', lime.graphics.opengl.GL);
		script.set('lime.graphics.cairo.CairoGlyph', lime.graphics.cairo.CairoGlyph);
		script.set('lime.graphics.cairo.Cairo', lime.graphics.cairo.Cairo);
		script.set('lime.graphics.RenderContext', lime.graphics.RenderContext);
		script.set('lime.app.Promise', lime.app.Promise);
		script.set('lime.app.Future', lime.app.Future);
		script.set('lime.math.Rectangle', lime.math.Rectangle);
		script.set('lime.graphics.ImageBuffer', lime.graphics.ImageBuffer);
		script.set('lime.system.System', lime.system.System);
		script.set('lime.math.Vector2', lime.math.Vector2);
		script.set('lime.utils.ArrayBufferView', lime.utils.ArrayBufferView);
		script.set('lime.graphics.Image', lime.graphics.Image);
		script.set('lime.text.Font', lime.text.Font);
		script.set('lime.utils.ObjectPool', lime.utils.ObjectPool);
		script.set('lime.app.Application', lime.app.Application);
		script.set('lime.app.Module', lime.app.Module);
		script.set('openfl.utils.QName', openfl.utils.QName);
		script.set('openfl.utils.Namespace', openfl.utils.Namespace);
		script.set('openfl.utils.Assets', openfl.utils.Assets);
		script.set('openfl.utils.AssetLibrary', openfl.utils.AssetLibrary);
		script.set('openfl.utils.AssetCache', openfl.utils.AssetCache);
		script.set('openfl.utils.AGALMiniAssembler', openfl.utils.AGALMiniAssembler);
		script.set('openfl.ui.Mouse', openfl.ui.Mouse);
		script.set('openfl.ui.Keyboard', openfl.ui.Keyboard);
		script.set('openfl.ui.GameInputDevice', openfl.ui.GameInputDevice);
		script.set('openfl.ui.GameInputControl', openfl.ui.GameInputControl);
		script.set('openfl.text.TextLineMetrics', openfl.text.TextLineMetrics);
		script.set('openfl.text.TextFormat', openfl.text.TextFormat);
		script.set('openfl.text.StyleSheet', openfl.text.StyleSheet);
		script.set('openfl.system.System', openfl.system.System);
		script.set('openfl.system.SecurityDomain', openfl.system.SecurityDomain);
		script.set('openfl.system.LoaderContext', openfl.system.LoaderContext);
		script.set('openfl.system.ApplicationDomain', openfl.system.ApplicationDomain);
		script.set('openfl.net.URLRequestDefaults', openfl.net.URLRequestDefaults);
		script.set('openfl.net.URLRequest', openfl.net.URLRequest);
		script.set('openfl.net.URLLoader', openfl.net.URLLoader);
		script.set('openfl.net.NetStream', openfl.net.NetStream);
		script.set('openfl.net.NetConnection', openfl.net.NetConnection);
		script.set('openfl.net.FileFilter', openfl.net.FileFilter);
		script.set('openfl.media.Video', openfl.media.Video);
		script.set('openfl.media.SoundMixer', openfl.media.SoundMixer);
		script.set('openfl.media.SoundTransform', openfl.media.SoundTransform);
		script.set('openfl.media.SoundLoaderContext', openfl.media.SoundLoaderContext);
		script.set('openfl.media.SoundChannel', openfl.media.SoundChannel);
		script.set('openfl.media.Sound', openfl.media.Sound);
		script.set('openfl.media.ID3Info', openfl.media.ID3Info);
		script.set('openfl.geom.Vector3D', openfl.geom.Vector3D);
		script.set('openfl.geom.Transform', openfl.geom.Transform);
		script.set('openfl.geom.Matrix3D', openfl.geom.Matrix3D);
		script.set('openfl.filters.BitmapFilter', openfl.filters.BitmapFilter);
		script.set('openfl.filesystem.File', openfl.filesystem.File);
		script.set('openfl.net.FileReference', openfl.net.FileReference);
		script.set('openfl.events.UncaughtErrorEvents', openfl.events.UncaughtErrorEvents);
		script.set('openfl.events.UncaughtErrorEvent', openfl.events.UncaughtErrorEvent);
		script.set('openfl.events.TouchEvent', openfl.events.TouchEvent);
		script.set('openfl.events.SecurityErrorEvent', openfl.events.SecurityErrorEvent);
		script.set('openfl.events.SampleDataEvent', openfl.events.SampleDataEvent);
		script.set('openfl.events.RenderEvent', openfl.events.RenderEvent);
		script.set('openfl.events.ProgressEvent', openfl.events.ProgressEvent);
		script.set('openfl.events.NetStatusEvent', openfl.events.NetStatusEvent);
		script.set('openfl.events.NativeWindowDisplayStateEvent', openfl.events.NativeWindowDisplayStateEvent);
		script.set('openfl.events.NativeWindowBoundsEvent', openfl.events.NativeWindowBoundsEvent);
		script.set('openfl.events.MouseEvent', openfl.events.MouseEvent);
		script.set('openfl.events.KeyboardEvent', openfl.events.KeyboardEvent);
		script.set('openfl.events.InvokeEvent', openfl.events.InvokeEvent);
		script.set('openfl.events.IOErrorEvent', openfl.events.IOErrorEvent);
		script.set('openfl.events.HTTPStatusEvent', openfl.events.HTTPStatusEvent);
		script.set('openfl.events.GameInputEvent', openfl.events.GameInputEvent);
		script.set('openfl.events.FullScreenEvent', openfl.events.FullScreenEvent);
		script.set('openfl.events.FocusEvent', openfl.events.FocusEvent);
		script.set('openfl.events.FileListEvent', openfl.events.FileListEvent);
		script.set('openfl.events.ErrorEvent', openfl.events.ErrorEvent);
		script.set('openfl.events.DataEvent', openfl.events.DataEvent);
		script.set('openfl.events.TextEvent', openfl.events.TextEvent);
		script.set('openfl.events.ActivityEvent', openfl.events.ActivityEvent);
		script.set('openfl.events.Event', openfl.events.Event);
		script.set('openfl.errors.TypeError', openfl.errors.TypeError);
		script.set('openfl.errors.RangeError', openfl.errors.RangeError);
		script.set('openfl.errors.IllegalOperationError', openfl.errors.IllegalOperationError);
		script.set('openfl.errors.EOFError', openfl.errors.EOFError);
		script.set('openfl.errors.IOError', openfl.errors.IOError);
		script.set('openfl.errors.ArgumentError', openfl.errors.ArgumentError);
		script.set('openfl.errors.Error', openfl.errors.Error);
		script.set('openfl.display3D.textures.VideoTexture', openfl.display3D.textures.VideoTexture);
		script.set('openfl.display3D.textures.Texture', openfl.display3D.textures.Texture);
		script.set('openfl.display3D.textures.RectangleTexture', openfl.display3D.textures.RectangleTexture);
		script.set('openfl.display3D.textures.CubeTexture', openfl.display3D.textures.CubeTexture);
		script.set('openfl.display3D.textures.TextureBase', openfl.display3D.textures.TextureBase);
		script.set('openfl.display3D.VertexBuffer3D', openfl.display3D.VertexBuffer3D);
		script.set('openfl.display3D.Program3D', openfl.display3D.Program3D);
		script.set('openfl.display3D.IndexBuffer3D', openfl.display3D.IndexBuffer3D);
		script.set('openfl.display3D.Context3D', openfl.display3D.Context3D);
		script.set('openfl.display.Window', openfl.display.Window);
		script.set('openfl.display.Timeline', openfl.display.Timeline);
		script.set('openfl.display.Tileset', openfl.display.Tileset);
		script.set('openfl.display.Tilemap', openfl.display.Tilemap);
		script.set('openfl.display.TileContainer', openfl.display.TileContainer);
		script.set('openfl.display.Tile', openfl.display.Tile);
		script.set('openfl.display.Stage3D', openfl.display.Stage3D);
		script.set('openfl.display.Stage', openfl.display.Stage);
		script.set('openfl.display.SimpleButton', openfl.display.SimpleButton);
		script.set('openfl.display.Shape', openfl.display.Shape);
		script.set('openfl.display.ShaderParameter', openfl.display.ShaderParameter);
		script.set('openfl.display.ShaderInput', openfl.display.ShaderInput);
		script.set('openfl.display.Scene', openfl.display.Scene);
		script.set('openfl.display.Preloader', openfl.display.Preloader);
		script.set('openfl.display.PNGEncoderOptions', openfl.display.PNGEncoderOptions);
		script.set('openfl.display.OpenGLRenderer', openfl.display.OpenGLRenderer);
		script.set('openfl.display.NativeWindowInitOptions', openfl.display.NativeWindowInitOptions);
		script.set('openfl.display.NativeWindow', openfl.display.NativeWindow);
		script.set('openfl.display.MovieClip', openfl.display.MovieClip);
		script.set('openfl.display.LoaderInfo', openfl.display.LoaderInfo);
		script.set('openfl.display.Loader', openfl.display.Loader);
		script.set('openfl.display.JPEGEncoderOptions', openfl.display.JPEGEncoderOptions);
		script.set('openfl.display.GraphicsTrianglePath', openfl.display.GraphicsTrianglePath);
		script.set('openfl.display.GraphicsStroke', openfl.display.GraphicsStroke);
		script.set('openfl.display.GraphicsSolidFill', openfl.display.GraphicsSolidFill);
		script.set('openfl.display.GraphicsShaderFill', openfl.display.GraphicsShaderFill);
		script.set('openfl.display.GraphicsQuadPath', openfl.display.GraphicsQuadPath);
		script.set('openfl.display.GraphicsPath', openfl.display.GraphicsPath);
		script.set('openfl.display.GraphicsGradientFill', openfl.display.GraphicsGradientFill);
		script.set('openfl.display.GraphicsEndFill', openfl.display.GraphicsEndFill);
		script.set('openfl.display.GraphicsBitmapFill', openfl.display.GraphicsBitmapFill);
		script.set('openfl.display.Graphics', openfl.display.Graphics);
		script.set('openfl.display.FrameScript', openfl.display.FrameScript);
		script.set('openfl.display.FrameLabel', openfl.display.FrameLabel);
		script.set('openfl.display.DisplayObjectShader', openfl.display.DisplayObjectShader);
		script.set('openfl.display.DOMRenderer', openfl.display.DOMRenderer);
		script.set('openfl.display.CanvasRenderer', openfl.display.CanvasRenderer);
		script.set('openfl.display.CairoRenderer', openfl.display.CairoRenderer);
		script.set('openfl.display.DisplayObjectRenderer', openfl.display.DisplayObjectRenderer);
		script.set('openfl.display.Bitmap', openfl.display.Bitmap);
		script.set('openfl.display.Application', openfl.display.Application);
		script.set('openfl.desktop.NativeApplication', openfl.desktop.NativeApplication);
		script.set('openfl.desktop.InteractiveIcon', openfl.desktop.InteractiveIcon);
		script.set('openfl.desktop.Icon', openfl.desktop.Icon);
		script.set('openfl.Lib', openfl.Lib);
		script.set('openfl.net.SharedObject', openfl.net.SharedObject);
		script.set('openfl.text.TextField', openfl.text.TextField);
		script.set('openfl.display.BitmapData', openfl.display.BitmapData);
		script.set('openfl.ui.GameInput', openfl.ui.GameInput);
		script.set('openfl.display.GraphicsShader', openfl.display.GraphicsShader);
		script.set('openfl.display.Shader', openfl.display.Shader);
		script.set('openfl.geom.Rectangle', openfl.geom.Rectangle);
		script.set('openfl.geom.Point', openfl.geom.Point);
		script.set('openfl.geom.ColorTransform', openfl.geom.ColorTransform);
		script.set('openfl.geom.Matrix', openfl.geom.Matrix);
		script.set('openfl.text.Font', openfl.text.Font);
		script.set('openfl.display.Sprite', openfl.display.Sprite);
		script.set('openfl.display.DisplayObjectContainer', openfl.display.DisplayObjectContainer);
		script.set('openfl.display.InteractiveObject', openfl.display.InteractiveObject);
		script.set('openfl.display.DisplayObject', openfl.display.DisplayObject);
		script.set('openfl.events.EventDispatcher', openfl.events.EventDispatcher);
	}
}
