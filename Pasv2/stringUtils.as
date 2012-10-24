package Pasv2{

	public class stringUtils {
		public static function removeTrailingNulls(array:Array) {
			do {
				var lastelement = array[array.length - 1];
				if (lastelement==null) {
					array.pop();
				}
			} while (lastelement == null&&array.length>0);
		}
		public static function removeString(baseStr:String ,string:String) {
			var index = baseStr.indexOf(string);
			if (index != -1) {
				var lastindex = index + string.length;
				var newstring = "";
				for (var i = 0; i<baseStr.length; i++) {
					if (i<index || i>=lastindex) {
						var char = baseStr.charAt(i);
						newstring +=  char;
					}
				}
			} else {
				newstring = baseStr.valueOf();
			}
			return newstring;
		}
		public static function decompileIntoReferenceParent(baseStr:String,rootObject:Object, ...rest) {
			try {
				var thisobj = rest[0];
				var reference:Object;
				var refsarray:Array;
				var string = baseStr.valueOf();
				string = Pasv2.stringUtils.remove(string," ");
				string = Pasv2.stringUtils.remove(string,"\r");
				string = Pasv2.stringUtils.remove(string,"\n");
				//get rid of whitespaces
				var index:Number;
				var childname;
				if (string.indexOf("this") != -1) {
					//string = Pasv2.stringUtils.removeString(string,"this.");
					//string= string.replace("this.",""); /*as3*/
					refsarray = string.split(".");
					reference = rootObject;
					index = 1;//0
					refsarray.pop();
					while (refsarray[index] != undefined) {
						childname = refsarray[index];
						trace(rootObject.object2);
						reference = reference[childname];
						index++;
					}
					//trace(typeof (reference)+reference);
					return reference;
				} else if (string.indexOf("root.") != -1) {

					//references a child of the thisobj
					//string = Pasv2.stringUtils.removeString(string,"root.");
					//string= string.replace("this."""); /*as3*/
					refsarray = string.split(".");
					refsarray.pop();
					reference = Pasv2.Deserialiser.globalobj.rootRef;
					index = 1;//0
					while (refsarray[index] != undefined) {

						childname = refsarray[index];

						reference = reference[childname];
						index++;
					}
					//trace(typeof (reference)+reference);
					return reference;

				} else {
					//references a local object on the deserialiser function
					refsarray = string.split(".");
					refsarray.pop();
					reference = Deserialiser.globalobj;
					index = 0;
					while (refsarray[index] != undefined) {
						childname = refsarray[index];
						reference = reference[childname];
						index++;
					}
					//trace(typeof (reference)+reference);
					return reference;
				}
			} catch (Err:Error) {
				//there is no such reference, return null
				return null;
			}
		}
		public static function popDot(baseStr:String) {

			var string = baseStr.valueOf();
			string = Pasv2.stringUtils.deleteWhiteSpace(string);
			//test this more optimised code
			/* var indexLastDot:Number =string.lastIndexOf(".");
			var lastrefStr=string.substring(0,indexLastDot);
			return lastrefStr
			*/
			var stringarray = string.split(".");
			var lastref = stringarray.pop();
			lastref = "." + lastref;
			string = Pasv2.stringUtils.removeString(string,lastref);
			return string;
		}
		public static function shiftDot(baseStr:String) {
			var string = baseStr.valueOf();
			string = Pasv2.stringUtils.deleteWhiteSpace(string);
			//test this more optimised code
			var indexFirstDot:Number = string.indexOf(".");
			var firstrefStr=string.substring(indexFirstDot+1,string.length);
			return firstrefStr;
		}
		public static function remove(baseStr:String ,char) {
			var chararray = baseStr.split("");
			var newstring = "";
			for (var u = 0; u<chararray.length; u++) {
				if (chararray[u] != char) {
					newstring +=  String(chararray[u]);
				}
			}
			return newstring.valueOf();
		}
		public static function decompileIntoReference(baseStr:String,rootObject:Object,...rest) {
			try {
				var thisobj = rest[0];
				var reference:Object;
				var refsarray:Array;

				var index:Number;
				var childname;
				var string = baseStr.valueOf();
				string = Pasv2.stringUtils.remove(string," ");
				string = Pasv2.stringUtils.remove(string,"\r");
				string = Pasv2.stringUtils.remove(string,"\n");
				//get rid of whitespaces
				//get rid of spaces
				if (string.indexOf("this.") != -1 || (rootObject is Class)||string=="this") {
					//DEBUG
					//string = Pasv2.stringUtils.removeString(string,"this.");
					//string= string.replace("this.",""); /*as3*/
					refsarray = string.split(".");
					reference = rootObject;
					index = 1;//0
					if(rootObject is Class){
						index=0;
					}
					while (refsarray[index] != undefined) {
						childname = refsarray[index];
						reference = reference[childname];
						index++;
					}
					//trace(typeof (reference)+reference);
					return reference;
				} else if (string.indexOf("root.") != -1||string=="root") {
					
						//references a child of the thisobj
						//DEBUG
						//string = Pasv2.stringUtils.removeString(string,"root.");
						//string= string.replace("this."""); /*as3*/
						refsarray = string.split(".");
						reference = Pasv2.Deserialiser.globalobj.rootRef;
						if(reference == null){
							
						}
						index = 1;//0
						while (refsarray[index] != undefined) {
							childname = refsarray[index];
							reference = reference[childname];
							index++;
						}
						//trace(typeof (reference)+reference);
						return reference;
					
				} else {
					//references a local object on the deserialiser function
					refsarray = string.split(".");
					reference = Deserialiser.globalobj;
					index = 0;
					while (refsarray[index] != undefined) {
						childname = refsarray[index];
						reference = reference[childname];
						index++;
					}
					//trace(typeof (reference)+reference);
					return reference;
				}
			} catch (Err:Error) {
				//there is no such reference, return null
				return null;

			}
		}
		public static function deleteWhiteSpace(baseStr:String) {
			var string = baseStr.valueOf();
			string = Pasv2.stringUtils.remove(string," ");
			string = Pasv2.stringUtils.remove(string,"\r");
			string = Pasv2.stringUtils.remove(string,"\n");
			//get rid of whitespaces
			return string;
		}
		public static function getDirectDescendantName(baseStr:String,wholestring:String) {
			var string = baseStr.valueOf();
			string = Pasv2.stringUtils.deleteWhiteSpace(string);
			var indexofstr = wholestring.indexOf(string);
			var dotIndex = wholestring.indexOf(".",indexofstr + string.length);
			var nextDotIndex = wholestring.indexOf(".",dotIndex + 1);
			if (nextDotIndex==-1) {
				nextDotIndex = wholestring.length;
			}
			var descendantName=wholestring.substring(dotIndex+1,nextDotIndex);
			return descendantName;
		}
		public static function getRoot(baseStr:String) {
			//returns the rootmost object of a referencestr
			var string = baseStr.valueOf();
			string = Pasv2.stringUtils.deleteWhiteSpace(string);
			var dotIndex = string.indexOf(".");
			if (dotIndex==-1) {
				dotIndex = string.length;
			}
			var rootref = string.substring(0,dotIndex);
			rootref = Pasv2.stringUtils.remove(rootref," ");
			rootref = Pasv2.stringUtils.remove(rootref,"\r");
			rootref = Pasv2.stringUtils.remove(rootref,"\n");
			return rootref;
		}
		public static function decompileIntoName(baseStr:String) {
			var string = baseStr.valueOf();
			string = Pasv2.stringUtils.deleteWhiteSpace(string);
			var stringarray = string.split(".");
			var name = stringarray[stringarray.length - 1];
			return name;
		}
		public static function removeLiterals(baseStr:String) {
			var string = baseStr.valueOf();
			var withinInverted:Boolean = false;
			var withinDoubleInverted:Boolean = false;
			var newStr:String = "";
			for (var c=0; c<baseStr.length; c++) {
				var char = baseStr.charAt(c);
				if (char =="'") {
					withinInverted = ! withinInverted;
				} else if (char=='"') {
					withinDoubleInverted = ! withinDoubleInverted;
				} else if (withinInverted!=true&&withinDoubleInverted!=true) {
					newStr +=  char;
				}
			}
			return newStr;
		}
		public static function indexOfWithoutLiteral(baseStr:String ,string2:String) {
			//removes the chars in literals and then performs indexOf
			var string = baseStr.valueOf();
			var withinInverted:Boolean = false;
			var withinDoubleInverted:Boolean = false;
			var newStr:String = "";
			for (var c=0; c<baseStr.length; c++) {
				var char = baseStr.charAt(c);
				if (char =="'") {
					withinInverted = ! withinInverted;
				} else if (char=='"') {
					withinDoubleInverted = ! withinDoubleInverted;
				} else if (withinInverted!=true&&withinDoubleInverted!=true) {
					newStr +=  char;
				}
			}
			var index = newStr.indexOf(string2);
			return index;
		}
		public static function getPrefix(baseStr:String,delineator) {
			var string = baseStr.valueOf();
			var charofDelineator = string.indexOf(delineator);
			//testcode
			if (charofDelineator==-1) {
				charofDelineator = string.length;
			}

			var prefix = string.substring(0,charofDelineator);
			return prefix;
			//return "this.objt1"
		}
		public static function getSuffix(baseStr:String,delineator) {
			var string = baseStr.valueOf();
			var stringarray = string.split(delineator);
			var suffix = stringarray[1];
			if (suffix==undefined) {
				suffix = string;
			}
			return suffix;
		}
	}

}