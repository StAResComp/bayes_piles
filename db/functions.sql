-- JSON uploaded
CREATE OR REPLACE FUNCTION jsonUpload ( --{{{
  in_created_by VARCHAR(255),
	in_file_name VARCHAR(255),
	in_ml BOOLEAN,
	in_file_contents TEXT
)
RETURNS TABLE (
  out_file_id INTEGER
)
AS $FUNC$
DECLARE
  out_file_id INTEGER;
	len INTEGER;
BEGIN
  SELECT LENGTH(in_file_name)
	  INTO len;
		
 PERFORM COUNT(*)
	  FROM json_files
	 WHERE SUBSTRING(file_name, 1, len) = in_file_name;
	 
	IF FOUND THEN
     INSERT
	     INTO json_files (created_by, file_name, ml, file_contents)
	   VALUES (in_created_by, CONCAT(in_file_name, '_', TO_CHAR(NOW(), 'YYYYMMDDHH24MISS')), in_ml, in_file_contents)
  RETURNING file_id 
	     INTO out_file_id;
	ELSE
     INSERT
	     INTO json_files (created_by, file_name, ml, file_contents)
	   VALUES (in_created_by, in_file_name, in_ml, in_file_contents)
  RETURNING file_id 
	     INTO out_file_id;
	END IF;

   RETURN QUERY
	   SELECT out_file_id;
END;
$FUNC$ LANGUAGE plpgsql SECURITY DEFINER VOLATILE;
--}}}

-- delete JSON files older than X
CREATE OR REPLACE FUNCTION deleteJSON ( --{{{
  in_time_stamp TIMESTAMP WITH TIME ZONE
)
RETURNS TABLE (
  deleted INTEGER
)
AS $FUNC$
DECLARE
  deleted INTEGER;
BEGIN
  DELETE
    FROM json_files
	 WHERE created < in_time_stamp;
	
	GET DIAGNOSTICS deleted = ROW_COUNT;

  RETURN QUERY
    SELECT deleted;
END;
$FUNC$ LANGUAGE plpgsql SECURITY DEFINER VOLATILE;
--}}}

-- get JSON file using name
CREATE OR REPLACE FUNCTION getJSON ( --{{{
  in_file_name VARCHAR(64)
)
RETURNS TABLE (
  out_file_contents TEXT
)
AS $FUNC$
BEGIN
  RETURN QUERY
    SELECT file_contents
		  FROM json_files
		 WHERE file_name = in_file_name;
END;
$FUNC$ LANGUAGE plpgsql SECURITY DEFINER STABLE;
--}}}

-- get details of uploaded files
CREATE OR REPLACE FUNCTION listUploaded () --{{{
RETURNS TABLE (
  created TIMESTAMP WITH TIME ZONE,
	file_name VARCHAR(255),
	ml BOOLEAN
)
AS $FUNC$
BEGIN
  RETURN QUERY
    SELECT j.created, j.file_name, j.ml
		  FROM json_files AS j
  ORDER BY j.created DESC;
END;
$FUNC$ LANGUAGE plpgsql SECURITY DEFINER STABLE;
--}}}
