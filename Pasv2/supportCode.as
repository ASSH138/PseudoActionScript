/*String.prototype.decompileIntoReference = function(thisobj:Object) {
var string = this.valueOf();
trace("decompile")
if (string.indexOf("_global") == -1) {
if (string.indexOf("_root") != -1) {
string = string.removeString("_root.");
var refsarray = string.split(".");
var reference = _root;
var index = 0;
while (refsarray[index] != undefined) {
var childname = refsarray[index];
reference = reference[childname];
index++;
}
//trace(typeof (reference)+reference);
return reference;
}
}
if (string.indexOf("_root") == -1) {
if (string.indexOf("_global") == -1) {
if (thisobj != undefined) {
string = string.removeString("this.");
var refsarray = string.split(".");
var reference = thisobj;
var index = 0;
while (refsarray[index] != undefined) {
var childname = refsarray[index];
reference = reference[childname];
index++;
}
//trace(typeof (reference)+reference);
return reference;
}
}
}
if (string.indexOf("_global") != -1) {
string = string.removeString("_global.");
var refsarray = string.split(".");
var reference = _global;
var index = 0;
while (refsarray[index] != undefined) {
var childname = refsarray[index];
reference = reference[childname];
index++;
}
//trace(typeof (reference)+reference);
return reference;
}
};*/

Array.prototype.removeTrailingNulls=function(){
	do {
		var lastelement= this[this.length-1];
		if (lastelement==null) {
			this.pop();
		}
	}while(lastelement == null&&this.length>0);
}


