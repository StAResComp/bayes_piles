<?php

namespace BAYES;

require_once '../includes/DB.php';

// need name of JSON file
if (isset($_GET['name'])) {
		$db = DB::getInstance();
		$results = $db->getJSON($_GET['name']);
		
		// need something found in DB
		if ($results) {
				header('Content-type: application/json');
				print $results[0]->out_file_contents;
		}
}

// something went wrong above
if (!headers_sent()) {
		http_response_code(404);
}

?>
