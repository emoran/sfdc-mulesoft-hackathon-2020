$( document ).ready(function() {
	console.log('Mulesoft Hackathon Activated');	
	QuickNav.init(); //Starting navigation menu.
});

$('#sendpicture').prop('disabled', true);

$(document).on("click","#take_picture", function(){
	$('#picture_modal').modal('show');
});

$(document).on("click","#picture_modal_cancel",function(){
	$('#picture_modal').modal('hide');
});

$(document).on('change',"#picture_info",handlePhoto);

function handlePhoto(evt){
	console.log('## In handler');
	var file = evt.target.files[0];

	console.log('### File Size: '+file.size);
	var reader = new FileReader();

	reader.onload = (function(theFile) { 
		return function(e) {					
			imageData = e.target.result.split(',')[1];
			base64Information = imageData;
			$('[id$=myHiddenField]').val(imageData);
			$('#sendpicture').prop('disabled', false);
		};
	})(file);
		reader.readAsDataURL(file);
}


$(document).on('click','#sendpicture',function(){
	$('#picture_modal').modal('hide');
	
	var resultado = '';
	$.blockUI({
	    message: '<img src="http://cdn.allevents.in/new/images/hex-loading.gif" />',
	    css: {
	        border:     'none',
	        backgroundColor:'transparent'
	    } 
	});
	
	af_submitFile(base64Information,resultado);
});

function stop_function(){
	$.unblockUI();	
	console.log('Image sent application will send you a push notification when image has been processed.');
	Swal.fire('Image sent application will send you a push notification when image has been processed.')
}

function onstart_function(){
	$('[id$=comment_evidence]').val($('#comment').val());
}