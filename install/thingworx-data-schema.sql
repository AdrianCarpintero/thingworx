--
-- Thingworx Platform Version 6.6 PostgreSQL database BDWS schema
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
create schema if not exists :"searchPath";
SET search_path TO :"searchPath";
--
-- Name: upsert_stream_entry(character varying, character varying, timestamp with time zone, jsonb, character varying, character varying, jsonb); Type: FUNCTION; Owner: :"user_name"
--

CREATE FUNCTION upsert_stream_entry
(entity_id_value character varying, source_id_value character varying, time_value timestamp with time zone,
field_values_value jsonb,location_value character varying, source_type_value character varying, tags_value jsonb) 
RETURNS bigint
LANGUAGE plpgsql
AS $$ DECLARE    id_value bigint;
BEGIN     
	BEGIN         
		INSERT INTO stream (entity_id, source_id, time, field_values, location, source_type, tags)             
		values (entity_id_value, source_id_value, time_value, field_values_value, location_value, source_type_value, tags_value) 
		RETURNING entry_id INTO id_value;         
		RETURN id_value;     
		EXCEPTION WHEN unique_violation THEN         /* try update */     
	END;     
	UPDATE stream SET field_values=field_values_value, location=location_value, tags=tags_value     
	WHERE entity_id=entity_id_value and source_id=source_id_value and time=time_value and source_type=source_type_value 
		RETURNING entry_id INTO id_value;
	RETURN id_value; 
END; $$;


ALTER FUNCTION upsert_stream_entry
(entity_id_value character varying, source_id_value character varying, time_value timestamp with time zone, 
field_values_value jsonb, location_value character varying, source_type_value character varying, tags_value jsonb) 
OWNER TO :"user_name";

--
-- Name: upsert_value_stream_entry(character varying, character varying, timestamp with time zone, integer, text, text); Type: FUNCTION; Owner: :"user_name"
--

CREATE FUNCTION upsert_value_stream_entry
(entity_id_value character varying, source_id_value character varying, time_value timestamp with time zone, 
property_type_value integer, property_name_value character varying, property_value_value text) 
RETURNS bigint
LANGUAGE plpgsql
AS $$ DECLARE      id_value bigint;
BEGIN      
	BEGIN          
		INSERT INTO value_stream (entity_id, source_id, time, property_type, property_name, property_value)              
		values (entity_id_value, source_id_value, time_value, property_type_value, property_name_value, property_value_value) 
		RETURNING entry_id INTO id_value;          
		RETURN id_value;      
		EXCEPTION WHEN unique_violation THEN          /* try update */      
	END;      
	UPDATE value_stream SET property_value=property_value_value      
	WHERE entity_id=entity_id_value AND source_id=source_id_value AND time=time_value AND property_name=property_name_value AND property_type=property_type_value      
		RETURNING entry_id INTO id_value;      
	RETURN id_value; 
END; $$;


ALTER FUNCTION upsert_value_stream_entry
(entity_id_value character varying, source_id_value character varying, time_value timestamp with time zone, 
property_type_value integer, property_name_value character varying, property_value_value text) 
OWNER TO :"user_name";

--
-- Name: blog; Type: TABLE; Owner: :"user_name"; Tablespace: 
--

CREATE TABLE blog (
    entry_id integer NOT NULL,
    "time" timestamp with time zone,
    entity_id character varying(255),
    title text,
    content text,
    rating_average double precision,
    rating_count integer,
    location text,
    source_id character varying(255),
    source_type character varying(255),
    tags jsonb,
    last_updated timestamp with time zone,
    is_sticky boolean
);


ALTER TABLE blog OWNER TO :"user_name";

--
-- Name: blog_entry_id_seq; Type: SEQUENCE; Owner: :"user_name"
--

CREATE SEQUENCE blog_entry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE blog_entry_id_seq OWNER TO :"user_name";

--
-- Name: blog_entry_id_seq; Type: SEQUENCE OWNED BY; Owner: :"user_name"
--

