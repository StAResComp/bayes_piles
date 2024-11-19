// code to run on load
$(function() {
		 // get filename when file to upload changes
		 $('#upload').change(getFilename);
		 // handle form submission asynchronously
		 $('#upload_form').submit(uploadFile);

		 // get list of uploaded JSON documents
		 loadJSONList();
});

// refresh list of uploaded files
let JSONListSuccess = function(resp) { //{{{
		 $('#json_files').html('');

		 resp.forEach(function(i) {
					const tr = '<tr><td><a href="' + i.ml ? ML : nonML +
							 '?data=' + DATA_DIR +  i.file_name +
							 '.json">' + i.file_name +
							 '</a></td><td>' + i.created + '</td></tr>';
					
					$('#json_files').append(tr);
		 });
}
//}}}

// get list of uploaded files
let loadJSONList = function() { //{{{
		 let options = {
					'url': 'index.php',
					'type': 'GET',
					'data': {'list': 'list'},
					'dataType': 'json'
		 };

		 ajax(options, JSONListSuccess);
}
//}}}

// file has been successfully uploaded
let uploadSuccess = function(resp) { //{{{
		 // now refresh list of files
		 loadJSONList();
}
//}}}

// upload form being submitted
let uploadFile = function(e) {
		 // do this asynchronously
		 e.preventDefault();

		 let options = {
					'url': $(e.target).attr('action'),
					'type': 'POST',
					'data': new FormData($('#upload_form').get(0)),
					'contentType': false,
					'processData': false
		 };

		 ajax(options, uploadSuccess);
}

// after file has been selected, get filename from file
let getFilename = function(e) { //{{{
		 const filename = $(e.target).val().replace(/.*(\/|\\)/, '').replace(/\.json/, '').replaceAll(' ', '_');

		 $('#filename').val(filename);
}
//}}}

// wrapper for jQuery AJAX
let ajax = function(options, successFunc) { //{{{
		 $.ajax(options).done(function(resp) {
					successFunc(resp);
		 }).fail(function() {
					console.log('AJAX error');
		 });
}
//}}}
