CREATE TABLESPACE :"tablespace" OWNER :"username" location :'tablespace_location';

GRANT ALL PRIVILEGES ON TABLESPACE :"tablespace" to :"username";

GRANT CREATE ON TABLESPACE :"tablespace" to public;

CREATE DATABASE :"database" WITH 
	OWNER :"username" 
	TABLESPACE  :"tablespace" 
	ENCODING = 'UTF8' 
	CONNECTION LIMIT  -1 
	--LC_COLLATE = 'en_US.UTF-8'
	--LC_CTYPE = 'en_US.UTF-8'
	TEMPLATE template0;
	
GRANT ALL PRIVILEGES ON DATABASE :"database" to :"username";