ALTER SEQUENCE blog_entry_id_seq OWNED BY blog.entry_id;


--
-- Name: blog_comment; Type: TABLE; Owner: :"user_name"; Tablespace: 
--

CREATE TABLE blog_comment (
    entry_id bigint DEFAULT nextval('blog_entry_id_seq'::regclass) NOT NULL,
    blog_entry_id bigint,
    parent_entry_id bigint,
    content text,
    location text,
    source_id character varying(255),
    source_type character varying(255),
    tags jsonb,
    "time" timestamp with time zone
);


ALTER TABLE blog_comment OWNER TO :"user_name";

--
-- Name: wiki; Type: TABLE; Owner: :"user_name"; Tablespace: 
--

CREATE TABLE wiki (
    entry_id integer NOT NULL,
    "time" timestamp with time zone,
    entity_id character varying(255),
    parent_entry_id character varying(255),
    title text,
    content text,
    rating_average double precision,
    rating_count integer,
    location text,
    source_id character varying(255),
    source_type character varying(255),
    tags jsonb
);


ALTER TABLE wiki OWNER TO :"user_name";

--
-- Name: wiki_entry_id_seq; Type: SEQUENCE; Owner: :"user_name"
--

CREATE SEQUENCE wiki_entry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wiki_entry_id_seq OWNER TO :"user_name";

--
-- Name: wiki_entry_id_seq; Type: SEQUENCE OWNED BY; Owner: :"user_name"
--

ALTER SEQUENCE wiki_entry_id_seq OWNED BY wiki.entry_id;


--
-- Name: wiki_comment; Type: TABLE; Owner: :"user_name"; Tablespace: 
--

CREATE TABLE wiki_comment (
    entry_id bigint DEFAULT nextval('wiki_entry_id_seq'::regclass) NOT NULL,
    wiki_entry_id bigint,
    parent_entry_id bigint,
    content text,
    location text,
    source_id character varying(255),
    source_type character varying(255),
    tags jsonb,
    "time" timestamp with time zone
);


ALTER TABLE wiki_comment OWNER TO :"user_name";

--
-- Name: data_table; Type: TABLE; Owner: :"user_name"; Tablespace: 
--

CREATE TABLE data_table (
    entry_id integer NOT NULL,
    entity_id character varying(255),
    entity_key text,
    field_values jsonb,
    location text,
    source_id character varying(255),
    source_type character varying(255),
    tags jsonb,
    "time" timestamp with time zone,
    full_text text,
    CONSTRAINT entity_key_constraint UNIQUE(entity_key, entity_id)
);


ALTER TABLE data_table OWNER TO :"user_name";

--
-- Name: data_table_entry_id_seq; Type: SEQUENCE; Owner: :"user_name"
--

CREATE SEQUENCE data_table_entry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data_table_entry_id_seq OWNER TO :"user_name";

--
-- Name: data_table_entry_id_seq; Type: SEQUENCE OWNED BY; Owner: :"user_name"
--

ALTER SEQUENCE data_table_entry_id_seq OWNED BY data_table.entry_id;


CREATE TABLE stream (
    entry_id integer NOT NULL,
    entity_id character varying(255),
    source_id character varying(255),
    "time" timestamp with time zone,
    field_values jsonb,
    location character varying(255),
    source_type character varying(255),
    tags jsonb,
    unique (entity_id,source_id,source_type,time)
);


ALTER TABLE stream OWNER TO :"user_name";

--
-- Name: stream_id_seq; Type: SEQUENCE; Owner: :"user_name"
--

CREATE SEQUENCE stream_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE stream_id_seq OWNER TO :"user_name";

--
-- Name: stream_id_seq; Type: SEQUENCE OWNED BY; Owner: :"user_name"
--

ALTER SEQUENCE stream_id_seq OWNED BY stream.entry_id;


--
-- Name: system_version; Type: TABLE; Owner: postgres; Tablespace: 
--

