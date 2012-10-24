package  Pasv2{
	
	public class feederObject {
public var paramsArray:Array=[];
public var dynamicVarNames:Array=[];
public var customcomments:String;
		public function feederObject(paramArray:Array=null,dynamicVarName:Array=null,customcomm:String="") {
			if(paramArray==null){
				paramArray=[];
			}
			if(dynamicVarName==null){
				dynamicVarName=[];
			}
			this.paramsArray=paramArray.concat();
			this.dynamicVarNames=dynamicVarName.concat();
			this.customcomments=customcomm;
			// constructor code
		}
		

	}
	
}
