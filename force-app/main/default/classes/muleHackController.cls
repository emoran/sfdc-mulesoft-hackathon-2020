global with sharing class muleHackController {
    public Transient String imageData {get;set;}
    public Transient String fileData {get;set;}
    
    public muleHackController(ApexPages.StandardController con) {}

    /**
     * POST IMAGE
     */
    public void post_image(){
       
        Hackathon_Image__c image = new Hackathon_Image__c();   
        insert image;
 
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'E'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = 'image_'+ Datetime.now() +'.jpg'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = 'Image_'+Datetime.now(); // Display name of the files
        conVer.VersionData = EncodingUtil.base64Decode(fileData); // converting your binary string to Blog
        conVer.ExternalDataSourceId = '0XC4x000000GnuN';
        conVer.ExternalDocumentInfo1 = 'x.com';
        conVer.Origin = 'H';
        insert conVer;    //Insert ContentVersion


        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = image.Id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;

       
       
        muleHackController.sendToMulesoft(image.Id,conVer.Id,conDocLink.Id);
        

    }
    @future(callout=true)
    global static void sendToMulesoft(String imageRecordId,String contentVersionId, String contentDocumentLinkId){

        MulesoftRequest mulesoftRequest = new MulesoftRequest();
        mulesoftRequest.imageRecordId = imageRecordId;
        mulesoftRequest.contentVersionId = contentVersionId;
        mulesoftRequest.contentDocumentLinkId = contentDocumentLinkId;
        //CALLING MULESOFT -- > 
        HttpRequest req  = new HttpRequest();
        HttpResponse res = new HttpResponse();      

        req.setEndpoint('http://mule-aws-recognition-process-api.us-e2.cloudhub.io/api/image');
	    req.setMethod('POST');
	    req.setHeader('Content-Type', 'application/json;');
	    req.setBody(JSON.serialize(mulesoftRequest));
	    req.setTimeout(5000);
        req.setCompressed(false); // otherwise we hit a limit of 32000


		
		Http http = new Http();	    
	    try {
			res = http.send(req);
            System.debug('response: '+res);
	    } 
	    catch(System.CalloutException e) {
	    	System.debug('Error: '+e.getMessage());
	    }		
    }
    


    public class MulesoftRequest{
        public String imageRecordId{get;set;}
        public String contentVersionId{get;set;}
        public String contentDocumentLinkId{get;set;}
    }
}
