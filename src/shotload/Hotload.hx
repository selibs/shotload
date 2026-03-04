package shotload;

#if macro
import sys.FileSystem;
import sys.thread.Thread;
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Compiler;
#end

class Hotload {
	#if macro
	static var paths:Array<String> = [];

	public static function init(classPaths:Array<String>) {
		for (cp in classPaths)
			for (p in FileSystem.readDirectory(cp))
				Compiler.addGlobalMetadata(Path.withoutExtension(p), '@:build(shotload.Hotload.build("${Path.join([cp, p])}"))');
		Thread.current().events.repeat(watch, 1000);
	}

	public static function build(path:String) {
		var fields = Context.getBuildFields();
		var cls = Context.getLocalClass()?.get();
		if (cls == null)
			return fields;
		paths.push(path);
		return fields;
	}

	static function watch() {
		for (p in paths)
			trace(FileSystem.stat(p));
	}
	#end
}
