--
-- Thingworx Platform Version 8.4 PostgreSQL database model schema
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
-- Name: upsert_aspect_model(character varying, integer, character varying, text); Type: FUNCTION; Owner: postgres
--

CREATE FUNCTION upsert_aspect_model(inserting_name character varying, inserting_type integer, inserting_key character varying, inserting_value text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    FOR i IN 1..3 LOOP
        UPDATE aspect_model SET entity_name = inserting_name, entity_type = inserting_type, key = inserting_key, value = inserting_value WHERE entity_name = inserting_name AND entity_type = inserting_type AND key = inserting_key;
        IF FOUND THEN
            RETURN;
        END IF;

        BEGIN
            INSERT INTO aspect_model (entity_name, entity_type, key, value) VALUES (inserting_name, inserting_type, inserting_key, inserting_value);
            RETURN;
            EXCEPTION WHEN unique_violation THEN
        		SELECT pg_sleep(0.1); -- sleep 0.1 seconds and loop to try the UPDATE again.
        END;
    END LOOP;
END;
$$;


ALTER FUNCTION upsert_aspect_model(inserting_name character varying, inserting_type integer, inserting_key character varying, inserting_value text) OWNER TO :"user_name";

--
-- Name: upsert_user_properties(character varying, character varying, text); Type: FUNCTION; Owner: postgres
--

CREATE FUNCTION upsert_user_properties(inserting_name character varying, inserting_key character varying, inserting_value text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    FOR i IN 1..3 LOOP
        UPDATE user_model_properties SET entity_name = inserting_name, key = inserting_key, value = inserting_value WHERE entity_name = inserting_name AND key = inserting_key;
        IF FOUND THEN
            RETURN;
        END IF;

        BEGIN
            INSERT INTO user_model_properties (entity_name, key, value) VALUES (inserting_name, inserting_key, inserting_value);
            RETURN;
            EXCEPTION WHEN unique_violation THEN
        		SELECT pg_sleep(0.1); -- sleep 0.1 seconds and loop to try the UPDATE again.
        END;
    END LOOP;
END;
$$;


ALTER FUNCTION upsert_user_properties(inserting_name character varying, inserting_key character varying, inserting_value text) OWNER TO :"user_name";

--
-- Name: upsert_extension(varchar, bytea, text); Type: FUNCTION; Owner: postgres
--
CREATE FUNCTION upsert_extension(extension_name varchar, extension_resource bytea, extension_checksum text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    FOR i IN 1..3 LOOP
        UPDATE extensions SET checksum = extension_checksum, resource = extension_resource WHERE name = extension_name;
        IF FOUND THEN
            RETURN;
        END IF;

        BEGIN
            INSERT INTO extensions (name, resource, checksum) VALUES (extension_name, extension_resource, extension_checksum);
            RETURN;
            EXCEPTION WHEN unique_violation THEN
        		SELECT pg_sleep(0.1); -- sleep 0.1 seconds and loop to try the UPDATE again.
        END;
    END LOOP;
END;
$$;

ALTER FUNCTION upsert_extension(extension_name varchar, extension_resource bytea, extension_checksum text) OWNER TO :"user_name";


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: model_index; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE model_index (
    id bigserial NOT NULL,
    entity_name character varying NOT NULL,
    entity_type integer NOT NULL,
    last_modified_time timestamp with time zone NOT NULL,
    description text,
    identifier character varying(1000),
    entity_id character varying NOT NULL,
    tags character varying,
    project_name character varying,
    CONSTRAINT model_index_pkey PRIMARY KEY (id),
    CONSTRAINT model_index_entities_ukey UNIQUE (entity_name, entity_type)
);


ALTER TABLE model_index OWNER TO :"user_name";

--
-- Name: applicationkey_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE applicationkey_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "clientName" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
	"expirationDate" timestamp with time zone,
	"homeMashup" character varying,
    "ipWhitelist" character varying,
    "keyId" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "userNameReference" character varying,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT applicationkey_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT applicationkey_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT applicationkey_model_name_ukey UNIQUE (name)
);


ALTER TABLE applicationkey_model OWNER TO :"user_name";

--
-- Name: aspect_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE aspect_model (
    entity_name character varying NOT NULL,
    entity_type integer NOT NULL,
    key character varying NOT NULL,
    value text
);


ALTER TABLE aspect_model OWNER TO :"user_name";

--
-- Name: authenticator_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE authenticator_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    enabled boolean,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    priority integer,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT authenticator_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT authenticator_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT authenticator_model_name_ukey UNIQUE (name)
);


ALTER TABLE authenticator_model OWNER TO :"user_name";

--
-- Name: dashboard_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE dashboard_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    dashboard text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT dashboard_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT dashboard_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT dashboard_model_name_ukey UNIQUE (name)
);


