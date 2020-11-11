@RestResource(urlMapping='/mentions')
global with sharing class RecordMentions {
  
    @HttpPost
    global static String postMention(String imageId) {

        RestRequest     request = RestContext.request;
        RestResponse    res     = RestContext.response;   

       

        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

		messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

		mentionSegmentInput.id = '0054x000000I75tAAC';//companyadmin
		messageBodyInput.messageSegments.add(mentionSegmentInput);

		textSegmentInput.text = ' New Labels has been created for the uploaded image, take a look: https://moran2-dev-ed.lightning.force.com/lightning/r/Hackathon_Image__c/'+imageId+'/view';
		messageBodyInput.messageSegments.add(textSegmentInput);

		feedItemInput.body = messageBodyInput;
		feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		feedItemInput.subjectId = imageId;

        ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
        
        CustomResponse response = new CustomResponse();
        response.message = 'success posted';
        response.status = 'sucess';


        return 'success';
    }

    global class CustomResponse{
        String message{get;set;}
        String status{get;set;}
    }
}
