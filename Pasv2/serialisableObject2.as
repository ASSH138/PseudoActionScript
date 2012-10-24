
package Pasv2{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import Pas.feederObject;
import flash.display.Sprite;
	public class serialisableObject2 extends Sprite {
		public static var instance = new serialisableObject2();
		public static var feederDictionary= new Dictionary(true);
		//dictionary for class feederObjects
		//to add an element to dictionary, create a feederObject and use the class constructor key
		//e.g feederDictionary(MovieClip.constructor)= new feederObject
		private static const AbbrevDepth:Number = 3;
		//number of depths from the rerenced object to abbreviate
		//e.g depth = 2
		//root.aobject.bobject.cobject.dobject ->
		//RAB.cobject.dobject
		public static var RefsContainer:Dictionary = new Dictionary(true);
		//contains the absolute references of all objects which have absoluteReferences
		//ANY OBJECT YOU WISH TO DEFINE WITH AN ABSOLUTE REFERENCE NEEDS TO BE PUT INTO THIS CONTAINER!
		//How to put an absolute ref into the container:

		//
		//import serialisableObject2;
		//root.newSprite = new Sprite();
		//serialisableObject2.RefsContainer[root.newSprite] = "this.newSprite";
		//if your class extends serialisableObject2, define the absoluteRefString before the super function
		// and by default, the serialisableObject2 constructor will put an entry into RefsCOntainer
		//if you wish to define absoluteRefString outside the subclass constructor, you must manually put
		//the object into the RefsContainer;

		public static var globalobj:Object = {};
		globalobj.is_Empty=function(){
		var numberprops:Number=0;
		var iteratedObjects=serialisableObject2.globalobj.iteratedObjects;
		for each  (var ref in iteratedObjects){
		numberprops++;
		if(numberprops>0){
		break;
		}
		
		}
		if(numberprops>0){
		return false;
		}else{
		return true;
		}
		};
		globalobj.codeBlock = "";
		globalobj.localIDs = {};
		//contains the objects which the serialiser has iterated over
		globalobj.iteratedObjects = new Dictionary(false);
		globalobj.refTags = new Dictionary(false);
		//a global object to hold information about serialisation functions;
		globalobj.importDefs = {};
		//contains imported definitions
		public var absoluteRefString:String = null;
		//a string representing the absolute reference of the  object
		//overwrite in a subclasses constructor function
		//e.g public function subClass (){
		//this.absoluteRefString = root.containerObj.thisname;

		protected var isCommentable:Boolean = false;
		//set this var in subclasses
		//turn on if you want auto comments to describe how the object is serialised
		//turn off if you dont want  comments in the serialised object code
		public var customComments:String = "";
		//custom comments to describe the serialised class objects
		//set in subclasses 
		public var dynamicVarNames:Array = [];
		//a subclass must set dynamicVarNames 
		//to contain the names of vars which are dynamic
		//i.e likely to change after the class object is instantiated
		//by default, all properties are non dynamic, not assumed to change during runtime
		//a variable is considered dynamic if ANY OF ITS PROPERTIES CHANGE!
		//e.g  object.var1 ={};
		//      object.var1.x = 3;
		//     //then some external code changes object.var1.x
		//       object.var1.x =5;
		//      object.var1 is CONSIDERED DYNAMIC even though Object.var1 still refers to the same object
		public var paramsArray:Array = [];
		//the array representing the params passed into the constructor function 
		public var addCodeFunction:Function=function():String{ return ""};
		//function that will add additional code to the serialisation of the object
		//e.g addChild(thisObj);
		public function serialisableObject2(... rest) {
			//rest = all the params used to initialise a subclass
			var paramS:Array=[];
			for(var i=0;i<rest.length;i++){
				if(rest[i]!=undefined){
					paramS[i]=rest[i];
				}
			}
			this.paramsArray = paramS;
			if (this.absoluteRefString != null) {
				serialisableObject2.RefsContainer[this] = this.absoluteRefString;
			}
			// constructor code



		}
		//autoformats the pas code
		public static function autoFormat(string:String){
			//replace the \r\r
			while(string.indexOf("\r\r")!=-1){
				string=string.replace("\r\r","\r");
			}
			return string
		}
		//call to add an entry into the refscontainer
		public static function addRefEntry(obj:Object,refStr:String){
			Pasv2.serialisableObject2.RefsContainer[obj]=refStr;
		}
		//duplicates the feederEntry for the object upon deserialisation
		public static function addFeederEntry(obj:Object,feederObj:Pasv2.feederObject){
			var ref:Object=obj;
			Pasv2.serialisableObject2.feederDictionary[obj]=feederObj;
		}
		//generate feeder object for non serialisableObject2s
		public static function generateFeederObject(prop:Object):Pasv2.feederObject {
			var paramA:Array = [];
		var feederdict1:Pasv2.feederObject= serialisableObject2.feederDictionary[prop];
			var feederdict:Pasv2.feederObject = serialisableObject2.feederDictionary[prop.constructor];
			if (prop.hasOwnProperty("paramsArray") && prop.paramsArray != null) {
				paramA = prop.paramsArray;
			}else if (feederdict1!=null&&feederdict1.hasOwnProperty("paramsArray")) {
				paramA=feederdict1.paramsArray.concat();
			} else if (feederdict!=null&&feederdict.hasOwnProperty("paramsArray")) {
				for(var p=0;p<feederdict.paramsArray.length;p++){
					var paramName = feederdict.paramsArray[p];
					var param=  prop[paramName];
					paramA.push(param);
				}
				
			}
			var dynVA:Array = [];

			if (prop.hasOwnProperty("dynamicVarNames") && prop.dynamicVarNames != null) {
				dynVA = prop.dynamicVarNames;
			}else if (feederdict1!=null&&feederdict1.hasOwnProperty("dynamicVarNames")) {
				dynVA = feederdict1.dynamicVarNames.concat();
			
			} else if (feederdict!=null&&feederdict.hasOwnProperty("dynamicVarNames")) {
				dynVA = feederdict.dynamicVarNames.concat();
			}
			var cC:String = "";
			if (prop.hasOwnProperty("customComments") && prop.customComments != null) {
				cC = prop.customComments;
				} else if (feederdict1!=null&&feederdict1.hasOwnProperty("customComments")) {
				cC = feederdict1.customcomments;
			
			} else if (feederdict!=null&&feederdict.hasOwnProperty("customComments")) {
				cC = feederdict.customcomments;
			}
			var feeder= new Pasv2.feederObject(paramA,dynVA,cC);
			return feeder;
		}

		public static function initAbsoluteRefTags():void {
			//loop thru refsContainer and assign a reftag to all the objects with absolute references
			var refCont = serialisableObject2.RefsContainer;
			var refTags = serialisableObject2.globalobj.refTags;
			for (var Ref:* in refCont) {
				var absoluteReference = refCont[Ref];
				refTags[Ref] = absoluteReference;
			}
		}
		public static function resetGlobalObj():void {
			serialisableObject2.globalobj = {};
			serialisableObject2.globalobj.is_Empty=function(){
			var numberprops:Number=0;
			var iteratedObjects=serialisableObject2.globalobj.iteratedObjects;
			for each  (var ref:String in iteratedObjects){
			numberprops++;
			if(numberprops>0){
			break;
			}
			
			}
			if(numberprops>0){
			return false;
			}else{
			return true;
			}
			};
			serialisableObject2.globalobj.codeBlock = "";
			serialisableObject2.globalobj.localIDs = {};
			serialisableObject2.globalobj.importDefs = {};
			//contains the objects which the serialiser has iterated over
			serialisableObject2.globalobj.iteratedObjects = new Dictionary(false);
			serialisableObject2.globalobj.refTags = new Dictionary(false);
		}

		public static function getIteratedReference(object:Object) {
			//loops over iteratedObjects to see if the object has been serialised before
			var iteratedObjects = serialisableObject2.globalobj.iteratedObjects;
			if (iteratedObjects[object] != null) {
				return iteratedObjects[object];
			} else {
				return null;
			}

		}
		public static function isTop():Boolean {
			//returns a boolean to determine if the serialise function is called externally 
			//or as part of a recursive serialise/serialisableObject2.serialiseChildren call
			var globalobj = serialisableObject2.globalobj;
			if (globalobj.codeBlock == "" && globalobj.is_Empty() == true) {

				return true;
			} else {
				return false;
			}
		}
		/*
		//example
		object1={};
		object2={};
		root.object1.child =object2;
		object2.parent=root.object1;
		
		//recursive
		
		*/
		//abbreviates a long ref and returns it as a shorter ref by abbreviating the parents
		//into a local
		//e.g root.ac.bc.cc.dc.ec -> RABCD.ec 
		//-> var RABCD = root.ac.bc.cc.dc
		public static function abbrevLocalRef(referencestr:String) {
			var globalobj = serialisableObject2.globalobj;
			var returnObj:Object = {};
			
			var dotarray:Array = referencestr.split(".");
			var postAbbrevStr:String = "";
			for(var i=dotarray.length-1;i>=dotarray.length-serialisableObject2.AbbrevDepth;i--){;
			// 1 iteration, root.ac.bc.cc.dc.ec -> root.ac.bc.cc.dc
			//postAbbrevStr = ec
			//2nd iteration
			//-> postAbbrevStr = dc.ec
			var lastrefStr:String = dotarray[i];
			if (i==dotarray.length-1) {
				postAbbrevStr = lastrefStr + postAbbrevStr;
			} else {
				postAbbrevStr = lastrefStr + "." + postAbbrevStr;
			}
			if (i<=0) {
				// the absolute ref is shortened enough, no need to abbreivate
				returnObj.shortenedRef = postAbbrevStr;
				returnObj.assignmentCommand = "";
				return returnObj;
			}
		}
		dotarray = dotarray.slice(0,i + 1);
		//now reconstruct the references that have been abbreviated and the abbreivation
		//dotarray -> [root,ac,bc,cc]
		var abbrevRef:String = "";
		var extAbbrevRef:String = "";
		//the identifier for the local var, and the extended name for it
		//start from one to d
		for (var i2=0; i2<dotarray.length; i2++) {
			var refStr:String = dotarray[i2];

			if (refStr!="this") {
				var charInd:uint=1;
				var capsChar:String=refStr.charAt(0).toUpperCase();
				//generate a capital string
				while(true){
					
					var chard=refStr.charAt(charInd)
					var caps=chard.toUpperCase();
					if(chard==caps){
						capsChar+=caps;
						
					}else{
						break;
					}
					charInd++;
					if(charInd>=refStr.length){
						break;
					}
				}
				abbrevRef+=capsChar;
				//var firstchar = String(refStr.charAt(0)).toUpperCase();
				//abbrevRef +=  firstchar;
			}
			if (i2 <=0) {
				//dont add the dot
				extAbbrevRef +=  refStr;
			} else {
				
				extAbbrevRef +=  "." + refStr;
			}
		}
		if (globalobj.localIDs[abbrevRef] == null) {
			globalobj.localIDs[abbrevRef] = true;
			if (abbrevRef.length > 0) {
				returnObj.shortenedRef = abbrevRef + "." + postAbbrevStr;
				returnObj.assignmentCommand = "\rvar " + abbrevRef + " = " + extAbbrevRef + ";";
			} else {
				returnObj.shortenedRef = extAbbrevRef + "." + postAbbrevStr;
				returnObj.assignmentCommand = "";
			}

			return returnObj;

		} else {
			var postfix:Number = 1;
			while (globalobj.localIDs[abbrevRef+String(postfix)]!=null) {
				postfix++;
				if (postfix>Number("1e5")) {
					break;
				}
			}
			var abbrevRef2 = abbrevRef + String(postfix);
			globalobj.localIDs[abbrevRef2] = true;
			if (abbrevRef.length > 0) {
				returnObj.shortenedRef = abbrevRef2 + "." + postAbbrevStr;
				returnObj.assignmentCommand = "\rvar" + abbrevRef2 + " = " + extAbbrevRef + ";";
			} else {
				returnObj.shortenedRef = extAbbrevRef + "." + postAbbrevStr;
				returnObj.assignmentCommand = "";
			}

			return returnObj;
		}
	}
	//used to generate succinct, but identifiable and unique localvar IDs
	//DEPRECATED. USE THE ABBREVLOCALREF FUNCTION TO ABBREVIATE PARENTS REFS
	public static function generateLocalID(referenceStr:String):String {
		//accepts a referenceStr and turns it into an abbreviation
		var globalobj = serialisableObject2.globalobj;
		var workStr = referenceStr;
		workStr = workStr.replace("this.","");
		while (workStr.indexOf(".")!=-1) {
			workStr = workStr.replace(".","_");
		}
		//gets rid of the root
		var dotelementsArray:Array = workStr.split("_");
		//animal.elephant.trunk -> a_e_t
		//take each element of the array and get the first char
		var abbrevRef:String = "";
		for (var d= 0; d<dotelementsArray.length; d++) {
			var dotelement = dotelementsArray[d];
			var firstChar = dotelement.charAt(0);
			if (d==dotelementsArray.length-1) {
				firstChar = dotelement;
			}
			if (d==0) {
				abbrevRef +=  firstChar;
			} else {
				abbrevRef +=  "_" + firstChar;
			}
		}
		if (globalobj.localIDs[abbrevRef] == null) {
			// globalobj.localIDs[abbrevRef]=true;
			return abbrevRef;
		} else {
			var postfix:Number = 1;
			while (globalobj.localIDs[abbrevRef+String("_"+postfix)]!=null) {
				postfix++;
				if (postfix>Number("1e5")) {
					break;
				}
			}
			var abbrevRef2=abbrevRef+String("_"+postfix);
			//  globalobj.localIDs[abbrevRef2]=true;
			return abbrevRef2;
		}

	}


	public function serialise(referenceStr:String,includeVar:Boolean =false,isTopParam=false,thisObject:Object=null,feederObject:Pasv2.feederObject = null) {
		//is Top = whether this  serialise callwas the starter serialise function for the whole chain of serialise

		//thisObject = invoke serialise as part of a call of another object, for non serialisable objects.
		//deprecated
		var isTop:Boolean = serialisableObject2.isTop();
		if (isTop==true&&isTopParam!=false) {
			serialisableObject2.initAbsoluteRefTags();
		}
		var globalobj = serialisableObject2.globalobj;
		globalobj.iteratedObjects[this] = String(referenceStr);
		var header:String = "";
		//create local vars to represent complex object vars in the params
		var paramsStr:String = "(";
		//the paramsStr  string contains the serialised expressions of all the
		//arguments of the constructor function 
		//a completed paramStr should have the format (arg1,arg2,arg3)
		var paramsArrayy:Array = [];
		if (this.hasOwnProperty("paramsArray")) {
			paramsArrayy = this.paramsArray;
		} else if (feederObject!=null) {
			paramsArrayy = feederObject.paramsArray;
		}
		var paramLocalDefStr:String="";
		for (var p=0; p<paramsArrayy.length; p++) {
			var param = paramsArrayy[p];
			if (param is Function) {
				//skip functions, coz there is no way to serialise them,
				continue;
			}
			var commaStr:String = ",";
			if ((p == 0)) {
				commaStr = "";
			}
			if (param == null) {
				paramsStr +=  commaStr + "null";
				if(this.addCodeFunction()!=""){
						//create a local variable to represent the param for the addCodeFUnction to use
						var localVarStr:String="arg"+p;
						var varString:String= "var "+localVarStr+" = null;"
						paramLocalDefStr+="\r"+varString;
					}
				continue;
			}
			if (typeof param != "object") {
				//its a primitive datatype. return its String value

				var paramStringValue:String = param.toString();
				if (param is String) {
					paramStringValue = '"' + paramStringValue + '"';
				}
				paramsStr +=  commaStr + paramStringValue;
				if(this.addCodeFunction()!=""){
						//create a local variable to represent the param for the addCodeFUnction to use
						var localVarStr:String="arg"+p;
						var varString:String= "var "+localVarStr+" = "+paramStringValue+";"
						paramLocalDefStr+="\r"+varString;
					}

			} else {
				// the param  is a complex datatype, with properties
				//check to see if its a standalone object or a reference to some place else
				var inRefsContainer:Boolean=false;
				//whether the reference is found in a  refs container, serialise the refs container entry
				//in that case
				var paramRefStr = "";
				var parentref = referenceStr;
				if (param.hasOwnProperty("absoluteRefString") && param.absoluteRefString != null) {
					paramRefStr = param.absoluteRefString;
					paramsStr +=  commaStr + paramRefStr;
					//add a reftag to the globalobj, to tell future serialisations to include
					//a direct reference assignment in the next time the object is encounterd

					//continue;
				} else if (serialisableObject2.RefsContainer[param]!=null) {
					//an aobsolute ref cannot be found, but RefsContainer contains a ref to the param
					paramRefStr = serialisableObject2.RefsContainer[param];
					paramsStr +=  commaStr + paramRefStr;
					
				}
				//if the absolute reference of the dynamic var includes referenceStr as a parent
				//the dynamic var is a child of this object, and not a reference to someplace else
				//create it anyway.

				if (paramRefStr=="") {

					var referenceOfIteratedObj:String = serialisableObject2.getIteratedReference(param);
					var localInitStr2:String = "";
					if (referenceOfIteratedObj==null) {
						var localID = serialisableObject2.generateLocalID(referenceStr);
						var paramRefStr = localID + "_arg" + p;

						//paramRefStr = serialisableObject2.generateLocalID(referenceStr + "." + paramName);
						//globalobj.localIDs[paramRefStr] = param;

						if (param.hasOwnProperty("serialise")&&param.serialise is Function) {
							localInitStr2 = param.serialise(paramRefStr,true);

							//the Pas to initialise the entire localvar , and add paramerties
							//be sure to add the prototype serialise functions to objects and arrays first
							//before this function is called!
						} else {
							  var feederObjp:Pasv2.feederObject= Pasv2.serialisableObject2.generateFeederObject(param);
                     localInitStr2 = Pasv2.serialisableObject2.serialiseObject(param,paramRefStr,true,false,feederObjp);
							
						}
					} else {
						paramRefStr = referenceOfIteratedObj;
					}
					header +=  localInitStr2;
					if (paramRefStr!=null&&paramRefStr!="") {
						paramsStr +=  commaStr + paramRefStr;
					}
					
					//the assignment for the object
                    if(this.addCodeFunction()!=""){
						//create a local variable to represent the param for the addCodeFUnction to use
						var localVarStr:String="arg"+p;
						var varString:String= "var "+localVarStr+" = "+paramRefStr+";";
						paramLocalDefStr+="\r"+varString;
					}
				}
			}

		}
		paramsStr +=  ")";
		var varStr:String = "";
           if (includeVar==true) {
          varStr = "var ";
            }
		//initialise the object class
		
		var assignStr:String = "";
		
		//a string representing the assignment statement for this object
		var thisClassDefStr = getQualifiedClassName(this);
		//if the class resides in a package, the  :: will be seen in thisclassDef
		var indexOfColonColon:Number = thisClassDefStr.indexOf("::");
		var thisClassName:String = "Object";
		//thisClassname is by default object if the object is not a class member
		if ((indexOfColonColon != -1)) {
			//the class resides in a package. 
			//remove the colon colon and replace it with a dot
			thisClassDefStr = thisClassDefStr.replace("::",".");


			//check to see if the whole serialised code block contains an import statement
			var ImportClassDefIncluded = globalobj.importDefs[thisClassDefStr];
			if (ImportClassDefIncluded==null) {
				//add an import statement to the very top of the codeBlock
				globalobj.importDefs[thisClassDefStr] = true;
				header = "\r import " + thisClassDefStr + ";\r" + header;

			}
			//now, since the package definition has been imported, reduce the fully qualified name
			// to simply classname
			thisClassName = Pasv2.stringUtils.decompileIntoName(thisClassDefStr);

		} else {
			//the class is not in a package
			thisClassName = thisClassDefStr;
		}
		var refAssignStr:String="";
		
	    if(this.absoluteRefString==null){
		if(Pasv2.serialisableObject2.RefsContainer[this]!=null){
			var importPasV2Str:String="";
			if(globalobj.importDefs["Pasv2.serialisableObject2"]==null){
				globalobj.importDefs["Pasv2.serialisableObject2"]=true;
				importPasV2Str="\r import Pasv2.serialisableObject2;"
			}
			//this object is serialised from a refsContainer entry, add the refsContainer
			//assignment to the serialisation, so PasD will add the entry
			refAssignStr=importPasV2Str+"\r Pasv2.serialisableObject2.addRefEntry("+referenceStr+",'"+referenceStr+"');";
		   }
	       }
		   
		assignStr +=  "\r" +varStr+ referenceStr + " = new " + thisClassName + paramsStr + ";";
		assignStr+=refAssignStr
		if(this.addCodeFunction()!=""){
						//create a local variable to represent the param for the addCodeFUnction to use
						var localVarStr:String="this_Object";
						var varString:String= "var "+localVarStr+" = "+referenceStr+';';
						assignStr+="\r"+varString;
					}
		//iterate the dynamic vars
		var footer:String = "";
		var dynamicVars:Array = [];
		if (this.hasOwnProperty("dynamicVarNames") && this.dynamicVarNames != null) {
			dynamicVars = this.dynamicVarNames.concat();
		}
		for (var propName in this) {
			var prop = this[propName];
			if (prop ==this) {
				continue;
			}
			if (prop is Function) {
				//skip functions, coz there is no way to serialise them,
				continue;
			}
			if (dynamicVars.indexOf(propName) == -1) {
				dynamicVars.push(propName);
			}
		}
		for (var d=0; d<dynamicVars.length; d++) {
			var propName = dynamicVars[d];
			var prop:Object = this[propName];
			if (prop ==null) {
				continue;
			}
			if (prop ==this) {
				continue;
			}
			if (prop is Function) {
				//skip functions, coz there is no way to serialise them,
				continue;
			}
			if (typeof prop != "object") {
				//its a primitive datatype. return its String value

				var propStringValue:String = prop.toString();
				if (prop is String) {
					propStringValue = '"' + propStringValue + '"';
				}
				footer +=  "\r" + referenceStr + "." + propName + " = " + propStringValue + ";";

			} else {
				// the dynamic var is a complex datatype, with properties
				//check to see if its a standalone object or a reference to some place else
				var propRefStr = "";
				var parentref = referenceStr;
				if (prop.hasOwnProperty("absoluteRefString") && prop.absoluteRefString != null) {
					propRefStr = prop.absoluteRefString;


					if (Pasv2.stringUtils.getDirectDescendantName(parentref,propRefStr) != propName) {
						footer +=  "\r" + referenceStr + "." + propName + " = " + propRefStr + ";";
						//add a reftag to the globalobj, to tell future serialisations to include
						//a direct reference assignment in the next time the object is encounterd
						globalobj.refTags[prop] = referenceStr + "." + propName;
						//continue;
					}
				} else if (serialisableObject2.RefsContainer[prop]!=null) {
					//an aobsolute ref cannot be found, but RefsContainer contains a ref to the param
					propRefStr = serialisableObject2.RefsContainer[prop];

					if (Pasv2.stringUtils.getDirectDescendantName(parentref,propRefStr) != propName) {
						footer +=  "\r" + referenceStr + "." + propName + " = " + propRefStr + ";";
						globalobj.refTags[prop] = referenceStr + "." + propName;
						//continue;
					}
				}
				//if the absolute reference of the dynamic var includes referenceStr as a parent
				//the dynamic var is a child of this object, and not a reference to someplace else
				//create it anyway.

				if (propRefStr==""||Pasv2.stringUtils.getDirectDescendantName(parentref,propRefStr)==propName) {

					var referenceOfIteratedObj:String = serialisableObject2.getIteratedReference(prop);
					var localInitStr2:String = "";
					if (referenceOfIteratedObj==null) {
						var abbrevobj:Object=serialisableObject2.abbrevLocalRef(referenceStr+"."+propName);
						var abbrevref:String = abbrevobj.shortenedRef;
						var assignmentCommand:String = abbrevobj.assignmentCommand;
						footer +=  assignmentCommand;

						//propRefStr = serialisableObject2.generateLocalID(referenceStr + "." + propName);
						//globalobj.localIDs[propRefStr] = prop;

						if (prop.hasOwnProperty("serialise")&&prop.serialise is Function) {
							localInitStr2 = prop.serialise(abbrevref);

							//the Pas to initialise the entire localvar , and add properties
							//be sure to add the prototype serialise functions to objects and arrays first
							//before this function is called!
						} else {
							  var feederObj:Pasv2.feederObject= Pasv2.serialisableObject2.generateFeederObject(prop);
                     localInitStr2 = Pasv2.serialisableObject2.serialiseObject(prop,abbrevref,false,false,feederObj);
						}
					} else {
						propRefStr = referenceOfIteratedObj;
					}
					footer +=  localInitStr2;
					if (propRefStr!=null&&propRefStr!=""&&localInitStr2=="") {
						footer +=  "\r" + referenceStr + "." + propName + " = " + propRefStr + ";";
					}
					//the assignment for the object

				}
			}

		}
		var customcomments:String="";
		if (this.hasOwnProperty("customComments") && this.customComments != null) {
			customcomments = "\r" + this.customComments;
		}
		var addCode:String="\r"+this.addCodeFunction();
		var buildstr:String = customcomments+header+paramLocalDefStr + assignStr +addCode+ footer;
		//check for a reftag to include a absolute reference to this
		if (globalobj.refTags[this] != null) {
			buildstr +=  "\r" + globalobj.refTags[this] + " = " + referenceStr + ";";
		}
		if (isTop==true&&isTopParam!=false) {
			serialisableObject2.resetGlobalObj();
		}
		return buildstr;
	}
	//a global function for non serialisableObject2s
	public static function serialiseObject(thisObject:Object,referenceStr:String,includeVar:Boolean =false,isTopParam=false,feederObject:Pasv2.feederObject=null) {
		//is Top = whether this  serialise callwas the starter serialise function for the whole chain of serialise
if(feederObject ==null){
	feederObject = Pasv2.serialisableObject2.generateFeederObject(thisObject);
}
		//thisObject = invoke serialise as part of a call of another object, for non serialisable objects.
		var isTop:Boolean = serialisableObject2.isTop();
		if (isTop==true&&isTopParam!=false) {
			serialisableObject2.initAbsoluteRefTags();
		}
		var globalobj = serialisableObject2.globalobj;
		globalobj.iteratedObjects[thisObject] = String(referenceStr);
		var header:String = "";
		//create local vars to represent complex object vars in the params
		var paramsStr:String = "(";
		//the paramsStr  string contains the serialised expressions of all the
		//arguments of the constructor function 
		//a completed paramStr should have the format (arg1,arg2,arg3)
		var paramsArrayy:Array = [];
		if (thisObject.hasOwnProperty("paramsArray")) {
			paramsArrayy = thisObject.paramsArray;
		} else if (feederObject!=null) {
			paramsArrayy = feederObject.paramsArray;
		}
		for (var p=0; p<paramsArrayy.length; p++) {
			var param = paramsArrayy[p];
			if (param is Function) {
				//skip functions, coz there is no way to serialise them,
				continue;
			}
			var commaStr:String = ",";
			if ((p == 0)) {
				commaStr = "";
			}
			if (param == null) {
				paramsStr +=  commaStr + "null";
			}
			if (typeof param != "object") {
				//its a primitive datatype. return its String value

				var paramStringValue:String = param.toString();
				if (param is String) {
					paramStringValue = '"' + paramStringValue + '"';
				}
				paramsStr +=  commaStr + paramStringValue;

			} else {
				// the param  is a complex datatype, with properties
				//check to see if its a standalone object or a reference to some place else
				var paramRefStr = "";
				var parentref = referenceStr;
				if (param.hasOwnProperty("absoluteRefString") && param.absoluteRefString != null) {
					paramRefStr = param.absoluteRefString;
					paramsStr +=  commaStr + paramRefStr;
					//add a reftag to the globalobj, to tell future serialisations to include
					//a direct reference assignment in the next time the object is encounterd

					//continue;
				} else if (serialisableObject2.RefsContainer[param]!=null) {
					//an aobsolute ref cannot be found, but RefsContainer contains a ref to the param
					paramRefStr = serialisableObject2.RefsContainer[param];
					paramsStr +=  commaStr + paramRefStr;
				}
				//if the absolute reference of the dynamic var includes referenceStr as a parent
				//the dynamic var is a child of this object, and not a reference to someplace else
				//create it anyway.

				if (paramRefStr=="") {

					var referenceOfIteratedObj:String = serialisableObject2.getIteratedReference(param);
					var localInitStr2:String = "";
					if (referenceOfIteratedObj==null) {
						var localID = serialisableObject2.generateLocalID(referenceStr);
						var paramRefStr = localID + "_arg" + p;

						//paramRefStr = serialisableObject2.generateLocalID(referenceStr + "." + paramName);
						//globalobj.localIDs[paramRefStr] = param;

						if (param.hasOwnProperty("serialise")&&param.serialise is Function) {
							localInitStr2 = param.serialise(paramRefStr,true);

							//the Pas to initialise the entire localvar , and add paramerties
							//be sure to add the prototype serialise functions to objects and arrays first
							//before this function is called!
						} else {
							 var feederObjp:Pasv2.feederObject= Pasv2.serialisableObject2.generateFeederObject(param);
                     localInitStr2 = Pasv2.serialisableObject2.serialiseObject(param,paramRefStr,true,false,feederObjp);
						}
					} else {
						paramRefStr = referenceOfIteratedObj;
					}
					header +=  localInitStr2;
					if (paramRefStr!=null&&paramRefStr!="") {
						paramsStr +=  commaStr + paramRefStr;
					}
					//the assignment for the object

				}
			}

		}
		paramsStr +=  ")";
		//initialise the object class
		var varStr:String = "";
           if (includeVar==true) {
          varStr = "var ";
            }
		var assignStr:String = "";
		//a string representing the assignment statement for this object
		var thisClassDefStr = getQualifiedClassName(thisObject);
		//if the class resides in a package, the  :: will be seen in thisclassDef
		var indexOfColonColon:Number = thisClassDefStr.indexOf("::");
		var thisClassName:String = "Object";
		//thisClassname is by default object if the object is not a class member
		if ((indexOfColonColon != -1)) {
			//the class resides in a package. 
			//remove the colon colon and replace it with a dot
			thisClassDefStr = thisClassDefStr.replace("::",".");


			//check to see if the whole serialised code block contains an import statement
			var ImportClassDefIncluded = globalobj.importDefs[thisClassDefStr];
			if (ImportClassDefIncluded==null) {
				//add an import statement to the very top of the codeBlock
				globalobj.importDefs[thisClassDefStr] = true;
				header = "\r import " + thisClassDefStr + ";\r" + header;

			}
			//now, since the package definition has been imported, reduce the fully qualified name
			// to simply classname
			thisClassName = Pasv2.stringUtils.decompileIntoName(thisClassDefStr);

		} else {
			//the class is not in a package
			thisClassName = thisClassDefStr;
		}
		var refAssignStr:String="";
		
	    if(!thisObject.hasOwnProperty("absoluteRefString")||thisObject.absoluteRefString==null){
		if(Pasv2.serialisableObject2.RefsContainer[thisObject]!=null){
			var importPasV2Str:String="";
			if(globalobj.importDefs["Pasv2.serialisableObject2"]==null){
				globalobj.importDefs["Pasv2.serialisableObject2"]=true;
				importPasV2Str="\r import Pasv2.serialisableObject2;"
			}
			//this object is serialised from a refsContainer entry, add the refsContainer
			//assignment to the serialisation, so PasD will add the entry
			refAssignStr=importPasV2Str+"\r Pasv2.serialisableObject2.addRefEntry("+referenceStr+",'"+referenceStr+"');";
		   }
	       }
		assignStr +=  "\r" +varStr+ referenceStr + " = new " + thisClassName + paramsStr + ";";
		assignStr+=refAssignStr;
		//iterate the dynamic vars
		var footer:String = "";
		var dynamicVars:Array = [];
		if (thisObject.hasOwnProperty("dynamicVarNames") && thisObject.dynamicVarNames != null) {
			dynamicVars = thisObject.dynamicVarNames.concat();
		} else if (feederObject.dynamicVarNames!=null) {
			dynamicVars = feederObject.dynamicVarNames;
		}
		for (var propName in thisObject) {
			var prop = thisObject[propName];
			if (prop ==thisObject) {
				continue;
			}
			if (prop is Function) {
				//skip functions, coz there is no way to serialise them,
				continue;
			}
			if (dynamicVars.indexOf(propName) == -1) {
				dynamicVars.push(propName);
			}
		}
		for (var d=0; d<dynamicVars.length; d++) {
			var propName = dynamicVars[d];
			var prop:Object = thisObject[propName];
			if (prop ==null) {
				continue;
			}
			if (prop ==thisObject) {
				continue;
			}
			if (prop is Function) {
				//skip functions, coz there is no way to serialise them,
				continue;
			}
			if (typeof prop != "object") {
				//its a primitive datatype. return its String value

				var propStringValue:String = prop.toString();
				if (prop is String) {
					propStringValue = '"' + propStringValue + '"';
				}
				footer +=  "\r" + referenceStr + "." + propName + " = " + propStringValue + ";";

			} else {
				// the dynamic var is a complex datatype, with properties
				//check to see if its a standalone object or a reference to some place else
				var propRefStr = "";
				var parentref = referenceStr;
				if (prop.hasOwnProperty("absoluteRefString") && prop.absoluteRefString != null) {
					propRefStr = prop.absoluteRefString;


					if (Pasv2.stringUtils.getDirectDescendantName(parentref,propRefStr) != propName) {
						footer +=  "\r" + referenceStr + "." + propName + " = " + propRefStr + ";";
						//add a reftag to the globalobj, to tell future serialisations to include
						//a direct reference assignment in the next time the object is encounterd
						globalobj.refTags[prop] = referenceStr + "." + propName;
						//continue;
					}
				} else if (serialisableObject2.RefsContainer[prop]!=null) {
					//an aobsolute ref cannot be found, but RefsContainer contains a ref to the param
					propRefStr = serialisableObject2.RefsContainer[prop];

					if (Pasv2.stringUtils.getDirectDescendantName(parentref,propRefStr) != propName) {
						footer +=  "\r" + referenceStr + "." + propName + " = " + propRefStr + ";";
						globalobj.refTags[prop] = referenceStr + "." + propName;
						//continue;
					}
				}
				//if the absolute reference of the dynamic var includes referenceStr as a parent
				//the dynamic var is a child of this object, and not a reference to someplace else
				//create it anyway.

				if (propRefStr==""||Pasv2.stringUtils.getDirectDescendantName(parentref,propRefStr)==propName) {

					var referenceOfIteratedObj:String = serialisableObject2.getIteratedReference(prop);
					var localInitStr2:String = "";
					if (referenceOfIteratedObj==null) {
						var abbrevobj:Object=serialisableObject2.abbrevLocalRef(referenceStr+"."+propName);
						var abbrevref:String = abbrevobj.shortenedRef;
						var assignmentCommand:String = abbrevobj.assignmentCommand;
						footer +=  assignmentCommand;

						//propRefStr = serialisableObject2.generateLocalID(referenceStr + "." + propName);
						//globalobj.localIDs[propRefStr] = prop;

						if (prop.hasOwnProperty("serialise")&&prop.serialise is Function) {
							localInitStr2 = prop.serialise(abbrevref);

							//the Pas to initialise the entire localvar , and add properties
							//be sure to add the prototype serialise functions to objects and arrays first
							//before this function is called!
						} else {
							//use the global serialise command

                    var feederObj:Pasv2.feederObject= Pasv2.serialisableObject2.generateFeederObject(prop);
                     localInitStr2 = Pasv2.serialisableObject2.serialiseObject(prop,abbrevref,false,false,feederObj);
							
						}
					} else {
						propRefStr = referenceOfIteratedObj;
					}
					footer +=  localInitStr2;
					if (propRefStr!=null&&propRefStr!=""&&localInitStr2=="") {
						footer +=  "\r" + referenceStr + "." + propName + " = " + propRefStr + ";";
					}
					//the assignment for the object

				}
			}

		}
		
		var customcomments:String = "";
		var customcomments:String = "";
		if (thisObject.hasOwnProperty("customComments") && thisObject.customComments != null) {
			customcomments = "\r" + thisObject.customComments;
		} else if (feederObject.customcomments!=null) {
			customcomments = "\r" + feederObject.customcomments;
		}
		var buildstr:String = customcomments + header + assignStr + footer;
		//check for a reftag to include a absolute reference to this
		if (globalobj.refTags[thisObject] != null) {
			buildstr +=  "\r" + globalobj.refTags[thisObject] + " = " + referenceStr + ";";
		}
		if (isTop==true&&isTopParam!=false) {
			serialisableObject2.resetGlobalObj();
		}
		return buildstr;
	}


}

}
//deprecated code
/*public function serialise2(referenceStr:String):String {
var isTop:Boolean = serialisableObject2.isTop();
//if this is a topmost function, reset the global object at the end
//rest=[customcomments]
var globalobj = serialisableObject2.globalobj;

//whatever custom comments to describe your serialised object.
//comments must include // every line!



//comments the serialiser automatically generates to describe the object

//referenceStr is a String referring to the reference of the object that is to be serialised
//for example if  root.newclass is serialised , the reference is "this.newclass".
var header:String = "";
//create local vars to represent complex object vars in the params
var paramsStr:String = "(";
//the paramsStr  string contains the serialised expressions of all the
//arguments of the constructor function 
//a completed paramStr should have the format (arg1,arg2,arg3)
for (var p = 0; p < this.paramsArray.length; p++) {
var param = this.paramsArray[p];


var commaStr:String = ",";
if ((p == 0)) {
commaStr = "";
}
if (param == null) {
paramsStr +=  commaStr + "null";
}
if (param is Function) {
//skip functions, coz there is no way to serialise them,
continue;
} else if (typeof param != "object") {
//its a primitive datatype. return its String value

//add a comma infront of the parameter except for the first param
var paramStringValue:String = param.toString();
if (param is String) {
paramStringValue = '"' + paramStringValue + '"';
}
paramsStr +=  commaStr + paramStringValue;

} else {
// the param is a complex datatype, with properties
//check to see if its a standalone object or a reference to some place else
var paramrefStr = "";
if (param.absoluteRefString != null) {
paramrefStr = param.absoluteRefString;

} else if (serialisableObject2.RefsContainer[param]!=null) {
//an aobsolute ref cannot be found, but RefsContainer contains a ref to the param

paramrefStr = serialisableObject2.RefsContainer[param];
} else {
//define a unique localvar ref to represent it, and create the localVar including its properties
var referenceOfIteratedObj:String = serialisableObject2.getIteratedReference(param);
var localInitStr:String = "";
if (referenceOfIteratedObj==null) {
paramrefStr = serialisableObject2.generateLocalID(referenceStr + ".param"+p);
globalobj.localIDs[paramrefStr] = param;

if (param.serialise is Function) {
localInitStr = "" + param.serialise(paramrefStr);
//the Pas to initialise the entire localvar , and add properties
//be sure to add the prototype serialise functions to objects and arrays first
//before this function is called!
} else {
localInitStr = "";
}
} else {
paramrefStr = referenceOfIteratedObj;
}


header +=  localInitStr;
}
paramsStr +=  commaStr + paramrefStr;


}


}
paramsStr +=  ")";
var assignStr:String = "";
//a string representing the assignment statement for this object
var thisClassDefStr = getQualifiedClassName(this);
//if the class resides in a package, the  :: will be seen in thisclassDef
var indexOfColonColon:Number = thisClassDefStr.indexOf("::");
var thisClassName:String = "Object";
//thisClassname is by default object if the object is not a class member
if ((indexOfColonColon != -1)) {
//the class resides in a package. 
//remove the colon colon and replace it with a dot
thisClassDefStr = thisClassDefStr.replace("::",".");


//check to see if the whole serialised code block contains an import statement
var indexOfImportClassDef = globalobj.codeBlock.indexOf(("import " + thisClassDefStr));
var indexOfImportClassDefThis = header.indexOf(("import " + thisClassDefStr));
if ((indexOfImportClassDef == -1)&&indexOfImportClassDefThis==-1) {
//add an import statement to the very top of the codeBlock
globalobj.codeBlock = "\r import " + thisClassDefStr + ";" + globalobj.codeBlock;

}
//now, since the package definition has been imported, reduce the fully qualified name
// to simply classname
thisClassName = thisClassDefStr.decompileIntoName();

} else {
//the class is not in a package
thisClassName = thisClassDefStr;
}
assignStr +=  referenceStr + " = new " + thisClassName + paramsStr + ";";
//now create the footer
var footer:String = "";
//the footer assigns dynamic properties to the newly created object
for (var n = 0; n<this.dynamicVarNames.length; n++) {
var dynamicVarName:String = this.dynamicVarNames[n];
var dynamicVar:* = this[dynamicVarName];
if (typeof dynamicVar != "object") {
//its a primitive datatype. return its String value
var dynamicVarStringValue:String = dynamicVar.toString();
if (dynamicVar is String) {
dynamicVarStringValue = '"' + dynamicVarStringValue + '"';
}
footer +=  "" + referenceStr + "." + dynamicVarName + " = " + dynamicVarStringValue + ";";

} else {
// the dynamic var is a complex datatype, with properties
//check to see if its a standalone object or a reference to some place else
var dynamicRefStr = "";
if (dynamicVar.absoluteRefString != null) {
dynamicRefStr = dynamicVar.absoluteRefString;
footer +=  "" + referenceStr + "." + dynamicVarName + " = " + dynamicRefStr + ";";

} else if (serialisableObject2.RefsContainer[dynamicVar]!=null) {
//an aobsolute ref cannot be found, but RefsContainer contains a ref to the param
dynamicRefStr = serialisableObject2.RefsContainer[dynamicVar];
footer +=  "" + referenceStr + "." + dynamicVarName + " = " + dynamicRefStr + ";";
}
//if the absolute reference of the dynamic var includes referenceStr as a parent
//the dynamic var is a child of this object, and not a reference to someplace else
//create it anyway.
var parentref = referenceStr;
//type checking forbids a dynamic prototype function to be applied on a string type
if (dynamicRefStr==""||parentref.getDirectDescendantName(dynamicRefStr)==dynamicVarName) {
//define a unique localvar ref to represent it
var referenceOfIteratedObj2:String = serialisableObject2.getIteratedReference(dynamicVar);
var localInitStr2:String = "";
if (referenceOfIteratedObj2==null) {
dynamicRefStr = serialisableObject2.generateLocalID(referenceStr + "." +dynamicVarName);
globalobj.localIDs[dynamicRefStr] = dynamicVar;
if (dynamicVar.serialise is Function) {
localInitStr2 = dynamicVar.serialise(dynamicRefStr);
//the Pas to initialise the entire localvar , and add properties
//be sure to add the prototype serialise functions to objects and arrays first
//before this function is called!
} else {
localInitStr2 = "";
}
} else {
dynamicRefStr = referenceOfIteratedObj2;
}
footer +=  localInitStr2;
footer +=  "" + referenceStr + "." + dynamicVarName + " = " + dynamicRefStr + ";";
//the assignment for the object

}
}
}
//the string to build the entire serialised code of the object
var buildstr = header + assignStr + footer;
globalobj.iteratedObjects[this] = referenceStr;
if (isTop==true) {
serialisableObject2.resetGlobalObj();
}
return buildstr;
}*/
/*public static function serialiseChildren(rootObject:Object) {
//rootObject is the object whose contents you want to serialise
var globalobj = serialisableObject2.globalobj;

globalobj.codeBlock = "";
globalobj.localIDs = {};
//code to serialise children
for (var childname:String in rootObject) {
var child = rootObject[childname];
if (typeof child != "object") {
var childStringValue:String = child.toString();
if (child is String) {
childStringValue = '"' + childStringValue + '"';
}
codeblock +=  "\r" + childStringValue;
} else if (child.serialise is Function) {
var serialisedstr= child.serialise("this."+childname);
globalobj.codeBlock +=  "\r" + serialisedstr;
}

}
var codeblock = globalobj.codeBlock;

serialisableObject2.globalobj = {};
serialisableObject2.globalobj.codeBlock = "";
serialisableObject2.globalobj.localIDs = {};
return codeblock;
}*/