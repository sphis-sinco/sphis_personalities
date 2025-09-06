package game;

import game.mods.ModManager;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#else
import lime.utils.Assets;
#end

class Paths
{
	public static function getGamePath(path:String)
	{
		var retpath = (StringTools.startsWith(path, 'game/') ? '' : 'game/') + path;

		for (mod in ModManager.MODS_ENABLED)
		{
			if (pathExists('game/' + ModManager.MODS_FOLDER + '/' + mod + '/' + StringTools.replace(retpath, 'game/', '')))
			{
				retpath = 'game/' + ModManager.MODS_FOLDER + '/' + mod + '/' + StringTools.replace(retpath, 'game/', '');
			}
		}

		return retpath;
	}

	public static function getImagePath(path:String, ?game:Bool = true)
	{
		return (game ? getGamePath(path + '.png') : path + '.png');
	}

	public static function getTypeArray(type:String, type_folder:String, ext:Array<String>, paths:Array<String>,
			?foundFilesFunction:(Array<Dynamic>, String) -> Void = null):Array<String>
	{
		var arr:Array<String> = [];
		#if sys
		var typePaths:Array<String> = paths;
		var typeExtensions:Array<String> = ext;

		var readFolder:Dynamic = function(folder:String, ogdir:String) {};

		var readFileFolder:Dynamic = function(folder:String, ogdir:String)
		{
			if (!FileSystem.isDirectory(ogdir + folder))
				return;

			for (file in FileSystem.readDirectory(ogdir + folder))
			{
				final endsplitter:String = !folder.endsWith('/') && !file.startsWith('/') ? '/' : '';
				for (extension in typeExtensions)
					if (file.endsWith(extension))
					{
						final path:String = ogdir + folder + endsplitter + file;

						if (!arr.contains(getGamePath(path)))
							arr.push(getGamePath(path));
					}

				if (!file.contains('.'))
					readFolder(file, ogdir + folder + endsplitter);
			}
		}

		readFolder = function(folder:String, ogdir:String)
		{
			if (!folder.contains('.'))
				readFileFolder(folder, ogdir);
			else
				readFileFolder(ogdir, '');
		}
		var readDir:Dynamic = function(directory:String)
		{
			// trace(directory);
			if (pathExists(directory))
				for (folder in FileSystem.readDirectory(directory))
					if ((directory == 'game/') && folder != 'mods')
						readFolder(folder, directory);
		}

		for (path in typePaths)
		{
			readDir(path);
			for (mod in ModManager.MODS_ENABLED)
				readDir('game/'
					+ ModManager.MODS_FOLDER
					+ '/'
					+ mod
					+ '/'
					+ (StringTools.replace(StringTools.replace(path, ModManager.MODS_FOLDER + '/', ''), 'game/', '')));
		}

		if (foundFilesFunction != null)
		{
			foundFilesFunction(arr, type);
		}
		else
		{
			trace('Found ' + arr.length + ' ' + type + ' files:');
			for (file in arr)
			{
				trace(' * ' + file);
			}
		}
		#end
		return arr;
	}

	public static function saveContent(path:String, content:String)
	{
		#if sys
		File.saveContent(path, content);
		#end
	}

	public static function pathExists(id:String):Bool
	{
		#if sys
		return FileSystem.exists(id);
		#else
		return Assets.exists(id);
		#end
	}

	public static function getText(id:String):String
	{
		#if sys
		return File.getContent(id);
		#else
		return Assets.getText(id);
		#end
	}
}
