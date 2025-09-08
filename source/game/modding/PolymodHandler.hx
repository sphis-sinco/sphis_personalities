package game.modding;

import game.scripts.ScriptManager;
#if polymod
import polymod.Polymod;

using StringTools;

class PolymodHandler
{
	public static var MINIMUM_MOD_VERSION:String = "0.0.0";
	public static var MAXIMUM_MOD_VERSION:String = "1.0.0";

	public static var metadataArrays:Array<String> = [];
	public static var outdatedMods:Array<String> = [];

	public static function loadMods()
	{
		ModList.load();
		loadModMetadata();

		try
		{
			init();
		}
		catch (e)
		{
			trace(e.message);
		}

		ScriptManager.checkForUpdatedScripts();
	}

	public static function loadModMetadata()
	{
		metadataArrays = [];

		var tempArray:Array<ModMetadata> = Polymod.scan({
			modRoot: "mods/",
			apiVersionRule: "*.*.*",
			errorCallback: function(error:PolymodError)
			{
				#if debug
				trace(error.message.replace('mod mods/', 'mod '));
				#end
			}
		});

		outdatedMods = [];
		for (metadata in tempArray)
		{
			if (metadata.title == null)
				return;
			metadataArrays.push(metadata.id);
			ModList.modMetadatas.set(metadata.id, metadata);

			if (!metadata.apiVersion.satisfies('>=' + MINIMUM_MOD_VERSION + ' <' + MAXIMUM_MOD_VERSION))
				outdatedMods.push(metadata.id);
		}
		trace('metadataArrays: ' + metadataArrays.toString());
		trace('outdatedMods: ' + outdatedMods.toString());
	}

	static function init()
	{
		Polymod.init({
			modRoot: "mods/",
			dirs: ModList.getActiveMods(metadataArrays),
			framework: OPENFL,
			errorCallback: function(error:PolymodError)
			{
				#if debug
				#if BLOCK_SOME_POLYMOD_TRACES
				var I_dont_wanna_see_that_shit:Array<PolymodErrorCode> = [
					PARSE_MOD_META,
					PARSE_MOD_VERSION,
					PARSE_MOD_API_VERSION,
					FILE_MISSING,
					MISSING_META,
					MISSING_ICON,
					MOD_LOAD_PREPARE,
					MOD_LOAD_DONE
				];

				if (I_dont_wanna_see_that_shit.contains(error.code))
					return;
				#end
				#end

				if (error.code == VERSION_CONFLICT_API)
				{
					var msgList = error.message.split('"');
					var mod = ModList.modMetadatas.get(msgList[1]);

					trace('' + mod.title + ' uses an outdated API (' + mod.apiVersion + '). Expected API minimum of ' + MINIMUM_MOD_VERSION + '.');

					return;
				}

				trace('[' + error.severity + '] ' + error.message.replace('mod mods/', 'mod: '));
			},
			apiVersionRule: '>=' + MINIMUM_MOD_VERSION + ' <' + MAXIMUM_MOD_VERSION
		});
	}
}
#end