ALTER TABLE dashboard_model OWNER TO :"user_name";

--
-- Name: datashape_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE datashape_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "baseDataShape" character varying,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "fieldDefinitions" text,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT datashape_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT datashape_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT datashape_model_name_ukey UNIQUE (name)

);


ALTER TABLE datashape_model OWNER TO :"user_name";

--
-- Name: datatable_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE datatable_model (
    "entity_id" bigint NOT NULL,
    "alertConfigurations" text,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    enabled boolean,
    "homeMashup" character varying,
    identifier character varying,
    "implementedShapes" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "propertyBindings" text,
    published boolean,
    "remoteEventBindings" text,
    "remotePropertyBindings" text,
    "remoteServiceBindings" text,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    "thingShape" text,
    "thingTemplate" character varying,
    type integer,
    "valueStream" character varying,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT datatable_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT datatable_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT datatable_model_name_ukey UNIQUE (name)
);


ALTER TABLE datatable_model OWNER TO :"user_name";

--
-- Name: datatagvocabulary_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE datatagvocabulary_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "isDynamic" boolean,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT datatagvocabulary_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT datatagvocabulary_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT datatagvocabulary_model_name_ukey UNIQUE (name)
);


ALTER TABLE datatagvocabulary_model OWNER TO :"user_name";

--
-- Name: directoryservice_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE directoryservice_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    enabled boolean,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    priority integer,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT directoryservice_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT directoryservice_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT directoryservice_model_name_ukey UNIQUE (name)
);


ALTER TABLE directoryservice_model OWNER TO :"user_name";

--
-- Name: extensionpackage_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE extensionpackage_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "buildNumber" character varying,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "extensionPackageManifest" text,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    "minimumThingWorxVersion" character varying,
    name character varying NOT NULL,
    owner text,
    "groupId" character varying,
    "artifactId" character varying,
    "packageVersion" character varying,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    vendor character varying,
    "visibilityPermissions" text,
    "migratorClass" character varying,
    "configurationTableDefinitions" text,
    CONSTRAINT extensionpackage_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT extensionpackage_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT extensionpackage_model_name_ukey UNIQUE (name)
);

ALTER TABLE extensionpackage_model OWNER TO :"user_name";

--
-- Name: group_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE group_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    members character varying,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "scimId" character varying,
    "scimExternalId" character varying,
    "scimDisplayName" character varying,
    "configurationTableDefinitions" text,
    CONSTRAINT group_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT group_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT group_model_name_ukey UNIQUE (name)
);


ALTER TABLE group_model OWNER TO :"user_name";

--
-- Name: localizationtable_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE localizationtable_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "languageCommon" character varying,
    "languageNative" character varying,
    "configurationTableDefinitions" text,
    CONSTRAINT localizationtable_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT localizationtable_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT localizationtable_model_name_ukey UNIQUE (name)
);


ALTER TABLE localizationtable_model OWNER TO :"user_name";

--
-- Name: log_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE log_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    "logLevel" character varying,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT log_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT log_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT log_model_name_ukey UNIQUE (name)
);


ALTER TABLE log_model OWNER TO :"user_name";

--
-- Name: mashup_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE mashup_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    columns numeric,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    "mashupContent" character varying,
    name character varying NOT NULL,
    owner text,
    "parameterDefinitions" text,
    "projectName" character varying,
    "relatedEntities" character varying,
    rows numeric,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    preview bytea,
    CONSTRAINT mashup_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT mashup_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT mashup_model_name_ukey UNIQUE (name)
);


ALTER TABLE mashup_model OWNER TO :"user_name";

--
-- Name: mediaentity_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE mediaentity_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    content bytea,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT mediaentity_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT mediaentity_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT mediaentity_model_name_ukey UNIQUE (name)
);


ALTER TABLE mediaentity_model OWNER TO :"user_name";

--
-- Name: menu_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE menu_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "groupReferences" character varying,
    "homeMashup" character varying,
    "imageURL" character varying,
    "lastModifiedDate" timestamp with time zone,
    "menuItems" character varying,
    "menuLabel" character varying,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT menu_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT menu_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT menu_model_name_ukey UNIQUE (name)
);


ALTER TABLE menu_model OWNER TO :"user_name";

--
-- Name: modeltagvocabulary_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE modeltagvocabulary_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "isDynamic" boolean,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT modeltagvocabulary_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT modeltagvocabulary_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT modeltagvocabulary_model_name_ukey UNIQUE (name)
);


