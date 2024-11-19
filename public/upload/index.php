<?php

namespace BAYES;

require_once '../includes/DB.php';

// JSON file uploaded
function uploadedFile(array $f, string $name, bool $ml) : bool { //{{{
		$success = false;
		$user = isset($_SERVER['PHP_AUTH_USER']) ? $_SERVER['PHP_AUTH_USER'] 
			: (isset($_SERVER['REMOTE_USER']) ? $_SERVER['REMOTE_USER'] : '');
		
		do {
				// file not uploaded properly
				if (!isset($f['error']) || UPLOAD_ERR_OK != $f['error']) {
						break;
				}
				
				// make sure it is valid JSON
				$json = file_get_contents($f['tmp_name']);
				if (null == json_decode($json)) {
						break;
				}
				
				// make bool into string
				$ml = $ml ? 'true' : 'false';
				
				$db = DB::getInstance();
				$db->jsonUpload($user, str_replace(' ', '_', $name), $ml, $json);
				
				$success = true;
		} while (false);
		
		return $success;
}
//}}}

// get details of uploaded files
function listUploaded() : string { //{{{
		$ret = [];
		
		$db = DB::getInstance();
		$res = $db->listUploaded();
		
		if (is_array($res)) {
				$ret = $res;
		}
		
		return json_encode($ret);
}
//}}}

$output = '';

do {
		// file upload
		if (isset($_FILES['upload']) && 
				isset($_POST['filename'])) {
				// check that function returns true
				if (uploadedFile($_FILES['upload'], $_POST['filename'],
						isset($_POST['ml']) && 'ml' == $_POST['ml'])) {
						// set content type
						header('Content-type: application/json');
						$output = '{"success": true}';
				}
				else {
						http_response_code(404);
				}
				
				break;
		}
		
		// list JSON files
		if (isset($_GET['list'])) {
				header('Content-type: application/json');
				$output = listUploaded();
				break;
		}
		
		// show page
		$output = file_get_contents('page.xml');
} while (false);

print $output;

?>