String.prototype.removeString = function(string:String) {
	var index = this.indexOf(string);
	if (index != -1) {
		var lastindex = index+string.length;
		var newstring = "";
		for (var i = 0; i<this.length; i++) {
			if (i<index || i>=lastindex) {
				var char = this.charAt(i);
				newstring += char;
			}
		}
	} else {
		newstring = this.valueOf();
	}
	return newstring;
};
String.prototype.decompileIntoReferenceParent = function(rootObject:Object, ...rest) {
	try{
	var thisobj=rest[0];
	var reference:Object;
	var refsarray:Array;
	var string = this.valueOf();
	string=string.remove(" ")
	string=string.remove("\r")
	string=string.remove("\n")
	//get rid of whitespaces
	var index:Number
	var childname
	if (string.indexOf("this") != -1) {
		string = string.removeString("this.");
		//string= string.replace("this.",""); /*as3*/
		refsarray = string.split(".");
		reference = rootObject;
		 index = 0;
		refsarray.pop();
		while (refsarray[index] != undefined) {
			childname = refsarray[index];
			trace(rootObject.object2);
			reference = reference[childname];
			index++;
		}
		//trace(typeof (reference)+reference);
		return reference;
	} else if (string.indexOf("this.") != -1) {
		if (thisobj != null) {
			//references a child of the thisobj
			string = string.removeString("this.");
			//string= string.replace("this."""); /*as3*/
			 refsarray = string.split(".");
			refsarray.pop();
			 reference = thisobj;
			index = 0;
			while (refsarray[index] != undefined) {
				
				 childname = refsarray[index];
				
				reference = reference[childname];
				index++;
			}
			//trace(typeof (reference)+reference);
			return reference;
		}
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
	} 
	catch (Err:Error){
		//there is no such reference, return null
		return null;
	}
};
String.prototype.popDot = function() {
	
	var string = this.valueOf();
	string=string.deleteWhiteSpace()
	//test this more optimised code
	/* var indexLastDot:Number =string.lastIndexOf(".");
	var lastrefStr=string.substring(0,indexLastDot);
	return lastrefStr
	*/
	var stringarray = string.split(".");
	var lastref = stringarray.pop();
	lastref = "."+lastref;
	string = string.removeString(lastref);
	return string;
};
String.prototype.shiftDot = function() {
	var string = this.valueOf();
	string=string.deleteWhiteSpace()
	//test this more optimised code
	 var indexFirstDot:Number =string.indexOf(".");
	var firstrefStr=string.substring(indexFirstDot+1,string.length);
	return firstrefStr
	
};
String.prototype.remove = function(char) {
	var chararray = this.split("");
	var newstring = "";
	for (var u = 0; u<chararray.length; u++) {
		if (chararray[u] != char) {
			newstring += String(chararray[u]);
		}
	}
	return newstring.valueOf();
};
String.prototype.decompileIntoReference = function(rootObject:Object,...rest) {
	try{
	var thisobj=rest[0]
	var reference:Object;
	var refsarray:Array;
	
	var index:Number
	var childname
	var string = this.valueOf();
	string=string.remove(" ")
	string=string.remove("\r")
	string=string.remove("\n")
	//get rid of whitespaces
	//get rid of spaces
	if (string.indexOf("this") != -1 || (rootObject is Class)) {
		string = string.removeString("this.");
		//string= string.replace("this.",""); /*as3*/
		 refsarray = string.split(".");
		reference = rootObject;
		 index = 0;
		while (refsarray[index] != undefined) {
			childname = refsarray[index];
			reference = reference[childname];
			index++;
		}
		//trace(typeof (reference)+reference);
		return reference;
	} else if (string.indexOf("this.") != -1) {
		if (thisobj != null) {
			//references a child of the thisobj
			string = string.removeString("this.");
			//string= string.replace("this."""); /*as3*/
			refsarray = string.split(".");
			 reference = thisobj;
			 index = 0;
			while (refsarray[index] != undefined) {
				childname = refsarray[index];
				reference = reference[childname];
				index++;
			}
			//trace(typeof (reference)+reference);
			return reference;
		}
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
	}catch(Err:Error){
		//there is no such reference, return null
		return null;
		
	}
};
String.prototype.deleteWhiteSpace=function(){
	var string=this.valueOf()
string=string.remove(" ")
	string=string.remove("\r")
	string=string.remove("\n")
	//get rid of whitespaces
	return string;
}
String.prototype.getDirectDescendantName=function(wholestring:String){
	var string=this.valueOf()
	string=string.deleteWhiteSpace()
	var indexofstr=wholestring.indexOf(string)
	var dotIndex=wholestring.indexOf(".",indexofstr+string.length);
	var nextDotIndex=wholestring.indexOf(".",dotIndex+1);
	if(nextDotIndex==-1){
		nextDotIndex=wholestring.length;
	}
	var descendantName=wholestring.substring(dotIndex+1,nextDotIndex);
	return descendantName;
}
String.prototype.getRoot=function(){
	//returns the rootmost object of a referencestr
	var string=this.valueOf();
	string=string.deleteWhiteSpace()
	var dotIndex=string.indexOf(".")
	if(dotIndex==-1){
		dotIndex=string.length
	}
	var rootref=string.substring(0,dotIndex);
	rootref=rootref.remove(" ");
	rootref=rootref.remove("\r")
	rootref=rootref.remove("\n")
	return rootref;
}
String.prototype.decompileIntoName = function() {
	var string = this.valueOf();
	string=string.deleteWhiteSpace()
	var stringarray = string.split(".");
	var name = stringarray[stringarray.length-1];
	return name;
};
String.prototype.removeLiterals=function(){
	var string=this.valueOf();
	var withinInverted:Boolean=false
	var withinDoubleInverted:Boolean=false
	var newStr:String=""
	for(var c=0;c<this.length;c++){
		var char = this.charAt(c);
		if(char =="'"){
			withinInverted = !withinInverted;
		}
		else if(char=='"'){
			withinDoubleInverted =!withinDoubleInverted;
		}
		else if(withinInverted!=true&&withinDoubleInverted!=true){
			newStr+=char;
		}
	}
	return newStr;
}
String.prototype.indexOfWithoutLiteral=function(string2){
	//removes the chars in literals and then performs indexOf
	var string=this.valueOf();
	var withinInverted:Boolean=false
	var withinDoubleInverted:Boolean=false
	var newStr:String=""
	for(var c=0;c<this.length;c++){
		var char = this.charAt(c);
		if(char =="'"){
			withinInverted = !withinInverted;
		}
		else if(char=='"'){
			withinDoubleInverted =!withinDoubleInverted;
		}
		else if(withinInverted!=true&&withinDoubleInverted!=true){
			newStr+=char;
		}
	}
	var index= newStr.indexOf(string2);
	return index;
}
String.prototype.getPrefix=function(delineator){
	var string=this.valueOf()
	var charofDelineator=string.indexOf(delineator);
	//testcode
	if(charofDelineator==-1){
		charofDelineator=string.length;
	}
	
	var prefix=string.substring(0,charofDelineator)
	return prefix
	//return "this.objt1"
}
String.prototype.getSuffix=function(delineator){
	var string=this.valueOf()
	var stringarray=string.split(delineator);
	var suffix=stringarray[1];
	if(suffix==undefined){
		suffix=string;
	}
	return suffix
}
//debug
String.prototype.Tracer=function(){
	var string=this.valueOf();
	for(var c=0;c<this.length;c++){
		trace(c+": '"+this.charAt(c)+"'")
	}
};