ALTER TABLE modeltagvocabulary_model OWNER TO :"user_name";

--
-- Name: vocabulary_terms; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE vocabulary_terms (
    pid integer NOT NULL,
    vocabulary_name character varying(255) NOT NULL,
    term_name character varying(255) NOT NULL,
    vocabulary_id character varying NOT NULL,
    vocabulary_type integer NOT NULL
);

ALTER TABLE vocabulary_terms OWNER TO :"user_name";

--
-- Name: vocabulary_terms_pid_seq; Type: SEQUENCE; Owner: postgres
--

CREATE SEQUENCE vocabulary_terms_pid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vocabulary_terms_pid_seq OWNER TO :"user_name";

--
-- Name: vocabulary_terms_pid_seq; Type: SEQUENCE OWNED BY; Owner: postgres
--

ALTER SEQUENCE vocabulary_terms_pid_seq OWNED BY vocabulary_terms.pid;



--
-- Name: network_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE network_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    connections character varying,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT network_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT network_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT network_model_name_ukey UNIQUE (name)
);


ALTER TABLE network_model OWNER TO :"user_name";

--
-- Name: organization_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE organization_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    connections character varying,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    "loginButtonStyle" character varying,
    "loginImage" bytea,
    "loginPrompt" character varying,
    "loginStyle" character varying,
    "mobileMashup" character varying,
    name character varying NOT NULL,
    "organizationalUnits" text,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "loginResetPassword" boolean,
    "resetMailServer" character varying,
    "resetMailSubject" character varying,
    "resetMailContent" character varying,
    "configurationTableDefinitions" text,
    CONSTRAINT organization_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT organization_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT organization_model_name_ukey UNIQUE (name)
);


ALTER TABLE organization_model OWNER TO :"user_name";

--
-- Name: persistenceprovider_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE persistenceprovider_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    enabled boolean,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "persistenceProviderPackage" character varying,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT persistenceprovider_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT persistenceprovider_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT persistenceprovider_model_name_ukey UNIQUE (name)
);


ALTER TABLE persistenceprovider_model OWNER TO :"user_name";

--
-- Name: persistenceproviderpackage_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE persistenceproviderpackage_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT persistenceproviderpackage_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT persistenceproviderpackage_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT persistenceproviderpackage_model_name_ukey UNIQUE (name)
);


ALTER TABLE persistenceproviderpackage_model OWNER TO :"user_name";

--
-- Name: project_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE project_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "publishResult" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "groupId" character varying,
    "artifactId" character varying,
    "version" text,
    "state" character varying NOT NULL DEFAULT 'DRAFT',
    "minPlatformVersion" character varying,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT project_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT project_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT project_model_name_ukey UNIQUE (name)
);


ALTER TABLE project_model OWNER TO :"user_name";

--
-- Name: resource_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE resource_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "serviceDefinitions" character varying,
    "serviceImplementations" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT resource_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT resource_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT resource_model_name_ukey UNIQUE (name)
);


ALTER TABLE resource_model OWNER TO :"user_name";

--
-- Name: root_entity_collection; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE root_entity_collection (
    name character varying(255) NOT NULL,
    type integer,
    description text,
    owner text,
    last_modified_time timestamp with time zone,
    pid integer NOT NULL,
    "designTimePermissions" text,
    "runTimePermissions" text,
    "visibilityPermissions" text,
    "className" character varying
);


ALTER TABLE root_entity_collection OWNER TO :"user_name";

--
-- Name: root_entity_collection_pid_seq; Type: SEQUENCE; Owner: :"user_name"
--

CREATE SEQUENCE root_entity_collection_pid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE root_entity_collection_pid_seq OWNER TO :"user_name";

--
-- Name: root_entity_collection_pid_seq; Type: SEQUENCE OWNED BY; Owner: :"user_name"
--

ALTER SEQUENCE root_entity_collection_pid_seq OWNED BY root_entity_collection.pid;


--
-- Name: scriptfunctionlibrary_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE scriptfunctionlibrary_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "functionDefinitions" text,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT scriptfunctionlibrary_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT scriptfunctionlibrary_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT scriptfunctionlibrary_model_name_ukey UNIQUE (name)
);


ALTER TABLE scriptfunctionlibrary_model OWNER TO :"user_name";

--
-- Name: statedefinition_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE statedefinition_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    content text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT statedefinition_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT statedefinition_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT statedefinition_model_name_ukey UNIQUE (name)
);


ALTER TABLE statedefinition_model OWNER TO :"user_name";

