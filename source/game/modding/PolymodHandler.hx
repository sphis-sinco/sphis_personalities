package game.modding;

import game.scripts.ScriptManager;

using StringTools;
using game.utils.MapUtil;

#if polymod
import polymod.Polymod;
import polymod.format.ParseRules;
#end

class PolymodHandler
{
	public static var MINIMUM_MOD_VERSION:String = "0.0.0";
	public static var MAXIMUM_MOD_VERSION:String = GameVersion.get.nextMajor().toString();

	public static var metadataArrays:Array<String> = [];
	public static var outdatedMods:Array<String> = [];

	public static function loadMods()
	{
		ModList.load();
		loadModMetadata();

		init();

		ScriptManager.checkForUpdatedScripts();
	}

	// #region mod metadata
	public static function loadModMetadata()
	{
		metadataArrays = [];

		#if polymod
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
		#end
		trace('metadataArrays: ' + metadataArrays.toString());
		trace('outdatedMods: ' + outdatedMods.toString());
	}

	// #endregion
	// #region sum init stuffs
	#if polymod
	static function buildParseRules():polymod.format.ParseRules
	#else
	static function buildParseRules()
	#end
	{
		#if polymod
		var output:polymod.format.ParseRules = polymod.format.ParseRules.getDefault();

		// Ensure TXT files have merge support.
		output.addType('txt', TextFileFormat.LINES);
		// Ensure script files have merge support.
		for (ext in ScriptManager.SCRIPT_EXTS)
		{
			output.addType(ext, TextFileFormat.PLAINTEXT);
		}
		// You can specify the format of a specific file, with file extension.
		// output.addFile("data/introText.txt", TextFileFormat.LINES)
		return output;
		#end
	}

	static function buildIgnoreList():Array<String>
	{
		var result =
			#if polymod
			Polymod.getDefaultIgnoreList();
			#else
			[];
			#end

		result.push('.haxelib');
		result.push('hmm.json');
		result.push('.git');
		result.push('.gitignore');
		result.push('.gitattributes');
		result.push('README.md');

		return result;
	}

	// #endregion
	// #region polymod init
	static function init()
	{
		#if polymod
		Polymod.init({
			modRoot: "mods/",
			dirs: ModList.getActiveMods(metadataArrays),
			parseRules: buildParseRules(),
			ignoredFiles: buildIgnoreList(),
			errorCallback: function(error:PolymodError)
			{
				#if debug
				var I_dont_wanna_see_that_shit:Array<PolymodErrorCode> = [
					PARSE_MOD_META,
					PARSE_MOD_VERSION,
					PARSE_MOD_API_VERSION,
					FILE_MISSING,
					MISSING_META,
					MISSING_ICON,
					MOD_LOAD_PREPARE,
					MOD_LOAD_DONE,
					FRAMEWORK_INIT,
					FRAMEWORK_AUTODETECT
				];

				if (I_dont_wanna_see_that_shit.contains(error.code))
					return;
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
		#end

		for (key in ModList.modList.keysArray())
		{
			trace('Mod loaded: ' + key);
		}
	}

	// #endregion
}
