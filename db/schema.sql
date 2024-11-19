CREATE TABLE json_files (
  file_id SERIAL PRIMARY KEY,
	created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
	created_by VARCHAR(255),
	file_name VARCHAR(255) UNIQUE,
	ml BOOLEAN,
	file_contents TEXT
);