CREATE TABLE IF NOT EXISTS system_version (
    pid serial primary key,
    server_name character varying(255) NOT NULL,
    server_code integer NOT NULL,
    is_data_provider_supported boolean NOT NULL,
    is_model_provider_supported boolean NOT NULL,
    is_property_provider_supported boolean NOT NULL,
    model_schema_version integer NOT NULL,
    data_schema_version integer NOT NULL,
    property_schema_version integer NOT NULL,
    major_version character varying(10) NOT NULL,
    minor_version character varying(10),
    revision character varying(45) NOT NULL,
    build character varying(45) NOT NULL,
    creationDate timestamp with time zone DEFAULT now()
);


ALTER TABLE system_version OWNER TO :"user_name";

CREATE TABLE value_stream (
    entry_id bigint NOT NULL,
    entity_id character varying(255),
    source_id character varying(255),
    "time" timestamp with time zone,
    property_type integer,
    property_name character varying(4096),
    property_value text
);


ALTER TABLE value_stream OWNER TO :"user_name";

--
-- Name: value_stream_id_seq; Type: SEQUENCE; Owner: :"user_name"
--

CREATE SEQUENCE value_stream_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE value_stream_id_seq OWNER TO :"user_name";

--
-- Name: value_stream_id_seq; Type: SEQUENCE OWNED BY; Owner: :"user_name"
--

ALTER SEQUENCE value_stream_id_seq OWNED BY value_stream.entry_id;


CREATE TABLE wiki_history (
    entry_id integer NOT NULL,
    wiki_entry_id bigint,
    entity_id character varying(255),
    content text,
    location text,
    source_id character varying(255),
    source_type character varying(255),
    tags jsonb,
    "time" timestamp with time zone
);


ALTER TABLE wiki_history OWNER TO :"user_name";

--
-- Name: wiki_history_entry_id_seq; Type: SEQUENCE; Owner: :"user_name"
--

CREATE SEQUENCE wiki_history_entry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wiki_history_entry_id_seq OWNER TO :"user_name";

--
-- Name: wiki_history_entry_id_seq; Type: SEQUENCE OWNED BY; Owner: :"user_name"
--

ALTER SEQUENCE wiki_history_entry_id_seq OWNED BY wiki_history.entry_id;


--
-- Name: entry_id; Type: DEFAULT; Owner: :"user_name"
--

ALTER TABLE ONLY blog ALTER COLUMN entry_id SET DEFAULT nextval('blog_entry_id_seq'::regclass);


--
-- Name: entry_id; Type: DEFAULT; Owner: :"user_name"
--

ALTER TABLE ONLY wiki ALTER COLUMN entry_id SET DEFAULT nextval('wiki_entry_id_seq'::regclass);


--
-- Name: entry_id; Type: DEFAULT; Owner: :"user_name"
--