--
-- Name: stream_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE stream_model (
    "entity_id" bigint NOT NULL,
    "alertConfigurations" text,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    enabled boolean,
    "homeMashup" character varying,
    identifier character varying,
    "implementedShapes" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "propertyBindings" text,
    published boolean,
    "remoteEventBindings" text,
    "remotePropertyBindings" text,
    "remoteServiceBindings" text,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    "thingShape" text,
    "thingTemplate" character varying,
    type integer,
    "valueStream" character varying,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT stream_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT stream_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT stream_model_name_ukey UNIQUE (name)
);


ALTER TABLE stream_model OWNER TO :"user_name";

--
-- Name: styledefinition_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE styledefinition_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    content text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT styledefinition_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT styledefinition_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT styledefinition_model_name_ukey UNIQUE (name)
);


ALTER TABLE styledefinition_model OWNER TO :"user_name";

--
-- Name: styletheme_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE styletheme_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    content text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    preview bytea,
    CONSTRAINT styletheme_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT styletheme_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT styletheme_model_name_ukey UNIQUE (name)
);


ALTER TABLE styletheme_model OWNER TO :"user_name";

--
-- Name: subsystem_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE subsystem_model (
    "entity_id" bigint NOT NULL,
    "autoStart" boolean,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    "dependsOn" character varying,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    enabled boolean,
    "friendlyName" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT subsystem_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT subsystem_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT subsystem_model_name_ukey UNIQUE (name)
);


ALTER TABLE subsystem_model OWNER TO :"user_name";

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

--
-- Name: tag_index; Type: TABLE; Owner: postgres; Tablespace:
--

CREATE TABLE tag_index (
    pid integer NOT NULL,
    entity_name character varying(255) NOT NULL,
    vocabulary_name character varying(255) NOT NULL,
    term_name character varying(255) NOT NULL,
    entity_identifier character varying NOT NULL,
    vocabulary_type integer NOT NULL,
    tenant_id character varying(255) NOT NULL
);


ALTER TABLE tag_index OWNER TO :"user_name";

--
-- Name: tag_index_pid_seq; Type: SEQUENCE; Owner: postgres
--

CREATE SEQUENCE tag_index_pid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tag_index_pid_seq OWNER TO :"user_name";

--
-- Name: tag_index_pid_seq; Type: SEQUENCE OWNED BY; Owner: postgres
--

ALTER SEQUENCE tag_index_pid_seq OWNED BY tag_index.pid;


--
-- Name: thing_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE thing_model (
    "entity_id" bigint NOT NULL,
    "alertConfigurations" text,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    enabled boolean,
    "homeMashup" character varying,
    identifier character varying,
    "implementedShapes" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "propertyBindings" text,
    published boolean,
    "remoteEventBindings" text,
    "remotePropertyBindings" text,
    "remoteServiceBindings" text,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    "thingShape" text,
    "thingTemplate" character varying,
    type integer,
    "valueStream" character varying,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT thing_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT thing_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT thing_model_name_ukey UNIQUE (name)
);


ALTER TABLE thing_model OWNER TO :"user_name";

--
-- Name: thingpackage_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE thingpackage_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT thingpackage_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT thingpackage_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT thingpackage_model_name_ukey UNIQUE (name)
);


ALTER TABLE thingpackage_model OWNER TO :"user_name";

--
-- Name: thingshape_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE thingshape_model (
    "entity_id" bigint NOT NULL,
    "alertConfigurations" text,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "instanceRunTimePermissions" text,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "propertyBindings" text,
    "remoteEventBindings" text,
    "remotePropertyBindings" text,
    "remoteServiceBindings" text,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    "thingShape" text,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT thingshape_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT thingshape_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT thingshape_model_name_ukey UNIQUE (name)
);


ALTER TABLE thingshape_model OWNER TO :"user_name";

--
-- Name: thingtemplate_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE thingtemplate_model (
    "entity_id" bigint NOT NULL,
    "alertConfigurations" text,
    avatar bytea,
    "baseThingTemplate" character varying,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "implementedShapes" character varying,
    "instanceDesignTimePermissions" text,
    "instanceRunTimePermissions" text,
    "instanceVisibilityPermissions" text,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "propertyBindings" text,
    "remoteEventBindings" text,
    "remotePropertyBindings" text,
    "remoteServiceBindings" text,
    "runTimePermissions" text,
    "sharedConfigurationTables" text,
    tags character varying,
    "tenantId" character varying,
    "thingPackage" character varying,
    "thingShape" text,
    type integer,
    "valueStream" character varying,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT thingtemplate_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT thingtemplate_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT thingtemplate_model_name_ukey UNIQUE (name)
);


ALTER TABLE thingtemplate_model OWNER TO :"user_name";

