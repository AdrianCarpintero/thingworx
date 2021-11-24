/**

A table for storing authorized grants per user, resource server pairs

TOKEN: Encrypted binary serialization of OAuth2AccessToken object.
AUTHENTICATION_ID: This is the primary key and should represent resource server / principal pair. For example: rs_id + user_id

**/

CREATE TABLE IF NOT EXISTS oauth_client_token (
  token bytea,
  authentication_id character varying(256) NOT NULL,
  CONSTRAINT oauth_client_token_pkey PRIMARY KEY (authentication_id)
);

ALTER TABLE oauth_client_token OWNER TO :"user_name";