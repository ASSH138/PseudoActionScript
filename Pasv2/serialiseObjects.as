import Pasv2.serialisableObject;
import Pasv2.feederObject;

//the generic serialise function for objects
//by default, all the children of the object are serialised
//override this method or extend a object class and then override this method
//to exclude properties from being serialised
/*Object.prototype.serialise=function(referenceStr:String,includevar:Boolean=false,isTopParam:Boolean=true) {

var isTop:Boolean = serialisableObject.isTop();
if(isTop==true&&isTopParam!=false){
serialisableObject.initAbsoluteRefTags();
}
var globalobj = serialisableObject.globalobj;
globalobj.iteratedObjects[this] = String(referenceStr);
var varStr:String = "";
if (includevar==true) {
varStr = "var ";
}
var assignStr = "\r" + varStr + referenceStr + " = {};";
var footer = "";
for (var propName in this) {
var prop = this[propName];
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
if (prop.absoluteRefString != null) {
propRefStr = prop.absoluteRefString;


if (parentref.getDirectDescendantName(propRefStr) != propName) {
footer +=  "\r" + referenceStr + "." + propName + " = " + propRefStr + ";";
//add a reftag to the globalobj, to tell future serialisations to include
//a direct reference assignment in the next time the object is encounterd
globalobj.refTags[prop]=referenceStr + "." + propName
//continue;
}
} else if (serialisableObject.RefsContainer[prop]!=null) {
//an aobsolute ref cannot be found, but RefsContainer contains a ref to the param
propRefStr = serialisableObject.RefsContainer[prop];

if (parentref.getDirectDescendantName(propRefStr) != propName) {
footer +=  "\r" + referenceStr + "." + propName + " = " + propRefStr + ";";
globalobj.refTags[prop]=referenceStr + "." + propName
//continue;
}
}
//if the absolute reference of the dynamic var includes referenceStr as a parent
//the dynamic var is a child of this object, and not a reference to someplace else
//create it anyway.

if (propRefStr==""||parentref.getDirectDescendantName(propRefStr)==propName) {

var referenceOfIteratedObj:String = serialisableObject.getIteratedReference(prop);
var localInitStr2:String = "";
if (referenceOfIteratedObj==null) {
var abbrevobj:Object=serialisableObject.abbrevLocalRef(referenceStr+"."+propName);
var abbrevref:String=abbrevobj.shortenedRef
var assignmentCommand:String=abbrevobj.assignmentCommand;
footer+=assignmentCommand;

//propRefStr = serialisableObject.generateLocalID(referenceStr + "." + propName);
//globalobj.localIDs[propRefStr] = prop;

if (prop.serialise is Function&&!(prop.prototype.serialise is Function)) {
localInitStr2 = prop.serialise(abbrevref);

//the Pas to initialise the entire localvar , and add properties
//be sure to add the prototype serialise functions to objects and arrays first
//before this function is called!
} else {
//use the global serialise command

var feederObj:Pasv2.feederObject= Pasv2.serialisableObject.generateFeederObject(prop);
localInitStr2 = Pasv2.serialisableObject.serialiseObject(prop,abbrevref,false,false,feederObj);
}
} else {
propRefStr = referenceOfIteratedObj;
}
footer +=  localInitStr2;
if(propRefStr!=null&&propRefStr!=""){
footer +=  "\r" + referenceStr + "." + propName + " = " + propRefStr + ";";
}
//the assignment for the object

}
}

}
var customcomments:String="";
if(this.hasOwnProperty("customComments")&&this.customComments!=null){
customcomments="\r"+this.customComments;
}
var buildstr:String = customcomments+assignStr + footer;
//check for a reftag to include a absolute reference to this
if(globalobj.refTags[this]!=null){
buildstr+="\r"+globalobj.refTags[this]+" = "+referenceStr+";"
}
if (isTop==true&&isTopParam!=false) {
serialisableObject.resetGlobalObj();
}
return buildstr;
};

*/
//include your prototype serialisation functions here