--
-- Name: user_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE user_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    enabled boolean,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    "mobileMashup" character varying,
    name character varying NOT NULL,
    owner text,
    password character varying,
    "passwordHash" character varying,
    "passwordHashAlgorithm" character varying,
    "passwordHashIterationCount" integer,
    "passwordHashSaltSizeInBytes" integer,
    "passwordHashSizeInBytes" integer,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "locked" boolean,
    "lockedTime" timestamp with time zone,
    "scimId" character varying,
    "scimExternalId" character varying,
    "configurationTableDefinitions" text,
    CONSTRAINT user_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT user_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT user_model_name_ukey UNIQUE (name)
);


ALTER TABLE user_model OWNER TO :"user_name";

--
-- Name: user_model_properties; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE user_model_properties (
    entity_name character varying NOT NULL,
    key character varying NOT NULL,
    value text
);


ALTER TABLE user_model_properties OWNER TO :"user_name";

--
-- Name: valuestream_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE valuestream_model (
    "entity_id" bigint NOT NULL,
    "alertConfigurations" text,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    enabled boolean,
    "homeMashup" character varying,
    identifier character varying,
    "implementedShapes" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "propertyBindings" text,
    published boolean,
    "remoteEventBindings" text,
    "remotePropertyBindings" text,
    "remoteServiceBindings" text,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    "thingShape" text,
    "thingTemplate" character varying,
    type integer,
    "valueStream" character varying,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT valuestream_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT valuestream_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT valuestream_model_name_ukey UNIQUE (name)
);


ALTER TABLE valuestream_model OWNER TO :"user_name";

--
-- Name: widget_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE widget_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT widget_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT widget_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT widget_model_name_ukey UNIQUE (name)
);

ALTER TABLE widget_model OWNER TO :"user_name";

--
-- Name: notificationdefinition_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE notificationdefinition_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "contents" text,
    "events" text,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "recipients" text,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "configurationTableDefinitions" text,
    CONSTRAINT notificationdefinition_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT notificationdefinition_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT notificationdefinition_model_name_ukey UNIQUE (name)
);

ALTER TABLE notificationdefinition_model OWNER TO :"user_name";

--
-- Name: notificationcontent_model; Type: TABLE; Owner: :"user_name"; Tablespace:
--

CREATE TABLE notificationcontent_model (
    "entity_id" bigint NOT NULL,
    avatar bytea,
    "className" character varying,
    "configurationChanges" character varying,
    "configurationTables" text,
    description character varying,
    "designTimePermissions" text,
    "documentationContent" character varying,
    "handlerID" character varying,
    "handlerEntity" character varying,
    "homeMashup" character varying,
    "lastModifiedDate" timestamp with time zone,
    name character varying NOT NULL,
    owner text,
    "projectName" character varying,
    "runTimePermissions" text,
    tags character varying,
    "tenantId" character varying,
    type integer,
    "visibilityPermissions" text,
    "serviceDefinitions" character varying,
    "serviceImplementations" character varying,
    "configurationTableDefinitions" text,
    CONSTRAINT notificationcontent_model_pkey PRIMARY KEY (entity_id),
    CONSTRAINT notificationcontent_model_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT notificationcontent_model_name_ukey UNIQUE (name)
);

ALTER TABLE notificationcontent_model OWNER TO :"user_name";

CREATE TABLE ServiceDefinitions (
    id BIGSERIAL NOT NULL,
    name VARCHAR NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR,
    isAllowOverride BOOLEAN DEFAULT FALSE,
    isOpen BOOLEAN DEFAULT FALSE,
    isLocalOnly BOOLEAN DEFAULT FALSE,
    isPrivate BOOLEAN DEFAULT FALSE,
    resultType JSONB NOT NULL,
    parameterDefinitions JSONB NOT NULL,
    aspects JSONB NOT NULL,
    CONSTRAINT service_defs_pkey PRIMARY KEY (id)
);

CREATE INDEX service_defs_lookup_idx ON ServiceDefinitions USING btree (name);

ALTER TABLE ServiceDefinitions OWNER TO :"user_name";

CREATE TABLE ServiceImplementations (
    id BIGSERIAL NOT NULL,
    name VARCHAR NOT NULL,
    description TEXT NOT NULL,
    handlerName VARCHAR NOT NULL,
    lastModifiedDate TIMESTAMP WITH TIME ZONE NOT NULL,
    configurationTables JSONB NOT NULL,
    CONSTRAINT service_impls_pkey PRIMARY KEY (id)
);

CREATE INDEX service_impls_lookup_idx ON ServiceImplementations USING btree (name);

ALTER TABLE ServiceImplementations OWNER TO :"user_name";

