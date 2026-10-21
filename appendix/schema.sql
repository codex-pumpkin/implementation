CREATE TABLE accounts
(
    id               UUID PRIMARY KEY,
    created_at       TIMESTAMP NOT NULL DEFAULT now(),
    email            TEXT      NOT NULL UNIQUE,
    username         TEXT      NOT NULL UNIQUE,
    admin            BOOL      NOT NULL,
    verified         BOOL      NOT NULL,
    google_client_id TEXT,
    password_hash    TEXT
);

CREATE TABLE llm_model_configs
(
    id         UUID PRIMARY KEY,
    name       TEXT NOT NULL,
    url        TEXT NOT NULL,
    api_key    TEXT,
    account_id UUID NOT NULL REFERENCES accounts (id)
);

CREATE TYPE auth_token_type AS ENUM ('refresh', 'email_verification', 'password_reset');

CREATE TABLE auth_tokens
(
    id         UUID PRIMARY KEY,
    type       auth_token_type NOT NULL,
    valid      BOOL            NOT NULL,
    created_at TIMESTAMP       NOT NULL DEFAULT now(),
    expires_at TIMESTAMP       NOT NULL,
    account_id UUID            NOT NULL REFERENCES accounts (id)
);

CREATE TABLE conversations
(
    id                  UUID PRIMARY KEY,
    created_at          TIMESTAMP NOT NULL DEFAULT now(),
    name                TEXT      NOT NULL,
    pinned              BOOL      NOT NULL,
    llm_model_config_id UUID      NOT NULL REFERENCES llm_model_configs (id),
    target_language     TEXT      NOT NULL,
    account_id          UUID      NOT NULL REFERENCES accounts (id)
);

CREATE TABLE messages
(
    id         UUID PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    prompt TEXT NOT NULL ,
    generation_millis INTEGER NOT NULL ,
    response TEXT NOT NULL ,
    response_secondary TEXT,
    conversation_id UUID NOT NULL REFERENCES conversations(id)
);

CREATE TABLE quota_config(
    id UUID PRIMARY KEY ,
    admin_limit INTEGER,
    member_limit INTEGER
);