ALTER TABLE ONLY data_table ALTER COLUMN entry_id SET DEFAULT nextval('data_table_entry_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Owner: :"user_name"
--

ALTER TABLE ONLY stream ALTER COLUMN entry_id SET DEFAULT nextval('stream_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Owner: :"user_name"
--

ALTER TABLE ONLY value_stream ALTER COLUMN entry_id SET DEFAULT nextval('value_stream_id_seq'::regclass);


--
-- Name: entry_id; Type: DEFAULT; Owner: :"user_name"
--

ALTER TABLE ONLY wiki_history ALTER COLUMN entry_id SET DEFAULT nextval('wiki_history_entry_id_seq'::regclass);


ALTER TABLE ONLY blog
    ADD CONSTRAINT blog_pkey PRIMARY KEY (entry_id);


--
-- Name: blog_comment_pkey; Type: CONSTRAINT; Owner: :"user_name"; Tablespace: 
--

ALTER TABLE ONLY blog_comment
    ADD CONSTRAINT blog_comment_pkey PRIMARY KEY (entry_id);


ALTER TABLE ONLY wiki
    ADD CONSTRAINT wiki_pkey PRIMARY KEY (entry_id);


--
-- Name: wiki_comment_pkey; Type: CONSTRAINT; Owner: :"user_name"; Tablespace: 
--

ALTER TABLE ONLY wiki_comment
    ADD CONSTRAINT wiki_comment_pkey PRIMARY KEY (entry_id);


--
-- Name: data_table_pkey; Type: CONSTRAINT; Owner: :"user_name"; Tablespace: 
--

ALTER TABLE ONLY data_table
    ADD CONSTRAINT data_table_pkey PRIMARY KEY (entry_id);


--
-- Name: wiki_history_pkey; Type: CONSTRAINT; Owner: :"user_name"; Tablespace: 
--

ALTER TABLE ONLY wiki_history
    ADD CONSTRAINT wiki_history_pkey PRIMARY KEY (entry_id);


--
-- Name: datatable_values_index; Type: INDEX; Owner: :"user_name"; Tablespace: 
--

CREATE INDEX datatable_values_index ON data_table USING gin (field_values);


--
-- Name: blog_id_index; Type: INDEX; Owner: :"user_name"; Tablespace: 
--
CREATE INDEX blog_id_index ON blog USING btree (entity_id);


--
-- Name: blog_comment_collaboration_id_index; Type: INDEX; Owner: :"user_name"; Tablespace: 
--
CREATE INDEX blog_comment_collaboration_id_index ON blog_comment USING btree (blog_entry_id);


--
-- Name: wiki_id_index; Type: INDEX; Owner: :"user_name"; Tablespace: 
--
CREATE INDEX wiki_id_index ON wiki USING btree (entity_id);


--
-- Name: wiki_comment_collaboration_id_index; Type: INDEX; Owner: :"user_name"; Tablespace: 
--
CREATE INDEX wiki_comment_collaboration_id_index ON wiki_comment USING btree (wiki_entry_id);


--
-- Name: wiki_history_wiki_id_index; Type: INDEX; Owner: :"user_name"; Tablespace: 
--
CREATE INDEX wiki_history_wiki_id_index ON wiki_history USING btree (wiki_entry_id);


--
-- Name: datatable_entity_key_index; Type: INDEX; Owner: :"user_name"; Tablespace: 
--

CREATE INDEX datatable_entity_key_index ON data_table USING btree (entity_key);

--
-- Name: stream_id_time_index; Type: INDEX; Owner: :"user_name"; Tablespace: 
--

CREATE INDEX stream_id_time_index ON stream USING btree (entity_id, "time");


--
-- Name: stream_pk_index; Type: INDEX; Owner: :"user_name"; Tablespace: 
--

CREATE UNIQUE INDEX stream_pk_index ON stream USING btree (entry_id);


--
-- Name: value_stream_id_source_time_index; Type: INDEX; Owner: user_name; Tablespace: 
--

CREATE UNIQUE INDEX value_stream_id_source_time_index ON value_stream USING btree (entity_id, source_id, property_name, "time");


--
-- Name: value_stream_pk_index; Type: INDEX; Owner: user_name; Tablespace: 
--

CREATE UNIQUE INDEX value_stream_pk_index ON value_stream USING btree (entry_id);


--
-- Name: comment_blog_entry_id_fkey; Type: FK CONSTRAINT; Owner: :"user_name"
--

ALTER TABLE ONLY blog_comment
    ADD CONSTRAINT comment_blog_entry_id_fkey FOREIGN KEY (blog_entry_id) REFERENCES blog(entry_id);


--
-- Name: comment_wiki_entry_id_fkey; Type: FK CONSTRAINT; Owner: :"user_name"
--

ALTER TABLE ONLY wiki_comment
    ADD CONSTRAINT comment_wiki_entry_id_fkey FOREIGN KEY (wiki_entry_id) REFERENCES wiki(entry_id);


--
-- Name: wiki_history_wiki_entry_id_fkey; Type: FK CONSTRAINT; Owner: :"user_name"
--

ALTER TABLE ONLY wiki_history
    ADD CONSTRAINT wiki_history_wiki_entry_id_fkey FOREIGN KEY (wiki_entry_id) REFERENCES wiki(entry_id);