CREATE TABLE RemoteServiceBindings (
    id BIGSERIAL NOT NULL,
    name VARCHAR NOT NULL,
    sourceName VARCHAR NOT NULL,
    enableQueue BOOLEAN DEFAULT FALSE,
    timeout BIGINT DEFAULT 0,
    CONSTRAINT service_bindings_pkey PRIMARY KEY (id)
);

CREATE INDEX service_bindings_lookup_idx ON RemoteServiceBindings USING btree (name);

ALTER TABLE RemoteServiceBindings OWNER TO :"user_name";

CREATE TABLE EventDefinitions (
    id BIGSERIAL NOT NULL,
    name VARCHAR NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR,
    dataShape VARCHAR NOT NULL,
    aspects JSONB NOT NULL,
    CONSTRAINT event_defs_pkey PRIMARY KEY (id)
);

CREATE INDEX event_defs_lookup_idx ON EventDefinitions USING btree (name);

ALTER TABLE EventDefinitions OWNER TO :"user_name";

CREATE TABLE Subscriptions (
    id BIGSERIAL NOT NULL,
    name VARCHAR NOT NULL,
    description TEXT NOT NULL,
    enabled BOOLEAN NOT NULL,
    source VARCHAR NOT NULL,
    sourceType BIGINT NOT NULL,
    sourceProperty VARCHAR,
    eventName VARCHAR NOT NULL,
    alertName VARCHAR,
    category VARCHAR,
    lastModifiedDate TIMESTAMP WITH TIME ZONE NOT NULL,
    trigger VARCHAR,
    aspects JSONB NOT NULL,
    CONSTRAINT subs_pkey PRIMARY KEY (id)
);

CREATE INDEX subscriptions_lookup_idx ON Subscriptions USING btree (name);

ALTER TABLE Subscriptions OWNER TO :"user_name";

