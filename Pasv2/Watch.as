package Pasv2{

	internal class Watch {;
	internal var deadRef;
	internal var commandline;
	function Watch(deadref:String,commandline:String) {
		this.deadRef = deadref;
		this.commandline = commandline;
	}
	internal function isEquivalent(otherWatch:Watch):Boolean {
		if (otherWatch.deadRef == this.deadRef && otherWatch.commandline == this.commandline) {
			return true;
		} else {
			return false;
		}
	}
	internal function WatchExists():Boolean {
		var globalobj = Deserialiser.globalobj;
		for (var w=0; w<globalobj.watchList.length; w++) {
			var watch:Watch = globalobj.watchList[w];
			if (this.isEquivalent(watch)) {
				return true;
			}
		}
		return false;
	}
	internal function Iterate():Boolean {
		var globalobj = Pasv2.Deserialiser.globalobj;
		var rootObject = globalobj.rootObject;
		var reference:Object = Pasv2.stringUtils.decompileIntoReference(this.deadRef,rootObject);
		if (reference!=null) {
			//remove from watchlist
			Pasv2.Deserialiser.globalobj.watchList;
			//execute the command line
			var commandstr = this.commandline;
			globalobj.currentcommand = commandstr;
			trace(this.deadRef+ " exists, execute "+this.commandline);
			if (Pasv2.stringUtils.indexOfWithoutLiteral(commandstr,"=") != -1) {
				//the command is an assignment
				//e.g somevar = Foo
				Pasv2.Deserialiser.Assign(commandstr,rootObject);
			} else {
				var prefix = Pasv2.stringUtils.getPrefix(commandstr,"(");
				if (prefix.indexOf("this.") != -1) {
					//the command is a instance method call
					//e.g root.object1.someFunction(args)
					Pasv2.Deserialiser.evaluateFunction(commandstr,rootObject,rootObject);
				} else {
					//the command is most probly a static class method call
					//e.g SomeClass.someMethod(args)
					Pasv2.Deserialiser.getStaticReference(commandstr,rootObject);
				}
			}
			return true;
		} else {
			return false;
		}

	}
}

}