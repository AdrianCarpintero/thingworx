--
-- Thingworx Platform Version PostgreSQL database property schema
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
create schema if not exists :"searchPath";
SET search_path TO :"searchPath";


CREATE FUNCTION upsert_property_vtq(insertingid text, insertingname text, insertingvalue bytea, insertingtime bigint, insertingquality text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    FOR i IN 1..3 LOOP
        UPDATE property_vtq SET value = insertingValue, time = insertingTime, quality = insertingQuality WHERE id = insertingId AND name = insertingName;
        IF FOUND THEN
            RETURN;
        END IF;

        BEGIN
            INSERT INTO property_vtq (id, name, value, time, quality) VALUES (insertingId, insertingName, insertingValue, insertingTime, insertingQuality);
            RETURN;
        	EXCEPTION WHEN unique_violation THEN
        		SELECT pg_sleep(0.1); -- sleep 0.1 seconds and loop to try the UPDATE again.
        END;       
    END LOOP;
END;
$$;


ALTER FUNCTION upsert_property_vtq(insertingid text, insertingname text, insertingvalue bytea, insertingtime bigint, insertingquality text) OWNER TO :"user_name";

--
-- Name: insert_with_upsert_property_vtq(text, text, bytea, bigint, text); Type: FUNCTION; Owner: postgres
--

CREATE FUNCTION insert_with_upsert_property_vtq(insertingid text, insertingname text, insertingvalue bytea, insertingtime bigint, insertingquality text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO property_vtq (id, name, value, time, quality) VALUES (insertingId, insertingName, insertingValue, insertingTime, insertingQuality);
	EXCEPTION WHEN unique_violation THEN
		UPDATE property_vtq SET value = insertingValue, time = insertingTime, quality = insertingQuality WHERE id = insertingId AND name = insertingName;
END;
$$;

ALTER FUNCTION insert_with_upsert_property_vtq(insertingid text, insertingname text, insertingvalue bytea, insertingtime bigint, insertingquality text) OWNER TO :"user_name";

CREATE TABLE property_vtq (
    id text NOT NULL,
    name text NOT NULL,
    value bytea,
    "time" bigint,
    quality text
);


ALTER TABLE property_vtq OWNER TO :"user_name";

--
-- Name: property_vtq; Type: CONSTRAINT; Owner: :"user_name"; Tablespace: 
--
ALTER TABLE ONLY property_vtq
    ADD CONSTRAINT property_vtq_pkey PRIMARY KEY (id, name);

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

--
-- Thingworx Platform Version PostgreSQL database property schema
--
