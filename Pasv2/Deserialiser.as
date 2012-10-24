package Pasv2{
	//remember to get rid of all \r and \ns!
	import flash.utils.getDefinitionByName;
	
	//import Deserialiser
	import Pasv2.Deserialiser;
	import Pasv2.Watch;
	import Pasv2.stringUtils;

	public final class Deserialiser {
		private static var operatorsList:Array=["++","--","+=","-=","*=","/=","+","-","*","/","==","!=","!","&&","||"];
		//the deserialiser class inteprets pseudoAS and parses them into objects
		public static var globalobj:Object = {};
		//holds local deserialiser variables
		public static function createInstance() {
			var instance = new Deserialiser  ;
			return instance;
		}
		
		public function Deserialiser() {
			// constructor code
		}
		//include "supportCode.as"
		public static function evalOperator(codeLine:String,operator:String):String{
			var error:Boolean =false;
			var globalobj=Pasv2.Deserialiser.globalobj;
			var componentsArray:Array=codeLine.split(" ");
			
				
				var indexOfOperator=componentsArray.indexOf(operator);
				if(indexOfOperator<componentsArray.length-1){
					if(operator =="!"){
				var variableStr:String = componentsArray[indexOfOperator+1];
				var variableObj:Object = parseValue(variableStr,globalobj.rootObject);
				try{
				var result = !variableObj;
				componentsArray.splice(indexOfOperator,2,String(result));
				
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" is Not a Boolean! \r Line:"+globalobj.currentcommand;
					}
					}
				}
				if(indexOfOperator>0){
					if(operator =="++"){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var variableObj = parseValue(variableStr,globalobj.rootObject);
				try{
				var result = Number(variableObj)+1;
				componentsArray.splice(indexOfOperator-1,2,String(result));
				var referenceParent:Object= stringUtils.decompileIntoReferenceParent(variableStr,globalobj.rootObject);
				var name :String= stringUtils.decompileIntoName(variableStr);
				referenceParent[name] = result;
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" is Not a Number! \r Line:"+globalobj.currentcommand;
					}
					}
					if(operator =="--"){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var variableObj = parseValue(variableStr,globalobj.rootObject);
				try{
				var result = Number(variableObj)-1;
				componentsArray.splice(indexOfOperator-1,2,String(result));
				var referenceParent:Object= stringUtils.decompileIntoReferenceParent(variableStr,globalobj.rootObject);
				var name :String= stringUtils.decompileIntoName(variableStr);
				referenceParent[name] = result;
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" is Not a Number! \r Line:"+globalobj.currentcommand;
					}
					}
					if(operator =="=="&&indexOfOperator+1<componentsArray.length){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var secondvariableStr:String=componentsArray[indexOfOperator+1];
				var variableObj:Object = parseValue(variableStr,globalobj.rootObject);
				var secondvariableObj:Object = parseValue(secondvariableStr,globalobj.rootObject);
				try{
				var result = Boolean(variableObj  == secondvariableObj);
				componentsArray.splice(indexOfOperator-1,3,String(result));
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" or "+secondvariableStr+" is Not a Boolean! \r Line:"+globalobj.currentcommand;
					}
					}
					if(operator =="!="&&indexOfOperator+1<componentsArray.length){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var secondvariableStr:String=componentsArray[indexOfOperator+1];
				var variableObj:Object = parseValue(variableStr,globalobj.rootObject);
				var secondvariableObj:Object = parseValue(secondvariableStr,globalobj.rootObject);
				try{
				var result = Boolean(variableObj !=  secondvariableObj);
				componentsArray.splice(indexOfOperator-1,3,String(result));
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" or "+secondvariableStr+" is Not a Boolean! \r Line:"+globalobj.currentcommand;
					}
					}
					if(operator =="||"&&indexOfOperator+1<componentsArray.length){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var secondvariableStr:String=componentsArray[indexOfOperator+1];
				var variableObj:Object = parseValue(variableStr,globalobj.rootObject);
				var secondvariableObj:Object = parseValue(secondvariableStr,globalobj.rootObject);
				try{
				var result = Boolean(variableObj) ||  Boolean(secondvariableObj);
				componentsArray.splice(indexOfOperator-1,3,String(result));
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" or "+secondvariableStr+" is Not a Boolean! \r Line:"+globalobj.currentcommand;
					}
					}
					if(operator =="&&"&&indexOfOperator+1<componentsArray.length){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var secondvariableStr:String=componentsArray[indexOfOperator+1];
				var variableObj:Object = parseValue(variableStr,globalobj.rootObject);
				var secondvariableObj:Object = parseValue(secondvariableStr,globalobj.rootObject);
				try{
				var result = Boolean(variableObj) &&  Boolean(secondvariableObj);
				componentsArray.splice(indexOfOperator-1,3,String(result));
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" or "+secondvariableStr+" is Not a Boolean! \r Line:"+globalobj.currentcommand;
					}
					}
					if(operator =="+="&&indexOfOperator+1<componentsArray.length){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var secondvariableStr:String=componentsArray[indexOfOperator+1];
				var variableObj:Object = parseValue(variableStr,globalobj.rootObject);
				var secondvariableObj:Object = parseValue(secondvariableStr,globalobj.rootObject);
				try{
				var result = variableObj + secondvariableObj;
				var referenceParent:Object= stringUtils.decompileIntoReferenceParent(variableStr,globalobj.rootObject);
				var name :String= stringUtils.decompileIntoName(variableStr);
				referenceParent[name] = result;
				componentsArray.splice(indexOfOperator-1,3,String(result));
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" or "+secondvariableStr+" is Not a Number! \r Line:"+globalobj.currentcommand;
					}
					}
					if(operator =="-="&&indexOfOperator+1<componentsArray.length){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var secondvariableStr:String=componentsArray[indexOfOperator+1];
				var variableObj:Object = parseValue(variableStr,globalobj.rootObject);
				var secondvariableObj = parseValue(secondvariableStr,globalobj.rootObject);
				try{
				var result = Number(variableObj )- Number(secondvariableObj);
				var referenceParent:Object= stringUtils.decompileIntoReferenceParent(variableStr,globalobj.rootObject);
				var name :String= stringUtils.decompileIntoName(variableStr);
				referenceParent[name] = result;
				componentsArray.splice(indexOfOperator-1,3,String(result));
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" or "+secondvariableStr+" is Not a Number! \r Line:"+globalobj.currentcommand;
					}
					}
					if(operator =="*="&&indexOfOperator+1<componentsArray.length){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var secondvariableStr:String=componentsArray[indexOfOperator+1];
				var variableObj:Object = parseValue(variableStr,globalobj.rootObject);
				var secondvariableObj= parseValue(secondvariableStr,globalobj.rootObject);
				try{
				var result =Number( variableObj) * Number(secondvariableObj);
				var referenceParent:Object= stringUtils.decompileIntoReferenceParent(variableStr,globalobj.rootObject);
				var name :String= stringUtils.decompileIntoName(variableStr);
				referenceParent[name] = result;
				componentsArray.splice(indexOfOperator-1,3,String(result));
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" or "+secondvariableStr+" is Not a Number! \r Line:"+globalobj.currentcommand;
					}
					}
					if(operator =="/="&&indexOfOperator+1<componentsArray.length){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var secondvariableStr:String=componentsArray[indexOfOperator+1];
				var variableObj:Object = parseValue(variableStr,globalobj.rootObject);
				var secondvariableObj = parseValue(secondvariableStr,globalobj.rootObject);
				try{
				var result = Number(variableObj) / Number(secondvariableObj);
				var referenceParent:Object= stringUtils.decompileIntoReferenceParent(variableStr,globalobj.rootObject);
				var name :String= stringUtils.decompileIntoName(variableStr);
				referenceParent[name] = result;
				componentsArray.splice(indexOfOperator-1,3,String(result));
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" or "+secondvariableStr+" is Not a Number! \r Line:"+globalobj.currentcommand;
					}
					}
					if(operator =="+"&&indexOfOperator+1<componentsArray.length){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var secondvariableStr:String=componentsArray[indexOfOperator+1];
				var variableObj = parseValue(variableStr,globalobj.rootObject);
				var secondvariableObj = parseValue(secondvariableStr,globalobj.rootObject);
				try{
				var result = variableObj.valueOf() + secondvariableObj.valueOf();
				if(result as String){
					result = "'"+result+"'";
				}
				componentsArray.splice(indexOfOperator-1,3,String(result));
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" or "+secondvariableStr+" is Not a Number or String! \r Line:"+globalobj.currentcommand;
					}
					}
					if(operator =="-"&&indexOfOperator+1<componentsArray.length){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var secondvariableStr:String=componentsArray[indexOfOperator+1];
				var variableObj:Object = parseValue(variableStr,globalobj.rootObject);
				var secondvariableObj = parseValue(secondvariableStr,globalobj.rootObject);
				try{
				var result = Number(variableObj) - Number(secondvariableObj);
				componentsArray.splice(indexOfOperator-1,3,String(result));
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" or "+secondvariableStr+" is Not a Number! \r Line:"+globalobj.currentcommand;
					}
					}
					if(operator =="*"&&indexOfOperator+1<componentsArray.length){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var secondvariableStr:String=componentsArray[indexOfOperator+1];
				var variableObj:Object = parseValue(variableStr,globalobj.rootObject);
				var secondvariableObj = parseValue(secondvariableStr,globalobj.rootObject);
				try{
				var result = Number(variableObj) * Number(secondvariableObj);
				componentsArray.splice(indexOfOperator-1,3,String(result));
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" or "+secondvariableStr+" is Not a Number! \r Line:"+globalobj.currentcommand;
					}
					}
					if(operator =="/"&&indexOfOperator+1<componentsArray.length){
				var variableStr:String = componentsArray[indexOfOperator-1];
				var secondvariableStr:String=componentsArray[indexOfOperator+1];
				var variableObj:Object = parseValue(variableStr,globalobj.rootObject);
				var secondvariableObj = parseValue(secondvariableStr,globalobj.rootObject);
				try{
				var result = Number(variableObj) / Number(secondvariableObj);
				componentsArray.splice(indexOfOperator-1,3,String(result));
					}
					catch (Err:Error){
						error=true;
						globalobj.errorLog+="/r /r Error: "+ variableStr +" or "+secondvariableStr+" is Not a Number! \r Line:"+globalobj.currentcommand;
					}
					}
			}
			var finalString:String=componentsArray.join(" ");
			if(error){
				return "";
			}
			return finalString;
			
		}
		public static function deserialise(string:String,rootObject,rootRef:Object=null,usePersistentLocal:Boolean=true):String {
			
			if(!usePersistentLocal){
			Pasv2.Deserialiser.globalobj = {};
			}
			var globalobj = Pasv2.Deserialiser.globalobj;
			if(rootRef!=null){
				globalobj.rootRef=rootRef;
			}
			globalobj.rootObject=rootObject;
			globalobj.watchList=[];
			globalobj.errorLog="";
			globalobj.reportString="";
			if(globalobj.importDefs==null){
				globalobj.importDefs="";
			}
			//the watch list is an array storing watch objects
			//watch objects stores references which are dead and their associated commandline.
			//
			//get rid of all comments
			var it:uint = 0;
			while (string.indexOf("//") != -1) {
				it++;
				if ((it > 1e6)) {
					//maximum of 1 million comments
					break;
				}
				var indexcomment:Number = string.indexOf("//");
				var indexOfN:Number = string.indexOf("\n",indexcomment);
				var indexOfR:Number = string.indexOf("\r",indexcomment);
				if ((indexOfN != -1)) {
					var commentN = string.substring(indexcomment,indexOfN);
					string = string.replace(commentN,"");
				}
				if ((indexOfR != -1)) {
					var commentR = string.substring(indexcomment,indexOfR);
					string = string.replace(commentR,"");
				}
			}
			string="\r"+string
			while(string.indexOf("\rvar ")!=-1){
				string=string.replace("\rvar ","");
			}
			while(string.indexOf("\nvar ")!=-1){
				string=string.replace("\nvar ","");
			}
			while(string.indexOf(";var ")!=-1){
				string=string.replace(";var ","");
			}
			while(string.indexOf(" var ")!=-1){
				string=string.replace(" var ","");
			}
			string=Pasv2.Deserialiser.replaceImports(globalobj.importDefs+string);
			globalobj.commandsstrArray = string.split(";");
			globalobj.commandsstrArray.pop();
			for (var c = 0; c < globalobj.commandsstrArray.length; c++) {
				var commandstr = globalobj.commandsstrArray[c];
				
				commandstr = Pasv2.stringUtils.remove(commandstr,"\r");
				commandstr = Pasv2.stringUtils.remove(commandstr,"\n");
				//removes the newlines
				globalobj.currentcommand=commandstr
			 for(var i=0;i<Pasv2.Deserialiser.operatorsList.length;i++){
				 var operator:String=Pasv2.Deserialiser.operatorsList[i];
				 while(commandstr.indexOf(operator)!=-1){
					 var index:uint=commandstr.indexOf(operator)
					 if(commandstr.charAt(index-1)!=" "){
						 commandstr=commandstr.replace(operator," "+operator);
						 index=commandstr.indexOf(operator)
					 }
					 if(commandstr.charAt(index+operator.length)!=" "){
						  commandstr=commandstr.replace(operator,operator+" ");
					 }
					commandstr= evalOperator(commandstr,operator);
				 }
			 }
			 globalobj.currentcommand=commandstr
			 if(commandstr.length==0){
				 continue;
			 }
				if (Pasv2.stringUtils.indexOfWithoutLiteral(commandstr,"=") != -1) {
					//the command is an assignment
					//e.g somevar = Foo
					Pasv2.Deserialiser.Assign(commandstr,rootObject);
				} else {
					//the command is a function call;
					//e.g someFunction(params)
					var prefix=Pasv2.stringUtils.getPrefix(commandstr,"(");
					
						//the command is a instance method call
						//e.g root.object1.someFunction(args)
						if(Pasv2.Deserialiser.staticReferenceExists(commandstr,rootObject)){
							Pasv2.Deserialiser.getStaticReference(commandstr,rootObject);
						}else{
							Pasv2.Deserialiser.evaluateFunction(commandstr,rootObject,rootObject)
						}
						/*var errorStr=Pasv2.Deserialiser.evaluateFunction(commandstr,rootObject,rootObject);
					globalobj.throwError=true;
					if(errorStr!=null){
						//the command is most probly a static class method call
						//e.g SomeClass.someMethod(args)
						Pasv2.Deserialiser.getStaticReference(commandstr,rootObject);
					}*/
					
				}
				for(var w =0;w<globalobj.watchList.length;w++){
					var currentwatch:Watch = globalobj.watchList[w];
					var refExists:Boolean=currentwatch.Iterate();
					if(refExists==true){
						//splice this out of the watchlist
						globalobj.watchList.splice(w,1);
						w--;
					}
				}
			}
			var previousWatchListLength=globalobj.watchList.length
			//iterate the watchlist over until the watchlist cannot be shortened 
			//any further, the references there are assumed to be dead.
			do {
				previousWatchListLength=globalobj.watchList.length
				for( w =0;w<globalobj.watchList.length;w++){
					currentwatch= globalobj.watchList[w];
					refExists=currentwatch.Iterate();
					if(refExists==true){
						//splice this out of the watchlist
						globalobj.watchList.splice(w,1);
						w--;
					}
				}
				
			}while(previousWatchListLength>globalobj.watchList.length);
			//throw some more errors for references that cannot be evaluated
			for( w =0;w<globalobj.watchList.length;w++){
				currentwatch= globalobj.watchList[w];
					globalobj.errorLog+="\n\n Error: The reference "+currentwatch.deadRef+" does not exist! \n Line: "+currentwatch.commandline;
				}
				var errorsLog:String=globalobj.errorLog;
			if(!usePersistentLocal){
			Pasv2.Deserialiser.globalobj = {};
			}
			globalobj.rootObject=null;
			globalobj.watchList=[];
			globalobj.errorLog="";
			globalobj.reportString="";
			return errorsLog;
		}
		public static function clearLocals(){
			Pasv2.Deserialiser.globalobj={};
			//trace("LocalVars Deleted!");
			//if(Console is Class){
			//if(Console.console!=null){
				//Console.console.writeLine("LocalVars Deleted, Import Definitions deleted!");
			//}
			//}
		}
		internal static function addWatch(deadrefStr:String,commandline){
			//trace(deadrefStr+" does not currently exist, add a watch:"+commandline);
			var globalobj=Pasv2.Deserialiser.globalobj;
			var watchobj:Watch=new Watch(deadrefStr,commandline);
			if(watchobj.WatchExists()==false){
			globalobj.watchList.push(watchobj);
			}
			
		}
		
		//searches for import statements and replace new fullpackagename with the classname
		internal static function replaceImports(string) {
			var globalobj= Pasv2.Deserialiser.globalobj;
			while (Pasv2.stringUtils.indexOfWithoutLiteral(string,"import ") != -1) {
				var firstimportdefIndex = string.indexOf("import ") + String("import ").length;
				var importIndex= string.indexOf("import ")
				var semicolondef = string.indexOf(";",firstimportdefIndex + 1);
				var definitionNameWithClass = string.substring(firstimportdefIndex,semicolondef);
				globalobj.importDefs+="\r import "+definitionNameWithClass+";";
                var importStatementhSemi = string.substring(importIndex,semicolondef+1);
				definitionNameWithClass = Pasv2.stringUtils.remove(definitionNameWithClass," ");
				definitionNameWithClass = Pasv2.stringUtils.remove(definitionNameWithClass,"\r");
				definitionNameWithClass = Pasv2.stringUtils.remove(definitionNameWithClass,"\n");
				string=string.replace(importStatementhSemi,"");
				var classname = Pasv2.stringUtils.decompileIntoName(definitionNameWithClass);
				//replace all classnames in the string with definitionnames
				//function classDefExist
				function charBeforeClassname(string,classname,fromindex:Number) {
					
					var indexOfClassName = string.indexOf(classname,fromindex);
					var returnobj={};
					if(indexOfClassName==-1){
					returnobj.classFound=false;
						returnobj.currentindex=string.length
						return returnobj
					}
					var indexMinusOne:Number = indexOfClassName - 1
					if(indexMinusOne<0){
						indexMinusOne=0;
					}
					var preceedingchar = string.substr((indexMinusOne),1);
					var indexPlusLength = indexOfClassName+classname.length
					var postceedingchar = string.substr(indexPlusLength,1);
					
					var iscorrectChar = preceedingchar=="("||((((preceedingchar == "\r") || preceedingchar == "\n") || preceedingchar == " ") || preceedingchar == ";"||preceedingchar=="");
					//the post char cannot be another letter
					var correctPostChar:Boolean = (postceedingchar=="(")||(postceedingchar ==" ");
					correctPostChar= correctPostChar ||( postceedingchar ==".")||postceedingchar==")";;
														//known bug: Package name cannot be same as Class Name
														//i.e Foo.Foo is illegal!
					iscorrectChar= iscorrectChar&&correctPostChar;
					
					
					if (((indexOfClassName != -1) && iscorrectChar == true)) {
						returnobj.classFound=true;
						returnobj.currentindex=indexMinusOne
						returnobj.preceedingchar =preceedingchar
						returnobj.postceedingchar =postceedingchar
						return returnobj
					} else {
						returnobj.classFound=false;
						returnobj.currentindex=indexMinusOne
						return returnobj
					}
				}
                 var it:uint=0
				 string =" "+string;
				 var classCharObj:Object = charBeforeClassname(string,classname,0);
				 var charIndex=classCharObj.currentindex
				 var charName:String
				 var preChar:String
				 var postChar:String
				while ((charIndex <string.length)) {
					it++;
					if(classCharObj.classFound==true){
					preChar=classCharObj.preceedingchar
					postChar=classCharObj.postceedingchar;
					//replace  the classnames
					string = string.replace(( preChar+ classname+postChar),preChar+definitionNameWithClass+"<pk>"+postChar);
					if(string.charAt(0)==" "){
						string=string.slice(1,string.length)
					}
					charIndex+=String(definitionNameWithClass+"<pk>").length
					}
					charIndex+=classname.length
					string =" "+string;
                 classCharObj = charBeforeClassname(string,classname,charIndex);
				 charIndex=classCharObj.currentindex
				  if(it>1e5){
	               break;
                   }
				}


			}
			return string

		}
		//evaluates a function call string "functionName ( param1,param2,param3...)" given a known root reference
		//callstring can be a reference e.g "this.obj1.functionName"
		internal static function evaluateFunction(callstring,baseref:Object,rootObject:Object,throwError:Boolean=true) {
			var globalobj=Pasv2.Deserialiser.globalobj;
			try {
				//->root.obj1.functionname(args)
				var firstBracketIndex:Number = callstring.indexOf("(");
				var refStr2 = callstring.substring(0,firstBracketIndex);
				//-> root.obj1.functionname
				var lastRefDotIndex:Number = refStr2.lastIndexOf(".");
				if ((lastRefDotIndex == -1)) {
					lastRefDotIndex = 0;
				}
				var staticFunctionname = refStr2.substring(lastRefDotIndex,refStr2.length);
				//-> "functionname "
				staticFunctionname = Pasv2.stringUtils.remove(staticFunctionname," ");
				var staticReff = Pasv2.stringUtils.decompileIntoReference(refStr2,baseref);
				if ((staticReff is Function)) {
					//check to see if the object refeerenced is a function, else throws an error
					//evaulate the params
					var staticFunction:Function = staticReff
					var argumentsArray = Pasv2.Deserialiser.parseArguments(callstring,rootObject);
					if(argumentsArray.indexOf(undefined)==-1){
					var functionvalue = staticReff.apply(null,argumentsArray);
					return functionvalue;
					}else{
						
						var Err1= new Error("Problem parsing one of the arguments");
						throw Err1;
					}
				} else {
					//add to watchlist
					var refStrNoSpace=Pasv2.stringUtils.deleteWhiteSpace(refStr2);
					Pasv2.Deserialiser.addWatch(refStrNoSpace,globalobj.currentcommand);
					//
					if(globalobj.throwError){
					globalobj.errorLog+="\n\n Error: The function "+callstring+" does not exist! \n Line:"+globalobj.currentcommand;
					}else{
						globalobj.staticLog+="\n\n Error: The function "+callstring+" does not exist! \n Line:"+globalobj.currentcommand;
					}
					var Err2 = new Error((("the  function " + callstring) + "does not exist!"));
					throw Err2;
				}
			} catch (err:Error) {
				return err.message;
			}
		}
		//returns a reference to a static method or variable. if the reference contains
		//a method call (), returns the value of the method call
		internal static function getStaticReference(refstring,rootObject:Object) {

			var noSpaceStr1 = Pasv2.stringUtils.remove(refstring," ");
			var staticClassRef:Class
			var staticClassObjRefStr
			try {
				var indexofPK=noSpaceStr1.indexOf("<pk>")
				if(indexofPK==-1){
					indexofPK=noSpaceStr1.indexOf(".");
				}
				var packagedClassRefStr=noSpaceStr1.substring(0,indexofPK);
				var staticPackagedClassRef=getDefinitionByName(packagedClassRefStr);
				var pklength:Number=5;
				if(noSpaceStr1.indexOf("<pk>")==-1){
					pklength=1;
				}
				staticClassObjRefStr=noSpaceStr1.substring(indexofPK+pklength,noSpaceStr1.length);
				if(staticPackagedClassRef==null){
				var staticClassRefStr = Pasv2.stringUtils.getRoot(noSpaceStr1);
				 staticClassRef = getDefinitionByName(staticClassRefStr) as Class;
				}else{
					staticClassRef =staticPackagedClassRef;
				}
				if ((staticClassRef != null)) {
					if(staticClassObjRefStr==null){
					staticClassObjRefStr = Pasv2.stringUtils.shiftDot(noSpaceStr1);
					}
					if (staticClassObjRefStr.indexOf("(") == -1) {
						//the reference is a static variable
						var staticRef = Pasv2.stringUtils.decompileIntoReference(staticClassObjRefStr,staticClassRef);
						if(staticRef==null){
							globalobj.errorLog+="\n\n Error: The static reference "+staticClassRef+" does not exist! \n Line:"+globalobj.currentcommand;
							throw new Error("The static reference does not exist!")
						}
						return staticRef;
					} else {
						//the reference is a call to a static function
						//the name of the function is between the first "(" and the last "." of the reference
						//the last dot of the reference does not come after the first bracket
						//(references may be included in the params)
						var functionvalue = Pasv2.Deserialiser.evaluateFunction(staticClassObjRefStr,staticClassRef,rootObject);
						/*  var firstBracketIndex:Number = staticClassObjRefStr.indexOf("(");
						var refStr2 = staticClassObjRefStr.substring(0,firstBracketIndex);
						var lastRefDotIndex:Number = refStr2.lastIndexOf(".");
						var staticFunctionname = refStr2.substring(lastRefDotIndex,refStr2.length);
						staticFunctionname = staticFunctionname..remove(" ");
						var staticRef2 = refStr2..decompileIntoReference(staticClassRef);
						if ((staticRef2 is Function)) {
						//check to see if the object refeerenced is a function, else throws an error
						//evaulate the params
						var argumentsArray:Array = Pasv2.Deserialiser.parseArguments(staticClassObjRefStr);
						var functionvalue = staticRef2.apply(null,argumentsArray);
						return functionvalue;
						} else {
						var Err2 = new Error((((("the static function " + staticClassRefStr) + ".") + refStr2) + "does not exist!"));
						throw Err2;
						}*/
						return functionvalue;
					}
				} else {
					globalobj.errorLog+="\n \n Error: The class "+packagedClassRefStr+" does not exist! /r "+globalobj.currentcommand;
					throw new Error((("the classname:" + staticClassRefStr) + " does not exist!"));
				}
			} catch (Err:Error) {
				if(staticClassRef!=null){
					//the class exists, but the reference doesnt
					return undefined;
				}else{
				return null;
				}
			}
		}
		internal static function staticReferenceExists(refstring,rootObject:Object) {

			var noSpaceStr1 = Pasv2.stringUtils.remove(refstring," ");
			var staticClassRef:Class
			var staticClassObjRefStr
			try {
				var indexofPK=noSpaceStr1.indexOf("<pk>")
				if(indexofPK==-1){
					indexofPK=noSpaceStr1.indexOf(".");
				}
				var packagedClassRefStr=noSpaceStr1.substring(0,indexofPK);
				var staticPackagedClassRef=getDefinitionByName(packagedClassRefStr);
				var pklength:Number=5;
				if(noSpaceStr1.indexOf("<pk>")==-1){
					pklength=1;
				}
				staticClassObjRefStr=noSpaceStr1.substring(indexofPK+pklength,noSpaceStr1.length);
				if(staticPackagedClassRef==null){
				var staticClassRefStr = Pasv2.stringUtils.getRoot(noSpaceStr1);
				 staticClassRef = getDefinitionByName(staticClassRefStr) as Class;
				}else{
					staticClassRef =staticPackagedClassRef;
				}
				if ((staticClassRef != null)) {
					if(staticClassObjRefStr==null){
					staticClassObjRefStr = Pasv2.stringUtils.shiftDot(noSpaceStr1);
					}
					if (staticClassObjRefStr.indexOf("(") == -1) {
						//the reference is a static variable
						
						var staticRef = Pasv2.stringUtils.decompileIntoReference(staticClassObjRefStr,staticClassRef);
						if(staticRef==null){
							return false;
						}else{
						return true;
						}
					} else {
						var indexOfBracket:uint = staticClassObjRefStr.indexOf("(");
						staticClassObjRefStr=staticClassObjRefStr.substring(0,indexOfBracket);
						var staticRef = Pasv2.stringUtils.decompileIntoReference(staticClassObjRefStr,staticClassRef);
						
							if(staticRef !=null&&staticRef is Function){
						return true;
							}else{
								return false;
							}
						
					}
				} else {
					return false;
				}
			} catch (Err:Error) {
				if(staticClassRef!=null){
					//the class exists, but the reference doesnt
					return undefined;
				}else{
				return null;
				}
			}
		}
		//the parseArguments function converts a string "(arg1,arg2,arg3,...)" into an array of arguments
		//which are evaluated
		internal static function parseArguments(string,rootObject) {
			//now the parseArguments handles STRICTLY arguments string in BRACKETS
			//string = string..remove(" ");
			var firstBracketIndex:Number = string.indexOf("(");
			var lastBracketIndex:Number = string.lastIndexOf(")");
			var argumentsstr = string.substring((firstBracketIndex + 1),lastBracketIndex);

			var argnamesarray = argumentsstr.split(",");
			var argsarray:Array = [];

			for (var a = 0; a < argnamesarray.length; a++) {
				var argstring:String = argnamesarray[a];
				if (argstring.length > 0) {
					var valu = Pasv2.Deserialiser.parseValue(argstring,rootObject);
					if(valu!==undefined){
					argsarray[a] = valu;
					}else{
						argsarray[a] = undefined;
					}
				}
			}
			return argsarray;
		}
		//the parseValue function converts a value of a string into its equivalent Object
		//e.g {} -> new Object, new Class () -> new class....
		public static function parseValue(string,rootObject) {
			var globalobj=Pasv2.Deserialiser.globalobj;
			var noSpaceStr1 = Pasv2.stringUtils.remove(string," ");
			if (((noSpaceStr1 == "") || noSpaceStr1 == "null")) {
				return null;
			}
			 {
				//if referencing a static class var or function
				
				var staticRef = Pasv2.Deserialiser.getStaticReference(noSpaceStr1,rootObject);
				if ((staticRef != null)) {
					return staticRef;
				}
				//if the evaluated value of the string is a  call to an instance method
				var noLiteralStr=Pasv2.stringUtils.removeLiterals(string);
				if (noLiteralStr.indexOf("(") != -1&&noLiteralStr.indexOf("new ")==-1) {
					var functionresult = Pasv2.Deserialiser.evaluateFunction(noSpaceStr1,rootObject,rootObject);
					if ((functionresult != null)) {
						return functionresult;

					}
				}
				//if the evaluated value of the string is a reference to a variable
				var ref = Pasv2.stringUtils.decompileIntoReference(noSpaceStr1,rootObject);
				if(ref==null){
					// if the reference does not exist, add to the watchlist to call the assignment again
					//when the reference does exist
					if(noSpaceStr1.indexOf("(") == -1&&staticRef!==undefined&&noSpaceStr1.indexOf(".")!=-1&&noSpaceStr1.indexOf("'")==-1&&noSpaceStr1.indexOf('"')==-1){
				if(isNaN(Number(noSpaceStr1))){
				Pasv2.Deserialiser.addWatch(noSpaceStr1,globalobj.currentcommand);
				}
					}
				}
//noSpaceStr1.indexOf("this") != -1 &&
				/*if ( ref == null && noSpaceStr1.indexOf("(") == -1) {

					//the expression is not a function call,
					//the expression is referencing some object which is not yet created
					//find the command to create the object, and create it
					var commandsarray:Array = Pasv2.Deserialiser.globalobj.commandsstrArray;
					var assignmentFound:Boolean = false;
					//whether the command to assign the parent object was found
					for (var c = 0; c < commandsarray.length; c++) {
						var commandstr = commandsarray[c];
						var prefix = commandstr..getPrefix("=");
						prefix = String(prefix..remove(" "));
						prefix = String(prefix..remove("\r"));
						prefix = String(prefix..remove("\n"));
						if ((prefix == noSpaceStr1)) {
							var error = Pasv2.Deserialiser.Assign(commandstr,rootObject);
							if ((error == null)) {
								//no problem assigning the variable
								//delete the assignment statement from the code block
								commandsarray.splice(c,1);
							}
							assignmentFound = true;
							//if ((error is Error)) {
								//an error was encountered in assigning a parent object in the chain, break out
								//return error;
							//}
							break;
						}
					}
					if ((assignmentFound == false)) {
						//one of the parent parent objects cannot be assigned coz there is no command to assign it
						//stop the assign function with an error
						//add deadref to watchlist
						Pasv2.Deserialiser.addWatch(noSpaceStr1,globalobj.currentcommand);
						return undefined;
						//var error2 = new Error("the referenced object has no command which creates it, reference failed");
						//return error2;
					} else {
						ref = noSpaceStr1..decompileIntoReference(rootObject);
						//assign the reference
					}

				}*/
				if ((ref != null)) {
					//trace("value is a ref");
					return ref;

					//if the evaluated value of the string is a class constructor
				} else if (noLiteralStr.indexOf("new ") != -1) {
					//trace("value is a new class");
					var newIndex:int = string.indexOf("new ") + String("new ").length;
					var openBracketIndex:int = string.indexOf("(");
					//the classname is the substring  of the new Class ( between newIndex and openBracketIndex
					var className
					var classNameWithSpaces = string.substring(newIndex,openBracketIndex);
					if(classNameWithSpaces.indexOf("<pk>")!=-1){
					   var indexofPK=classNameWithSpaces.indexOf("<pk>")
				       var packagedClassRefStr=classNameWithSpaces.substring(0,indexofPK);
				        className=packagedClassRefStr;
				
					   }else{
					 className = stringUtils.remove(classNameWithSpaces," ");
					   }
					try {
						//when the classname does not exist, throws and handles an error
						var classRef:Class = getDefinitionByName(className) as Class;
						//handles the arguments in the parenthesis (arg1, arg2, arg3..)
						//var argumentsstr:String = string.substring((openBracketIndex + 1),closeBracketIndex+1);
						var paramsArray:Array = Pasv2.Deserialiser.parseArguments(string,rootObject);
						//create a new class obj with indefinite number of parameters paramss
						var newInstance:*
						if(classRef.createInstance!=null){
							 newInstance = classRef.createInstance.apply(null,paramsArray);
						}else{
							//manually create class using swicth statement
							var pA=paramsArray;
							switch(paramsArray.length){
							case 0:
							newInstance = new classRef();
							break;
							case 1:
							newInstance = new classRef(paramsArray[0]);
							break;
							case 2:
							newInstance = new classRef(paramsArray[0],paramsArray[1]);
							break;
							case 3:
							newInstance = new classRef(paramsArray[0],paramsArray[1],paramsArray[2]);
							break;
							case 4:
							newInstance = new classRef(pA[0],pA[1],pA[2],pA[3]);
							break;
							case 5:
							newInstance = new classRef(pA[0],pA[1],pA[2],pA[3],pA[4]);
							break;
							case 6:
							newInstance = new classRef(pA[0],pA[1],pA[2],pA[3],pA[4],pA[5]);
							break;
							case 7:
							newInstance = new classRef(pA[0],pA[1],pA[2],pA[3],pA[4],pA[5],pA[6]);
							break;
							case 8:
							newInstance = new classRef(pA[0],pA[1],pA[2],pA[3],pA[4],pA[5],pA[7]);
							break;
							case 9:
							newInstance = new classRef(pA[0],pA[1],pA[2],pA[3],pA[4],pA[5],pA[7],pA[8]);
							break;
							case 10:
							newInstance = new classRef(pA[0],pA[1],pA[2],pA[3],pA[4],pA[5],pA[7],pA[8],pA[10]);
							break;
							default:
							globalobj.errorLog+="\n\n Error: Too many params! Create a createInstance() method for the class instead. \n Line:"+globalobj.currentcommand;
						throw new Error("Too many params");
							}
						
					}
						return newInstance;
						//temporary code until a way to reference the class constructor method is found

						//

					} catch (Err2:Error) {
						//trace(Err2);
						globalobj.errorLog+="\n\n Error: The class "+classNameWithSpaces +" does not exist! \r Line:"+globalobj.currentcommand;
						//trace("classname does not exist");
						//classname does not exist
						return undefined;
					}
				} else if (noLiteralStr.indexOf("{") != -1 && noLiteralStr.indexOf("}") != -1) {
					//trace("value is an object");
					var obj = {};
					return obj;
					//the valuestr refers to an empty object
				} else if (noLiteralStr.indexOf("[") != -1 && noLiteralStr.indexOf("]") != -1) {
					//the valuestr refers to an array
					//trace("value is an Array");
					var arrayelementsstr = string.substring(string.indexOf("[") + 1,string.lastIndexOf("]"));
					//array containing the unevaluated string names of the elements
					var elementsstrarray:Array = arrayelementsstr.split(",");

					var elementsarray:Array = [];
					for (var e = 0; e < elementsstrarray.length; e++) {
						//evaluate each elements in the elementsstrarray;
						var elementstr = elementsstrarray[e];
						//evaluate each element and return the evaluated value
						//skips the empty strings
						if (elementstr.length > 0) {
							var element = Pasv2.Deserialiser.parseValue(elementstr,rootObject);
							if(element != undefined){
							elementsarray[e] = element;
							}else{
								return undefined;
							}
						}
					}
					return elementsarray;
				} else {
					//the value is a primitive
					var nospacesstr = stringUtils.remove(string," ");
					if ((nospacesstr == "true")) {
						//expression is a boolean
						var bool1 = true;
						return bool1;
					}
					if ((nospacesstr == "false")) {
						//expression is a boolean
						var bool2 = false;
						return bool2;
					}
					if(nospacesstr=="NaN"){
						return NaN;
					}
					if (! isNaN(Number(nospacesstr)) && nospacesstr != "") {
						//expression is a number
						var valu = Number(nospacesstr);
						return valu;
					} else {
						//expression is most likely a string
						if (string.indexOf("'") != -1) {
							var firstIndexInvComma:Number = string.indexOf("'");
							var lastIndexInvComma:Number = string.lastIndexOf("'");
							var stringvalue = string.substring((firstIndexInvComma + 1),lastIndexInvComma);
							return stringvalue;
						} else if (string.indexOf('"') != -1) {
							var firstIndexInvComma2:Number = string.indexOf('"');
							var lastIndexInvComma2:Number = string.lastIndexOf('"');
							var stringvalue2 = string.substring((firstIndexInvComma2 + 1),lastIndexInvComma2);
							return stringvalue2;
						}

					}
				}


			} 
			globalobj.errorLog+="\n\n Error: Unable to evaluate the value of "+string+". \n Line:"+globalobj.currentcommand;
			/*catch (Err:Error) {
				//trace(Err.message);
				////trace(("Failed to evaluate the value of :" + string));
				return undefined;
			}*/
		}
		internal  static function Assign(string,rootObject) {
			//trace("");
var globalobj=Pasv2.Deserialiser.globalobj;
			//input format: root.obj1.obj2 = someValue
			var referencestr = Pasv2.stringUtils.getPrefix(string,"=");
			/////trace((" referencestr:" + referencestr));
			//get the reference
			//intercept a null reference
			try {

				var parentref = Pasv2.stringUtils.decompileIntoReferenceParent(referencestr,rootObject);
				
				var parentrefStr = Pasv2.stringUtils.popDot(referencestr);
				parentrefStr = Pasv2.stringUtils.remove(parentrefStr," ");
				if(parentref==null){
					//add a watch to create the parent
					Pasv2.Deserialiser.addWatch(parentrefStr,globalobj.currentcommand);
					//break out of function,since nothing can be assigned
					return;
				}
				/*if (((parentref == null) && referencestr.indexOf("this.") != -1)) {
					//trace((((("the parentref:" + parentrefStr) + " of ") + referencestr) + " does not exist"));
					//the parentobj doesnt exist;
					var parentparentref:Object;
					var parentparentrefstr = parentrefStr;
					var rootmostparent:Object;
					while (true) {
						parentparentref = parentparentrefstr..decompileIntoReferenceParent(rootObject);
						if ((parentparentref != null)) {
							rootmostparent = parentparentref;
							parentparentrefstr = parentparentrefstr...popDot();
							//the rootmost parent reference has been found
							break;

						} else {
							parentparentrefstr = parentparentrefstr...popDot();
							if (parentparentrefstr.length == 0) {
								break;
							}
						}
					}

					if ((rootmostparent != null)) {

						var parentDotChildStr = parentparentrefstr;
						//trace(("thismost parent :" + parentDotChildStr));
						//this while loop:
						//e.g root.obj1.obj2.obj3.obj4
						//root is the rootmost parent
						//parentparentrefstr is hence "this"
						//set parentDotChildStr to parentparentrefstr
						//parentDotChildStr +=".obj1" , next child (= root.obj1)
						//Find the command: root.obj1 = someValue in the entire codeblock
						//assign the value to the reference
						//loop back
						//parentDotChildStr+=".obj2" (=root.obj1.obj2)
						//Find the command: root.obj1.obj2 = someValue in the entire codeblock
						//assign the value to the reference
						//loop back
						//so on...., 
						//until parentDotChildStr=parentref
						//hence, the parent object is defined
						//so the current property is 
						while ((parentDotChildStr != parentrefStr)) {
							var childname = parentDotChildStr..getDirectDescendantName(parentrefStr);
							parentDotChildStr = parentDotChildStr + "." + childname;
							//loop thru the entire codeblock to find the assigning statement for parentDotChildStr;
							var commandsarray:Array = Pasv2.Deserialiser.globalobj.commandsstrArray;
							var assignmentFound:Boolean = false;
							//whether the command to assign the parent object was found
							for (var c = 0; c < commandsarray.length; c++) {
								var commandstr = commandsarray[c];
								var prefix = commandstr..getPrefix("=");
								prefix = String(prefix..remove(" "));
								prefix = String(prefix..remove("\r"));
								prefix = String(prefix..remove("\n"));
								////trace(prefix+":"+prefix.length);
								////trace(parentDotChildStr+":"+parentDotChildStr.length);
								if ((prefix == parentDotChildStr)) {
									//trace(("creating " + parentDotChildStr));
									////trace(((("prefix:" + prefix) + " = ") + parentDotChildStr));
									var error = Pasv2.Deserialiser.Assign(commandstr,rootObject);
									if ((error == null)) {
										//no problem assigning the variable
										//delete the assignment statement from the code block
										commandsarray.splice(c,1);
									}
									assignmentFound = true;
									if ((error is Error)) {
										//an error was encountered in assigning a parent object in the chain, break out
										return error;
									}
									break;
								}
							}
							if ((assignmentFound == false)) {
								//one of the parent parent objects cannot be assigned coz there is no command to assign it
								//stop the assign function with an error
								
								//add to the watchlist
								//Pasv2.Deserialiser.addWatch(parentDotChildStr,globalobj.currentcommand);
								
								var error2 = new Error("the referenced object has no command which creates it, reference failed");
								return error2;
							}

						}
						//find the piece of code which assigns the direct child to rootmostparent
					}
					//problem here, debug!
					parentref = referencestr..decompileIntoReferenceParent(rootObject);
					
				}*/
				if (((parentref == null) && referencestr.indexOf(".") == -1)) {

					//the parent does not exist, it is a local value
					//set the parent ref to the globalobj
					parentref = Pasv2.Deserialiser.globalobj;
				}

				var refname = Pasv2.stringUtils.decompileIntoName(referencestr);
				var valstring = Pasv2.stringUtils.getSuffix(string,"=");
				var val = Pasv2.Deserialiser.parseValue(valstring,rootObject);
				//trace(("Assignining: " + string));
				if ((val === undefined)) {
					//throw an errror
					
					
				}else{
				parentref[refname] = val;
				globalobj.reportString+="\r "+refname+" was sucessfully assigned to "+valstring;
				}

			} catch (Err:Error) {
				//trace(Err.message);
				globalobj.errorLog+="\n\n Error: A general error has occured during the assignment:"+Err.message+"  \n Line:"+globalobj.currentcommand;
				//parentref[refname] = null;
				return Err;
				//trace("an error is encountered, assign the value to null");
				//do nothing
			}
		}
	}
	

}