CREATE TABLE Entities_ServiceDefinitions (
    entity_id BIGINT NOT NULL,
    definition_id BIGINT NOT NULL,
    CONSTRAINT entity_servdefs_ukey UNIQUE (definition_id),
    CONSTRAINT entity_servdefs_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT entity_servdefs_service_def_fkey FOREIGN KEY (definition_id) REFERENCES ServiceDefinitions ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX ents_service_defs_lookup_idx ON Entities_ServiceDefinitions USING btree (entity_id);

ALTER TABLE Entities_ServiceDefinitions OWNER TO :"user_name";

CREATE TABLE Entities_ServiceImplementations (
    entity_id BIGINT NOT NULL,
    implementation_id BIGINT NOT NULL,
    CONSTRAINT entity_servimpls_ukey UNIQUE (implementation_id),
    CONSTRAINT entity_servimpls_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT entity_servimpls_service_impl_fkey FOREIGN KEY (implementation_id) REFERENCES ServiceImplementations ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX ents_service_impls_lookup_idx ON Entities_ServiceImplementations USING btree (entity_id);

ALTER TABLE Entities_ServiceImplementations OWNER TO :"user_name";

CREATE TABLE Entities_RemoteServiceBindings (
    entity_id BIGINT NOT NULL,
    binding_id BIGINT NOT NULL,
    CONSTRAINT entity_bindings_ukey UNIQUE (binding_id),
    CONSTRAINT entity_bindings_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT entity_bindings_binding_fkey FOREIGN KEY (binding_id) REFERENCES RemoteServiceBindings ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX ents_service_bindings_lookup_idx ON Entities_RemoteServiceBindings USING btree (entity_id);

ALTER TABLE Entities_RemoteServiceBindings OWNER TO :"user_name";

CREATE TABLE Entities_EventDefinitions (
    entity_id BIGINT NOT NULL,
    event_id BIGINT NOT NULL,
    CONSTRAINT entity_events_ukey UNIQUE (event_id),
    CONSTRAINT entity_events_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT entity_events_event_fkey FOREIGN KEY (event_id) REFERENCES EventDefinitions ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX ents_event_defs_lookup_idx ON Entities_EventDefinitions USING btree (entity_id);

ALTER TABLE Entities_EventDefinitions OWNER TO :"user_name";

CREATE TABLE Entities_Subscriptions (
    entity_id BIGINT NOT NULL,
    subscription_id BIGINT NOT NULL,
    CONSTRAINT entity_subs_ukey UNIQUE (subscription_id),
    CONSTRAINT entity_subs_entity_fkey FOREIGN KEY (entity_id) REFERENCES MODEL_INDEX ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT entity_subs_subs_fkey FOREIGN KEY (subscription_id) REFERENCES Subscriptions ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX ents_subscriptions_lookup_idx ON Entities_Subscriptions USING btree (entity_id);

ALTER TABLE Entities_Subscriptions OWNER TO :"user_name";

CREATE TABLE extensions (
	"name" varchar PRIMARY KEY REFERENCES extensionpackage_model(name),
	"resource" bytea NOT NULL,
	"checksum" text NOT NULL
);

ALTER TABLE extensions OWNER TO :"user_name";

CREATE TABLE file_transfer_job (
	"id" text NOT NULL,
	"targetChecksum" text,
	"code" integer,
	"isAsync" boolean,
	"maxSize" bigint,
	"stagingDir" text,
	"sourceFile" text,
	"startPosition" numeric,
	"timeout" bigint,
	"isRestartEnabled" boolean,
	"duration" bigint,
	"targetFile" text,
	"startTime" bigint,
	"state" text,
	"sourcePath" text,
	"sourceRepository" text,
	"blockCount" bigint,
	"bytesTransferred" numeric,
	"targetPath" text,
	"sourceChecksum" text,
	"transferId" text,
	"message" text,
	"blockSize" bigint,
	"size" numeric,
	"endTime" bigint,
	"targetRepository" text,
	"user" text,
	"isComplete" boolean,
	"reservationId" text,
	"isQueueable" boolean,
	"enqueueTime" bigint,
	"enqueueCount" bigint,
	"metadata" jsonb
);

ALTER TABLE file_transfer_job OWNER TO :"user_name";

ALTER TABLE ONLY file_transfer_job
    ADD CONSTRAINT file_transfer_job_pkey PRIMARY KEY (id);

-- create table to support persistence of transfer job offline queue
CREATE TABLE file_transfer_job_offline_queue (
    "id" text NOT NULL,
    "targetChecksum" text,
    "code" integer,
    "isAsync" boolean,
    "maxSize" bigint,
    "stagingDir" text,
    "sourceFile" text,
    "startPosition" numeric,
    "timeout" bigint,
    "isRestartEnabled" boolean,
    "duration" bigint,
    "targetFile" text,
    "startTime" bigint,
    "state" text,
    "sourcePath" text,
    "sourceRepository" text,
    "blockCount" bigint,
    "bytesTransferred" numeric,
    "targetPath" text,
    "sourceChecksum" text,
    "transferId" text,
    "message" text,
    "blockSize" bigint,
    "size" numeric,
    "endTime" bigint,
    "targetRepository" text,
    "user" text,
    "isComplete" boolean,
    "isQueueable" boolean,
    "enqueueTime" bigint,
    "enqueueCount" bigint,
    "metadata" jsonb,
    "thingName" text NOT NULL
);

ALTER TABLE file_transfer_job_offline_queue OWNER TO :"user_name";

ALTER TABLE ONLY file_transfer_job_offline_queue
    ADD CONSTRAINT file_transfer_job_offline_queue_pkey PRIMARY KEY (id);

-- create table to support persistence of transfer reservation information
CREATE TABLE IF NOT EXISTS transfer_reservation (
    "id" text NOT NULL,
    "reservedBy" text,
    "reservedAt" bigint
);

ALTER TABLE transfer_reservation OWNER TO :"user_name";

ALTER TABLE ONLY transfer_reservation
    ADD CONSTRAINT transfer_reservation_pkey PRIMARY KEY (id);

CREATE TABLE system_ownership (
  id serial primary key,
  platform text, -- Arbitrary text describing the owning platform instance.
  took_ownership timestamp with time zone default current_timestamp
);

ALTER TABLE system_ownership OWNER TO :"user_name";

--
-- Name: sync_log; Type: TABLE; Owner: :"user_name"; Tablespace: 
--

CREATE TABLE sync_log (
    id bigserial primary key,
    platform text, -- Arbitrary text describing the owning platform instance.
    user_name text, -- Arbitrary text describing the owning user name
    changes text, 
    dependencies text
);

ALTER TABLE sync_log OWNER TO :"user_name";

--
-- TOC entry 2092 (class 2606 OID 76782)
-- Name: property_vtq_pkey; Type: CONSTRAINT; Schema: public; Owner: thingworx; Tablespace: 
--


ALTER TABLE widget_model OWNER TO :"user_name";

--
-- Name: pid; Type: DEFAULT; Owner: :"user_name"
--

ALTER TABLE ONLY root_entity_collection ALTER COLUMN pid SET DEFAULT nextval('root_entity_collection_pid_seq'::regclass);


--
-- Name: pid; Type: DEFAULT; Owner: postgres
--

ALTER TABLE ONLY tag_index ALTER COLUMN pid SET DEFAULT nextval('tag_index_pid_seq'::regclass);


--
-- Name: pid; Type: DEFAULT; Owner: postgres
--

ALTER TABLE ONLY vocabulary_terms ALTER COLUMN pid SET DEFAULT nextval('vocabulary_terms_pid_seq'::regclass);

--
-- Name: aspect_model_pkey; Type: CONSTRAINT; Owner: :"user_name"; Tablespace:
--

ALTER TABLE ONLY aspect_model
    ADD CONSTRAINT aspect_model_pkey PRIMARY KEY (entity_name, entity_type, key);

--
-- Name: model_tag_index_pkey; Type: CONSTRAINT; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY tag_index
    ADD CONSTRAINT model_tag_index_pkey PRIMARY KEY (entity_name, vocabulary_name, term_name, tenant_id);


--
-- Name: vocabulary_terms; Type: CONSTRAINT; Owner: :"user_name"; Tablespace:
--

ALTER TABLE ONLY vocabulary_terms
    ADD CONSTRAINT vocabulary_terms_pkey PRIMARY KEY (vocabulary_name, term_name, vocabulary_type);


--
-- Name: root_entity_collection_pkey; Type: CONSTRAINT; Owner: :"user_name"; Tablespace:
--

ALTER TABLE ONLY root_entity_collection
    ADD CONSTRAINT root_entity_collection_pkey PRIMARY KEY (name);


--
-- Name: modeltagindex_entity_name_index; Type: INDEX; Owner: postgres; Tablespace:
--

CREATE INDEX modeltagindex_entity_name_index ON tag_index USING btree (entity_name);


--
-- Name: modeltagindex_tag_index; Type: INDEX; Owner: postgres; Tablespace:
--

CREATE INDEX modeltagindex_tag_index ON tag_index USING btree (vocabulary_name, term_name);


--
-- Name: modeltagindex_term_index; Type: INDEX; Owner: postgres; Tablespace:
--

CREATE INDEX modeltagindex_term_index ON tag_index USING btree (lower((term_name)::text));


--
-- Name: modeltagindex_vocabulary_index; Type: INDEX; Owner: postgres; Tablespace:
--

CREATE INDEX modeltagindex_vocabulary_index ON tag_index USING btree (vocabulary_name);


--
-- Name: systemversion_servername_index; Type: INDEX; Owner: postgres; Tablespace:
--

CREATE INDEX systemversion_servername_index ON system_version USING btree (server_name);

--
-- Name: vocabularyterms_index; Type: INDEX; Owner: postgres; Tablespace:
--

CREATE INDEX vocabularyterms_index ON vocabulary_terms USING btree (vocabulary_name, term_name, vocabulary_type);

--
-- Name: vocabularyterms_vocabulary_index; Type: INDEX; Owner: postgres; Tablespace:
--

CREATE INDEX vocabularyterms_vocabulary_index ON vocabulary_terms USING btree (vocabulary_name, vocabulary_type);

--
-- Name: vocabularyterms_terms_index; Type: INDEX; Owner: postgres; Tablespace:
--

CREATE INDEX vocabularyterms_terms_index ON vocabulary_terms USING btree (term_name, vocabulary_type);

--
-- Name: modelindex_project_name_index; Type: INDEX; Owner: postgres; Tablespace:
--

CREATE INDEX modelindex_project_name_index ON model_index USING btree (project_name);


-- Raises an exception if the specified Id does not match the most recent Id
-- within the 'system_ownership' table. The raised exception will have a code of
-- '28SOA', where the '28' categorizes this exception as an
-- 'invalid_authorization_specification' exception (i.e. error code '28000'),
-- and the custom value of 'SOA' stands for 'System Ownership Authorization'.
-- See the standard XOPEN and/or SQL:2003 error codes for more information.
CREATE FUNCTION fail_if_not_system_owner(system_ownership_id system_ownership.id%TYPE)
    RETURNS VOID
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
            SELECT id
            FROM system_ownership
            WHERE id IN (SELECT id FROM system_ownership ORDER BY took_ownership DESC LIMIT 1)
            AND id = system_ownership_id )
    THEN
        -- '28SOA' is a combination of the '28000' error code mask (i.e.
        -- 'invalid_authorization_specification'), plus 'SOA' for (S)ystem
        -- (O)wnership (A)uthorization.
        RAISE EXCEPTION SQLSTATE '28SOA' USING MESSAGE = 'Database access prohibited because System Ownership has been lost.';
    END IF;
END;
$$;

ALTER FUNCTION fail_if_not_system_owner(system_ownership.id%TYPE) OWNER TO :"user_name";



--
-- Thingworx Platform Version 8.4 PostgreSQL database model schema complete
--
