package game.mods;

import haxe.Json;
#if sys
import sys.FileSystem;
#end

class ModManager
{
	public static var MOD_IDS:Array<String> = [];
	public static var MODS_ENABLED:Array<String> = [];
	public static var MODS_DISABLED:Array<String> = [];
	public static var MOD_METAS:Map<String, ModMeta> = [];
	public static var MOD_METADATA_FILE:String = 'meta.json';
	public static var MOD_DISABLE_FILE:String = 'disable';

	public static var MODS_FOLDER:String = 'mods';

	public static function loadMods()
	{
		MOD_IDS = [];
		MODS_ENABLED = [];
		MODS_DISABLED = [];
		MOD_METAS = [];

		#if sys
		if (!Paths.pathExists('$MODS_FOLDER/'))
			FileSystem.createDirectory('$MODS_FOLDER');

		for (entry in FileSystem.readDirectory('$MODS_FOLDER/'))
		{
			if (entry != null && FileSystem.isDirectory('$MODS_FOLDER/$entry'))
			{
				var meta:ModMeta;
				var disable:String = '';
				try
				{
					meta = Json.parse(Paths.getText('$MODS_FOLDER/$entry/$MOD_METADATA_FILE'));
				}
				catch (e)
				{
					meta = null;
					trace('$entry meta error: ${e.message}');
				}

				if (meta != null)
				{
					try
					{
						disable = Paths.getText('$MODS_FOLDER/$entry/$MOD_DISABLE_FILE');
					}
					catch (e)
					{
						disable = null;
						trace('$entry disable file error: ${e.message}');
					}
				}

				if (meta != null)
				{
					if (meta.priority == null)
						meta.priority = 0;
				}

				if (meta != null && (disable == null || disable == ''))
				{
					MOD_IDS.push(entry);
					MODS_ENABLED.push(entry);
					MOD_METAS.set(entry, meta);
				}
				else
				{
					if (meta != null)
					{
						MOD_IDS.push(entry);
						MODS_DISABLED.push(entry);
						MOD_METAS.set(entry, meta);
					}
				}
			}
		}
		#end

		MOD_IDS.sort(sortByPriority);

		trace(MOD_IDS.length + ' valid mods loaded');
		if (MOD_IDS.length > 0)
		{
			for (id in MOD_IDS)
			{
				final meta = MOD_METAS.get(id);
				trace(' * '
					+ meta.name
					+ '('
					+ id
					+ ') v'
					+ meta.version
					+ ' (Active: '
					+ MODS_ENABLED.contains(id)
					+ ', Priority: '
					+ meta.priority
					+ ')');
			}
		}
	}

	public static function sortByPriority(a:String, b:String):Int
	{
		var aMeta:Null<ModMeta> = MOD_METAS.get(a);
		var bMeta:Null<ModMeta> = MOD_METAS.get(b);

		if (aMeta == null || bMeta == null)
		{
			return 0;
		}
		/*
			if (aMeta.priority != bMeta.priority)
			{
				return aMeta.priority - bMeta.priority;
			}
			else
			{ */

		return a == b ? 0 : a > b ? 1 : -1;
		// }
	}
}
