package game;

#if sys
import sys.FileSystem;
#end

using StringTools;

class Paths
{
	public static function getGamePath(path:String)
	{
		var retpath = (StringTools.startsWith(path, 'game/') ? '' : 'game/') + path;
		return retpath;
	}

	public static function getImagePath(path:String, ?game:Bool = true)
	{
		return (game ? getGamePath(path + '.png') : path + '.png');
	}

	public static function getTypeArray(type:String, type_folder:String, ext:Array<String>, paths:Array<String>):Array<String>
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

						if (!arr.contains(path))
							arr.push(path);
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
			for (folder in FileSystem.readDirectory(directory))
				readFolder(folder, directory);
		}

		for (path in typePaths)
			readDir(path);

		var traceArr:Array<String> = [];
		for (path in arr)
		{
			var split = path.split('/');
			traceArr.push(split[split.length - 1]);
		}

		trace('Loaded ' + traceArr.length + ' ' + type + ' files:');
		for (file in arr)
		{
			trace(' * ' + file);
		}
		#end
		return arr;
	}
}
