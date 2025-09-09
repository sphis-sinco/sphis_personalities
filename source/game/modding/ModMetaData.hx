package game.modding;

import crowplexus.iris.Iris;
import game.utils.JsonHelp;
import haxe.Json;
import haxe.io.Bytes;
import thx.semver.Version;
import thx.semver.VersionRule;

typedef ModContributor =
{
	name:String,
	?role:String,
	?email:String,
	?url:String
};

/**
 * A type representing a mod's dependencies.
 *
 * The map takes the mod's ID as the key and the required version as the value.
 * The version follows the Semantic Versioning format, with `*.*.*` meaning any version.
 */
typedef ModDependencies = Map<String, VersionRule>;

/**
 * A type representing data about a mod, as retrieved from its metadata file.
 */
class ModMetadata
{
	public static var modMetadataFile(default, null):String = 'meta.json';

	/**
	 * The internal ID of the mod.
	 */
	public var id:String;

	/**
	 * The human-readable name of the mod.
	 */
	public var title:String;

	/**
	 * A short description of the mod.
	 */
	public var description:String;

	/**
	 * A link to the homepage for a mod.
	 * Should provide a URL where the mod can be downloaded from.
	 */
	public var homepage:String;

	/**
	 * A version number for the API used by the mod.
	 * Used to prevent compatibility issues with mods when the application changes.
	 */
	public var apiVersion:Version;

	/**
	 * A version number for the mod itself.
	 * Should be provided in the Semantic Versioning format.
	 */
	public var modVersion:Version;

	/**
	 * Binary data containing information on the mod's icon file, if it exists.
	 * This is useful when you want to display the mod's icon in your application's mod menu.
	 */
	public var icon:Bytes = null;

	/**
	 * The path on the filesystem to the mod's icon file.
	 */
	public var iconPath:String;

	/**
	 * The path where this mod's files are stored, on the IFileSystem.
	 */
	public var modPath:String;

	/**
	 * `metadata` provides an optional list of keys.
	 * These can provide additional information about the mod, specific to your application.
	 */
	public var metadata:Map<String, String>;

	/**
	 * A list of dependencies.
	 * These other mods must be also be loaded in order for this mod to load,
	 * and this mod must be loaded after the dependencies.
	 */
	public var dependencies:ModDependencies;

	/**
	 * A list of dependencies.
	 * This mod must be loaded after the optional dependencies,
	 * but those mods do not necessarily need to be loaded.
	 */
	public var optionalDependencies:ModDependencies;

	/**
	 * A list of contributors to the mod.
	 * Provides data about their roles as well as optional contact information.
	 */
	public var contributors:Array<ModContributor>;

	public function new()
	{
		// No-op constructor.
	}

	public function toJsonStr():String
	{
		var json = {};
		Reflect.setField(json, 'title', title);
		Reflect.setField(json, 'description', description);
		Reflect.setField(json, 'contributors', contributors);
		Reflect.setField(json, 'api_version', apiVersion.toString());
		Reflect.setField(json, 'mod_version', modVersion.toString());
		var meta = {};
		for (key in metadata.keys())
		{
			Reflect.setField(meta, key, metadata.get(key));
		}
		Reflect.setField(json, 'metadata', meta);
		return Json.stringify(json, null, '    ');
	}

	public static function fromJsonStr(str:String)
	{
		if (str == null || str == '')
		{
			Iris.error('Error parsing mod metadata file, was null or empty.');
			return null;
		}

		var json = null;
		try
		{
			json = haxe.Json.parse(str);
		}
		catch (msg:Dynamic)
		{
			Iris.error('Error parsing mod metadata file: (' + msg + ')');
			return null;
		}

		var m = new ModMetadata();
		m.title = JsonHelp.str(json, 'title');
		m.description = JsonHelp.str(json, 'description');
		m.contributors = JsonHelp.arrType(json, 'contributors');
		var apiVersionStr = JsonHelp.str(json, 'api_version');
		var modVersionStr = JsonHelp.str(json, 'mod_version');
		try
		{
			m.apiVersion = apiVersionStr;
		}
		catch (msg:Dynamic)
		{
			Iris.error('Error parsing API version: (' + msg + ') ' + modMetadataFile + ' was ' + str);
			return null;
		}
		try
		{
			m.modVersion = modVersionStr;
		}
		catch (msg:Dynamic)
		{
			Iris.error('Error parsing mod version: (' + msg + ') ' + modMetadataFile + ' was ' + str + '');
			return null;
		}
		m.metadata = JsonHelp.mapStr(json, 'metadata');

		m.dependencies = JsonHelp.mapVersionRule(json, 'dependencies');
		m.optionalDependencies = JsonHelp.mapVersionRule(json, 'optionalDependencies');

		return m;
	}
}
