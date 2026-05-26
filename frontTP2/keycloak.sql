--
-- PostgreSQL database dump
--

\restrict 2p47VeoTHc06xZKbYyrQp3LCgtpbBnCos52fPBAMfLk0GfC6gwjbYPRMko0Dia4

-- Dumped from database version 15.17 (Debian 15.17-1.pgdg13+1)
-- Dumped by pg_dump version 15.17 (Debian 15.17-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64),
    details_json text
);


ALTER TABLE public.admin_event_entity OWNER TO keycloak;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO keycloak;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO keycloak;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO keycloak;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO keycloak;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO keycloak;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO keycloak;

--
-- Name: client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO keycloak;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO keycloak;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO keycloak;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO keycloak;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO keycloak;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO keycloak;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO keycloak;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO keycloak;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO keycloak;

--
-- Name: component; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO keycloak;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO keycloak;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO keycloak;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer,
    version integer DEFAULT 0
);


ALTER TABLE public.credential OWNER TO keycloak;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO keycloak;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO keycloak;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO keycloak;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO keycloak;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024),
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.fed_user_attribute OWNER TO keycloak;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO keycloak;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO keycloak;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO keycloak;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO keycloak;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO keycloak;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO keycloak;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO keycloak;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO keycloak;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO keycloak;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO keycloak;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean,
    authenticate_by_default boolean,
    realm_id character varying(36),
    add_token_role boolean,
    trust_email boolean,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean,
    organization_id character varying(255),
    hide_on_login boolean
);


ALTER TABLE public.identity_provider OWNER TO keycloak;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO keycloak;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO keycloak;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO keycloak;

--
-- Name: jgroups_ping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.jgroups_ping (
    address character varying(200) NOT NULL,
    name character varying(200),
    cluster_name character varying(200) NOT NULL,
    ip character varying(200) NOT NULL,
    coord boolean
);


ALTER TABLE public.jgroups_ping OWNER TO keycloak;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36),
    type integer DEFAULT 0 NOT NULL,
    description character varying(255),
    org_id character varying(255),
    created_timestamp bigint,
    last_modified_timestamp bigint
);


ALTER TABLE public.keycloak_group OWNER TO keycloak;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO keycloak;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO keycloak;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL,
    version integer DEFAULT 0,
    realm_id character varying(36)
);


ALTER TABLE public.offline_client_session OWNER TO keycloak;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL,
    broker_session_id character varying(1024),
    version integer DEFAULT 0,
    remember_me boolean
);


ALTER TABLE public.offline_user_session OWNER TO keycloak;

--
-- Name: org; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.org (
    id character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    realm_id character varying(255) NOT NULL,
    group_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    alias character varying(255) NOT NULL,
    redirect_url character varying(2048)
);


ALTER TABLE public.org OWNER TO keycloak;

--
-- Name: org_domain; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.org_domain (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    verified boolean NOT NULL,
    org_id character varying(255) NOT NULL
);


ALTER TABLE public.org_domain OWNER TO keycloak;

--
-- Name: org_invitation; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.org_invitation (
    id character varying(36) NOT NULL,
    organization_id character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    created_at integer NOT NULL,
    expires_at integer,
    invite_link character varying(2048)
);


ALTER TABLE public.org_invitation OWNER TO keycloak;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO keycloak;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO keycloak;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO keycloak;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO keycloak;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO keycloak;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO keycloak;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO keycloak;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO keycloak;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO keycloak;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO keycloak;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO keycloak;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO keycloak;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO keycloak;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO keycloak;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO keycloak;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO keycloak;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO keycloak;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO keycloak;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO keycloak;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO keycloak;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO keycloak;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO keycloak;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO keycloak;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO keycloak;

--
-- Name: revoked_token; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.revoked_token (
    id character varying(255) NOT NULL,
    expire bigint NOT NULL
);


ALTER TABLE public.revoked_token OWNER TO keycloak;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO keycloak;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO keycloak;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO keycloak;

--
-- Name: server_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.server_config (
    server_config_key character varying(255) NOT NULL,
    value text NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.server_config OWNER TO keycloak;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.user_attribute OWNER TO keycloak;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO keycloak;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO keycloak;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL,
    last_modified_timestamp bigint
);


ALTER TABLE public.user_entity OWNER TO keycloak;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO keycloak;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO keycloak;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO keycloak;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO keycloak;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    membership_type character varying(255) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO keycloak;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO keycloak;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO keycloak;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO keycloak;

--
-- Name: workflow_state; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.workflow_state (
    execution_id character varying(255) NOT NULL,
    resource_id character varying(255) NOT NULL,
    workflow_id character varying(255) NOT NULL,
    resource_type character varying(255),
    scheduled_step_id character varying(255),
    scheduled_step_timestamp bigint
);


ALTER TABLE public.workflow_state OWNER TO keycloak;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type, details_json) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
b76e6704-43e2-41da-9548-55b433ebfd85	\N	auth-cookie	266e0ee5-a56b-4faf-89f4-02c5567093d1	d65beb10-107b-415c-85ef-b5a82d2540b6	2	10	f	\N	\N
068f4313-8ab9-405a-b519-65c878a615c7	\N	auth-spnego	266e0ee5-a56b-4faf-89f4-02c5567093d1	d65beb10-107b-415c-85ef-b5a82d2540b6	3	20	f	\N	\N
3cb97d86-0527-4240-a985-c8979b0462e2	\N	identity-provider-redirector	266e0ee5-a56b-4faf-89f4-02c5567093d1	d65beb10-107b-415c-85ef-b5a82d2540b6	2	25	f	\N	\N
8c0f2269-2dc3-46a0-9cbb-bba239058dee	\N	\N	266e0ee5-a56b-4faf-89f4-02c5567093d1	d65beb10-107b-415c-85ef-b5a82d2540b6	2	30	t	06138ea6-5bca-4041-ac6d-9e770ec65123	\N
2ab61910-acfe-46b2-a2d7-f0274c2f760b	\N	auth-username-password-form	266e0ee5-a56b-4faf-89f4-02c5567093d1	06138ea6-5bca-4041-ac6d-9e770ec65123	0	10	f	\N	\N
45f58abc-aba6-4f78-9a6c-24fb147bc0b8	\N	\N	266e0ee5-a56b-4faf-89f4-02c5567093d1	06138ea6-5bca-4041-ac6d-9e770ec65123	1	20	t	826f24ab-a0a9-4132-9170-d1c7c2eeacc6	\N
ed5d78e5-37fc-45a9-8422-94258303685f	\N	conditional-user-configured	266e0ee5-a56b-4faf-89f4-02c5567093d1	826f24ab-a0a9-4132-9170-d1c7c2eeacc6	0	10	f	\N	\N
6715c8f1-6935-49df-89a1-265adb623f21	\N	conditional-credential	266e0ee5-a56b-4faf-89f4-02c5567093d1	826f24ab-a0a9-4132-9170-d1c7c2eeacc6	0	20	f	\N	cfc7f1ce-0fed-43e1-be84-51d63e25a473
ee1279de-e57f-45ca-a7d9-4baf6a2ca2fa	\N	auth-otp-form	266e0ee5-a56b-4faf-89f4-02c5567093d1	826f24ab-a0a9-4132-9170-d1c7c2eeacc6	2	30	f	\N	\N
13feb26a-8c97-40aa-9be1-d35e18029b67	\N	webauthn-authenticator	266e0ee5-a56b-4faf-89f4-02c5567093d1	826f24ab-a0a9-4132-9170-d1c7c2eeacc6	3	40	f	\N	\N
7ec5568c-d6e2-4825-bea6-dd8db5eba3f9	\N	auth-recovery-authn-code-form	266e0ee5-a56b-4faf-89f4-02c5567093d1	826f24ab-a0a9-4132-9170-d1c7c2eeacc6	3	50	f	\N	\N
f728f1e7-94a4-4338-aa9b-a7c5d9a4d53e	\N	direct-grant-validate-username	266e0ee5-a56b-4faf-89f4-02c5567093d1	3f6f1be5-5c51-43d4-ade2-48b8bf6984b3	0	10	f	\N	\N
5615dea8-7742-45d4-91b6-4f5e8ff90097	\N	direct-grant-validate-password	266e0ee5-a56b-4faf-89f4-02c5567093d1	3f6f1be5-5c51-43d4-ade2-48b8bf6984b3	0	20	f	\N	\N
4be6756e-e371-490a-9d69-15fb9b19dfe4	\N	\N	266e0ee5-a56b-4faf-89f4-02c5567093d1	3f6f1be5-5c51-43d4-ade2-48b8bf6984b3	1	30	t	3a457413-b000-4b1c-8902-8e00ab78d10c	\N
cbfeac03-5f86-4ee8-b22e-2f3d6af6aa50	\N	conditional-user-configured	266e0ee5-a56b-4faf-89f4-02c5567093d1	3a457413-b000-4b1c-8902-8e00ab78d10c	0	10	f	\N	\N
99fdabc5-3fe1-41b7-bbc5-587bec2de75c	\N	direct-grant-validate-otp	266e0ee5-a56b-4faf-89f4-02c5567093d1	3a457413-b000-4b1c-8902-8e00ab78d10c	0	20	f	\N	\N
3780caa9-6a50-4055-9196-9ffee5786594	\N	registration-page-form	266e0ee5-a56b-4faf-89f4-02c5567093d1	b7a15dff-5f73-4474-9900-03e33462f84f	0	10	t	bf37d1db-0a2b-41f7-b274-9afbf023c48f	\N
5488b7ff-28f8-407d-873b-13b084eab960	\N	registration-user-creation	266e0ee5-a56b-4faf-89f4-02c5567093d1	bf37d1db-0a2b-41f7-b274-9afbf023c48f	0	20	f	\N	\N
91933223-6d61-4ca0-ad4a-c9a51ff92f50	\N	registration-password-action	266e0ee5-a56b-4faf-89f4-02c5567093d1	bf37d1db-0a2b-41f7-b274-9afbf023c48f	0	50	f	\N	\N
30d46d5e-16bc-497d-8acc-a08520aff005	\N	registration-recaptcha-action	266e0ee5-a56b-4faf-89f4-02c5567093d1	bf37d1db-0a2b-41f7-b274-9afbf023c48f	3	60	f	\N	\N
9335e666-3eb4-4fa6-b77d-4b5a1dcae630	\N	registration-terms-and-conditions	266e0ee5-a56b-4faf-89f4-02c5567093d1	bf37d1db-0a2b-41f7-b274-9afbf023c48f	3	70	f	\N	\N
ede32860-a5d4-4494-b15e-1cdc2e346dca	\N	reset-credentials-choose-user	266e0ee5-a56b-4faf-89f4-02c5567093d1	27d60081-3500-4b2d-b2c1-0a75b6e36760	0	10	f	\N	\N
9dd56ab0-8c0b-4422-be81-5c9081399957	\N	reset-credential-email	266e0ee5-a56b-4faf-89f4-02c5567093d1	27d60081-3500-4b2d-b2c1-0a75b6e36760	0	20	f	\N	\N
711b9807-1b6f-4f41-b153-6741b89d69bd	\N	reset-password	266e0ee5-a56b-4faf-89f4-02c5567093d1	27d60081-3500-4b2d-b2c1-0a75b6e36760	0	30	f	\N	\N
e179ea36-3518-4aa7-966a-cd552a7e1fe9	\N	\N	266e0ee5-a56b-4faf-89f4-02c5567093d1	27d60081-3500-4b2d-b2c1-0a75b6e36760	1	40	t	807f724f-3ca9-4b2d-a8e9-990eeb69f110	\N
a3277557-cae0-4643-8b96-9146dd0ad3d6	\N	conditional-user-configured	266e0ee5-a56b-4faf-89f4-02c5567093d1	807f724f-3ca9-4b2d-a8e9-990eeb69f110	0	10	f	\N	\N
97d2511f-533a-4b96-8409-5f2e7a476793	\N	reset-otp	266e0ee5-a56b-4faf-89f4-02c5567093d1	807f724f-3ca9-4b2d-a8e9-990eeb69f110	0	20	f	\N	\N
75525396-1e18-46bb-b6b6-132fe7d13414	\N	client-secret	266e0ee5-a56b-4faf-89f4-02c5567093d1	99dd71be-c3ff-4e53-95fd-5bcce02ba06f	2	10	f	\N	\N
6f513fcd-dbbd-4566-81e3-4972dc2790fd	\N	client-jwt	266e0ee5-a56b-4faf-89f4-02c5567093d1	99dd71be-c3ff-4e53-95fd-5bcce02ba06f	2	20	f	\N	\N
f9c46ed3-faa5-4a5a-b8ad-c3b4dea360cb	\N	client-secret-jwt	266e0ee5-a56b-4faf-89f4-02c5567093d1	99dd71be-c3ff-4e53-95fd-5bcce02ba06f	2	30	f	\N	\N
4a3d8d52-a82d-4fb3-8b9b-92a6b8714c3b	\N	client-x509	266e0ee5-a56b-4faf-89f4-02c5567093d1	99dd71be-c3ff-4e53-95fd-5bcce02ba06f	2	40	f	\N	\N
490e03b3-c9c2-4119-b7d6-65b48ce12f17	\N	federated-jwt	266e0ee5-a56b-4faf-89f4-02c5567093d1	99dd71be-c3ff-4e53-95fd-5bcce02ba06f	2	50	f	\N	\N
c406da43-16fa-48ef-b358-76a42365ba04	\N	idp-review-profile	266e0ee5-a56b-4faf-89f4-02c5567093d1	61bd23d5-9007-4154-a13d-33364c1d06eb	0	10	f	\N	16278cdf-739c-4f17-8996-6cc5991df088
c7e1d722-3026-4d6c-9286-272bdd059e8c	\N	\N	266e0ee5-a56b-4faf-89f4-02c5567093d1	61bd23d5-9007-4154-a13d-33364c1d06eb	0	20	t	e11c062e-2ef3-4183-b659-c0a066458eb2	\N
9fb1c319-0b0c-4e5f-bc98-f59fca4d3a1b	\N	idp-create-user-if-unique	266e0ee5-a56b-4faf-89f4-02c5567093d1	e11c062e-2ef3-4183-b659-c0a066458eb2	2	10	f	\N	4a1114d7-615f-45b3-a88c-fefc6df02709
9738a325-82d2-464f-8517-2f412471874a	\N	\N	266e0ee5-a56b-4faf-89f4-02c5567093d1	e11c062e-2ef3-4183-b659-c0a066458eb2	2	20	t	cf4e600b-cdb2-4acb-af3e-6dd0db8a9830	\N
6fc02e04-7841-4262-90e2-55721134f4a3	\N	idp-confirm-link	266e0ee5-a56b-4faf-89f4-02c5567093d1	cf4e600b-cdb2-4acb-af3e-6dd0db8a9830	0	10	f	\N	\N
01a197e8-8f6c-4534-836b-1076f7d653a8	\N	\N	266e0ee5-a56b-4faf-89f4-02c5567093d1	cf4e600b-cdb2-4acb-af3e-6dd0db8a9830	0	20	t	450427d9-98c2-41d2-bcd2-365a3abe5e75	\N
ec01c955-66c8-4fdb-8915-2d065e9cc1fd	\N	idp-email-verification	266e0ee5-a56b-4faf-89f4-02c5567093d1	450427d9-98c2-41d2-bcd2-365a3abe5e75	2	10	f	\N	\N
8506a638-17af-41c0-aea3-3297951a6496	\N	\N	266e0ee5-a56b-4faf-89f4-02c5567093d1	450427d9-98c2-41d2-bcd2-365a3abe5e75	2	20	t	5016ce4d-4d97-4d98-8de6-73034fa9f3b5	\N
bad77a1b-ac2f-47ea-980c-a00f059f90c0	\N	idp-username-password-form	266e0ee5-a56b-4faf-89f4-02c5567093d1	5016ce4d-4d97-4d98-8de6-73034fa9f3b5	0	10	f	\N	\N
41ec1411-18de-418c-bf4a-8e500a86ba88	\N	\N	266e0ee5-a56b-4faf-89f4-02c5567093d1	5016ce4d-4d97-4d98-8de6-73034fa9f3b5	1	20	t	c4c3d73c-1112-433b-ab94-6f4865c17b76	\N
7e5672ec-a9b3-4182-b394-6618ea33c298	\N	conditional-user-configured	266e0ee5-a56b-4faf-89f4-02c5567093d1	c4c3d73c-1112-433b-ab94-6f4865c17b76	0	10	f	\N	\N
b40b102e-fb22-4cc2-a53f-5580597e37eb	\N	conditional-credential	266e0ee5-a56b-4faf-89f4-02c5567093d1	c4c3d73c-1112-433b-ab94-6f4865c17b76	0	20	f	\N	34f72cf6-2e0e-4349-80b2-23cd40acb7ba
200d7396-3918-40b2-9795-8fad1992804b	\N	auth-otp-form	266e0ee5-a56b-4faf-89f4-02c5567093d1	c4c3d73c-1112-433b-ab94-6f4865c17b76	2	30	f	\N	\N
a6972208-0306-40f8-a9b4-6ac7bf633e65	\N	webauthn-authenticator	266e0ee5-a56b-4faf-89f4-02c5567093d1	c4c3d73c-1112-433b-ab94-6f4865c17b76	3	40	f	\N	\N
b885e938-d169-46dc-963a-b6000376815d	\N	auth-recovery-authn-code-form	266e0ee5-a56b-4faf-89f4-02c5567093d1	c4c3d73c-1112-433b-ab94-6f4865c17b76	3	50	f	\N	\N
d5a4e777-38fd-4291-8601-19c543f0ebeb	\N	http-basic-authenticator	266e0ee5-a56b-4faf-89f4-02c5567093d1	82e366af-22bd-442e-9958-7a61ef3ad6e1	0	10	f	\N	\N
728874a4-a610-4a80-b201-fd1144b7cd98	\N	docker-http-basic-authenticator	266e0ee5-a56b-4faf-89f4-02c5567093d1	5969e406-4dae-4fff-af95-fc584ebdfcf5	0	10	f	\N	\N
cafa0adf-efb1-4a31-95ab-e7b3fde9a377	\N	idp-email-verification	14468de3-0b67-44ab-a988-6565b42d2e10	5e0e6be0-6d76-47f6-b451-d5094aa9699e	2	10	f	\N	\N
7934ec75-ba78-4f10-a984-fab6b3a0ed79	\N	\N	14468de3-0b67-44ab-a988-6565b42d2e10	5e0e6be0-6d76-47f6-b451-d5094aa9699e	2	20	t	6d7b693d-77f2-466a-b765-af86114e3120	\N
fdd0c84b-97a8-4f60-a11e-1aaf2d066f65	\N	conditional-user-configured	14468de3-0b67-44ab-a988-6565b42d2e10	197740bf-45ad-4201-844e-35d259189394	0	10	f	\N	\N
bb240765-043e-4fb0-b033-59e67300c90d	\N	conditional-credential	14468de3-0b67-44ab-a988-6565b42d2e10	197740bf-45ad-4201-844e-35d259189394	0	20	f	\N	ad335be6-af42-4874-8cfe-dadf56c852d9
77e7835e-2331-4253-82c2-bc5c99084d67	\N	auth-otp-form	14468de3-0b67-44ab-a988-6565b42d2e10	197740bf-45ad-4201-844e-35d259189394	2	30	f	\N	\N
12f45fff-07f0-4e78-8ed6-79a8dfd15785	\N	webauthn-authenticator	14468de3-0b67-44ab-a988-6565b42d2e10	197740bf-45ad-4201-844e-35d259189394	3	40	f	\N	\N
aa9751ed-0001-4b69-aca5-c4e0ec842cdf	\N	auth-recovery-authn-code-form	14468de3-0b67-44ab-a988-6565b42d2e10	197740bf-45ad-4201-844e-35d259189394	3	50	f	\N	\N
7033a274-b069-449c-86bb-732ce6bcdca1	\N	conditional-user-configured	14468de3-0b67-44ab-a988-6565b42d2e10	5d541309-aed8-48fb-8cde-48acab7b5847	0	10	f	\N	\N
aa49d075-c87d-4748-96b5-eaae9822a212	\N	organization	14468de3-0b67-44ab-a988-6565b42d2e10	5d541309-aed8-48fb-8cde-48acab7b5847	2	20	f	\N	\N
88425320-02df-4f42-9f22-25af37931240	\N	conditional-user-configured	14468de3-0b67-44ab-a988-6565b42d2e10	801e9bbb-fd86-4989-ae5f-1fea1414a434	0	10	f	\N	\N
433e9906-ee0f-4e38-adfe-127b2b5aebe9	\N	direct-grant-validate-otp	14468de3-0b67-44ab-a988-6565b42d2e10	801e9bbb-fd86-4989-ae5f-1fea1414a434	0	20	f	\N	\N
511d8bf3-9df2-4d48-adf3-271c6fee72bc	\N	conditional-user-configured	14468de3-0b67-44ab-a988-6565b42d2e10	6583a0a8-5203-425c-9e6a-09cc870fbf92	0	10	f	\N	\N
55df7d04-ce52-4a75-a8e6-e8cc44f9ceff	\N	idp-add-organization-member	14468de3-0b67-44ab-a988-6565b42d2e10	6583a0a8-5203-425c-9e6a-09cc870fbf92	0	20	f	\N	\N
b62a6245-ddd4-4834-b293-58b550b7757c	\N	conditional-user-configured	14468de3-0b67-44ab-a988-6565b42d2e10	ef2d450c-a5dd-41d6-9385-acdb8ccfef71	0	10	f	\N	\N
00f84d2e-c6fe-4f5d-b949-735c8e6e8b50	\N	conditional-credential	14468de3-0b67-44ab-a988-6565b42d2e10	ef2d450c-a5dd-41d6-9385-acdb8ccfef71	0	20	f	\N	a5c2b5fc-86dc-41db-a6d2-5a513746a259
ebf823c2-46f8-4614-91de-2d640a2eaaef	\N	auth-otp-form	14468de3-0b67-44ab-a988-6565b42d2e10	ef2d450c-a5dd-41d6-9385-acdb8ccfef71	2	30	f	\N	\N
ddcc3d0b-8d27-4cc7-b561-69569288914a	\N	webauthn-authenticator	14468de3-0b67-44ab-a988-6565b42d2e10	ef2d450c-a5dd-41d6-9385-acdb8ccfef71	3	40	f	\N	\N
42217e39-0acf-48b9-b475-361bc9cb10f8	\N	auth-recovery-authn-code-form	14468de3-0b67-44ab-a988-6565b42d2e10	ef2d450c-a5dd-41d6-9385-acdb8ccfef71	3	50	f	\N	\N
01729934-a709-4897-886b-d0e301cd4360	\N	idp-confirm-link	14468de3-0b67-44ab-a988-6565b42d2e10	cf66e731-0367-4c58-baf7-7d75e0e35bf2	0	10	f	\N	\N
999f25fd-eab3-46c4-bef7-373de59d03ae	\N	\N	14468de3-0b67-44ab-a988-6565b42d2e10	cf66e731-0367-4c58-baf7-7d75e0e35bf2	0	20	t	5e0e6be0-6d76-47f6-b451-d5094aa9699e	\N
bda6867f-7a46-4b28-8210-565acd4d7cb2	\N	\N	14468de3-0b67-44ab-a988-6565b42d2e10	b4caccf1-fec5-4653-ae4e-50bc0891a181	1	10	t	5d541309-aed8-48fb-8cde-48acab7b5847	\N
7c0276dc-60c8-497b-b96e-0e1ad3639c64	\N	conditional-user-configured	14468de3-0b67-44ab-a988-6565b42d2e10	0227336b-6f23-4307-a432-e899e03974f9	0	10	f	\N	\N
2a3c64af-b5ab-41e8-9f17-a14729d7e7c9	\N	reset-otp	14468de3-0b67-44ab-a988-6565b42d2e10	0227336b-6f23-4307-a432-e899e03974f9	0	20	f	\N	\N
b12b273f-94f1-4005-849c-8da3ce9790ca	\N	idp-create-user-if-unique	14468de3-0b67-44ab-a988-6565b42d2e10	d5c9530c-4db7-4e0b-a138-99dd64c7f8ea	2	10	f	\N	cfa50795-9483-409b-ba90-6c15a3cb60ad
3fc8ec88-62ec-428c-b874-791eb0f3e20c	\N	\N	14468de3-0b67-44ab-a988-6565b42d2e10	d5c9530c-4db7-4e0b-a138-99dd64c7f8ea	2	20	t	cf66e731-0367-4c58-baf7-7d75e0e35bf2	\N
68db7b89-719b-432c-b710-90a62e3cc22b	\N	idp-username-password-form	14468de3-0b67-44ab-a988-6565b42d2e10	6d7b693d-77f2-466a-b765-af86114e3120	0	10	f	\N	\N
25e425a1-56a6-46ac-8ff5-65996b08b145	\N	\N	14468de3-0b67-44ab-a988-6565b42d2e10	6d7b693d-77f2-466a-b765-af86114e3120	1	20	t	ef2d450c-a5dd-41d6-9385-acdb8ccfef71	\N
bb423948-e69b-4ad4-af4d-b0f66fa285da	\N	auth-cookie	14468de3-0b67-44ab-a988-6565b42d2e10	07953e34-acfa-43f1-80cf-9bf2c72ed41e	2	10	f	\N	\N
d1da358a-b407-4992-b604-2557fe231408	\N	auth-spnego	14468de3-0b67-44ab-a988-6565b42d2e10	07953e34-acfa-43f1-80cf-9bf2c72ed41e	3	20	f	\N	\N
7362a8ee-3157-4a1d-8fd0-7f8f645b3fcc	\N	identity-provider-redirector	14468de3-0b67-44ab-a988-6565b42d2e10	07953e34-acfa-43f1-80cf-9bf2c72ed41e	2	25	f	\N	\N
cdd927f5-9e3c-4bd7-af3e-7371282c228e	\N	\N	14468de3-0b67-44ab-a988-6565b42d2e10	07953e34-acfa-43f1-80cf-9bf2c72ed41e	2	26	t	b4caccf1-fec5-4653-ae4e-50bc0891a181	\N
ea339318-f48c-4db5-be8f-7ae62f955159	\N	\N	14468de3-0b67-44ab-a988-6565b42d2e10	07953e34-acfa-43f1-80cf-9bf2c72ed41e	2	30	t	56a6ddb5-83e9-4e1e-8bd5-536b7bafdb45	\N
6cd2d5f3-bfcf-47e4-8118-6b615777e98b	\N	client-secret	14468de3-0b67-44ab-a988-6565b42d2e10	2304534f-e682-412f-a2ab-cb544996e9a0	2	10	f	\N	\N
faf6337c-e443-4eeb-9f67-0423c3098596	\N	client-jwt	14468de3-0b67-44ab-a988-6565b42d2e10	2304534f-e682-412f-a2ab-cb544996e9a0	2	20	f	\N	\N
860209b4-e2de-4acb-b437-8674ca91ae5e	\N	client-secret-jwt	14468de3-0b67-44ab-a988-6565b42d2e10	2304534f-e682-412f-a2ab-cb544996e9a0	2	30	f	\N	\N
71df6b5f-37e3-4964-b36d-4aed81c86082	\N	client-x509	14468de3-0b67-44ab-a988-6565b42d2e10	2304534f-e682-412f-a2ab-cb544996e9a0	2	40	f	\N	\N
1853c689-0b82-437c-836f-9fb5289e4274	\N	federated-jwt	14468de3-0b67-44ab-a988-6565b42d2e10	2304534f-e682-412f-a2ab-cb544996e9a0	2	50	f	\N	\N
93e09def-24e8-4f18-9495-2989817b39ce	\N	direct-grant-validate-username	14468de3-0b67-44ab-a988-6565b42d2e10	2ca688cb-2627-471e-a30e-17f0bd92b22e	0	10	f	\N	\N
f4235931-e982-4e89-b6d2-abe3bd99aa73	\N	direct-grant-validate-password	14468de3-0b67-44ab-a988-6565b42d2e10	2ca688cb-2627-471e-a30e-17f0bd92b22e	0	20	f	\N	\N
67867a93-718f-4767-9b57-c0960fde19ef	\N	\N	14468de3-0b67-44ab-a988-6565b42d2e10	2ca688cb-2627-471e-a30e-17f0bd92b22e	1	30	t	801e9bbb-fd86-4989-ae5f-1fea1414a434	\N
afa7aa87-269b-453a-aabd-922862bf69cd	\N	docker-http-basic-authenticator	14468de3-0b67-44ab-a988-6565b42d2e10	54ffd8de-6ad1-4601-a44b-2eeae54ff937	0	10	f	\N	\N
3c992952-a99b-45bc-acc7-0571c52da254	\N	idp-review-profile	14468de3-0b67-44ab-a988-6565b42d2e10	262dbae7-e276-4e0e-bd97-cebdd80169cd	0	10	f	\N	ca8396d8-81bd-4b3b-b6c8-42bc394af398
6da37488-f320-45b2-be70-678d4c5d78e8	\N	\N	14468de3-0b67-44ab-a988-6565b42d2e10	262dbae7-e276-4e0e-bd97-cebdd80169cd	0	20	t	d5c9530c-4db7-4e0b-a138-99dd64c7f8ea	\N
72243a9b-49a9-4455-a9ac-c15230e45232	\N	\N	14468de3-0b67-44ab-a988-6565b42d2e10	262dbae7-e276-4e0e-bd97-cebdd80169cd	1	60	t	6583a0a8-5203-425c-9e6a-09cc870fbf92	\N
a035a205-0f61-4c06-968b-31a391e43512	\N	auth-username-password-form	14468de3-0b67-44ab-a988-6565b42d2e10	56a6ddb5-83e9-4e1e-8bd5-536b7bafdb45	0	10	f	\N	\N
819e0771-0e3f-4380-89e2-e0d3baa909c2	\N	\N	14468de3-0b67-44ab-a988-6565b42d2e10	56a6ddb5-83e9-4e1e-8bd5-536b7bafdb45	1	20	t	197740bf-45ad-4201-844e-35d259189394	\N
e4ea697d-b056-48b0-9aaa-877d106762b8	\N	registration-page-form	14468de3-0b67-44ab-a988-6565b42d2e10	47e4dffc-18f7-4591-bf0d-8efdd635d018	0	10	t	b9c5a8ab-ac67-457b-9941-53d8c0753edf	\N
03569747-67d4-4e16-af97-5971d0746a49	\N	registration-user-creation	14468de3-0b67-44ab-a988-6565b42d2e10	b9c5a8ab-ac67-457b-9941-53d8c0753edf	0	20	f	\N	\N
2c8fbe2c-ad04-4284-81a5-df44d1b668fa	\N	registration-password-action	14468de3-0b67-44ab-a988-6565b42d2e10	b9c5a8ab-ac67-457b-9941-53d8c0753edf	0	50	f	\N	\N
ffd3322d-a396-4882-8b6a-8a72c15160fe	\N	registration-recaptcha-action	14468de3-0b67-44ab-a988-6565b42d2e10	b9c5a8ab-ac67-457b-9941-53d8c0753edf	3	60	f	\N	\N
ae2efd20-c819-42f7-8b03-b09a44c78a03	\N	registration-terms-and-conditions	14468de3-0b67-44ab-a988-6565b42d2e10	b9c5a8ab-ac67-457b-9941-53d8c0753edf	3	70	f	\N	\N
be8c8ce6-d452-4751-b021-af6e493ee766	\N	reset-credentials-choose-user	14468de3-0b67-44ab-a988-6565b42d2e10	be01d7ca-fc5e-4923-b44b-4040b1e33be8	0	10	f	\N	\N
1d5686f2-07f8-4d54-9780-1ce7dfd3a8df	\N	reset-credential-email	14468de3-0b67-44ab-a988-6565b42d2e10	be01d7ca-fc5e-4923-b44b-4040b1e33be8	0	20	f	\N	\N
68462a3c-b3fd-442a-85db-3470c6d2d55e	\N	reset-password	14468de3-0b67-44ab-a988-6565b42d2e10	be01d7ca-fc5e-4923-b44b-4040b1e33be8	0	30	f	\N	\N
2f949dcc-cc8c-4d81-b716-e65e91e7f485	\N	\N	14468de3-0b67-44ab-a988-6565b42d2e10	be01d7ca-fc5e-4923-b44b-4040b1e33be8	1	40	t	0227336b-6f23-4307-a432-e899e03974f9	\N
3e6e4d6c-3db0-4ed5-a15d-6c1a9a8de5ed	\N	http-basic-authenticator	14468de3-0b67-44ab-a988-6565b42d2e10	b21220a7-45e1-4b10-8a72-40b7857d4814	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
d65beb10-107b-415c-85ef-b5a82d2540b6	browser	Browser based authentication	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	t	t
06138ea6-5bca-4041-ac6d-9e770ec65123	forms	Username, password, otp and other auth forms.	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	f	t
826f24ab-a0a9-4132-9170-d1c7c2eeacc6	Browser - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	f	t
3f6f1be5-5c51-43d4-ade2-48b8bf6984b3	direct grant	OpenID Connect Resource Owner Grant	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	t	t
3a457413-b000-4b1c-8902-8e00ab78d10c	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	f	t
b7a15dff-5f73-4474-9900-03e33462f84f	registration	Registration flow	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	t	t
bf37d1db-0a2b-41f7-b274-9afbf023c48f	registration form	Registration form	266e0ee5-a56b-4faf-89f4-02c5567093d1	form-flow	f	t
27d60081-3500-4b2d-b2c1-0a75b6e36760	reset credentials	Reset credentials for a user if they forgot their password or something	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	t	t
807f724f-3ca9-4b2d-a8e9-990eeb69f110	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	f	t
99dd71be-c3ff-4e53-95fd-5bcce02ba06f	clients	Base authentication for clients	266e0ee5-a56b-4faf-89f4-02c5567093d1	client-flow	t	t
61bd23d5-9007-4154-a13d-33364c1d06eb	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	t	t
e11c062e-2ef3-4183-b659-c0a066458eb2	User creation or linking	Flow for the existing/non-existing user alternatives	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	f	t
cf4e600b-cdb2-4acb-af3e-6dd0db8a9830	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	f	t
450427d9-98c2-41d2-bcd2-365a3abe5e75	Account verification options	Method with which to verify the existing account	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	f	t
5016ce4d-4d97-4d98-8de6-73034fa9f3b5	Verify Existing Account by Re-authentication	Reauthentication of existing account	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	f	t
c4c3d73c-1112-433b-ab94-6f4865c17b76	First broker login - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	f	t
82e366af-22bd-442e-9958-7a61ef3ad6e1	saml ecp	SAML ECP Profile Authentication Flow	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	t	t
5969e406-4dae-4fff-af95-fc584ebdfcf5	docker auth	Used by Docker clients to authenticate against the IDP	266e0ee5-a56b-4faf-89f4-02c5567093d1	basic-flow	t	t
5e0e6be0-6d76-47f6-b451-d5094aa9699e	Account verification options	Method with which to verify the existing account	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	f	t
197740bf-45ad-4201-844e-35d259189394	Browser - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	f	t
5d541309-aed8-48fb-8cde-48acab7b5847	Browser - Conditional Organization	Flow to determine if the organization identity-first login is to be used	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	f	t
801e9bbb-fd86-4989-ae5f-1fea1414a434	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	f	t
6583a0a8-5203-425c-9e6a-09cc870fbf92	First Broker Login - Conditional Organization	Flow to determine if the authenticator that adds organization members is to be used	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	f	t
ef2d450c-a5dd-41d6-9385-acdb8ccfef71	First broker login - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	f	t
cf66e731-0367-4c58-baf7-7d75e0e35bf2	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	f	t
b4caccf1-fec5-4653-ae4e-50bc0891a181	Organization	\N	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	f	t
0227336b-6f23-4307-a432-e899e03974f9	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	f	t
d5c9530c-4db7-4e0b-a138-99dd64c7f8ea	User creation or linking	Flow for the existing/non-existing user alternatives	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	f	t
6d7b693d-77f2-466a-b765-af86114e3120	Verify Existing Account by Re-authentication	Reauthentication of existing account	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	f	t
07953e34-acfa-43f1-80cf-9bf2c72ed41e	browser	Browser based authentication	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	t	t
2304534f-e682-412f-a2ab-cb544996e9a0	clients	Base authentication for clients	14468de3-0b67-44ab-a988-6565b42d2e10	client-flow	t	t
2ca688cb-2627-471e-a30e-17f0bd92b22e	direct grant	OpenID Connect Resource Owner Grant	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	t	t
54ffd8de-6ad1-4601-a44b-2eeae54ff937	docker auth	Used by Docker clients to authenticate against the IDP	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	t	t
262dbae7-e276-4e0e-bd97-cebdd80169cd	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	t	t
56a6ddb5-83e9-4e1e-8bd5-536b7bafdb45	forms	Username, password, otp and other auth forms.	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	f	t
47e4dffc-18f7-4591-bf0d-8efdd635d018	registration	Registration flow	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	t	t
b9c5a8ab-ac67-457b-9941-53d8c0753edf	registration form	Registration form	14468de3-0b67-44ab-a988-6565b42d2e10	form-flow	f	t
be01d7ca-fc5e-4923-b44b-4040b1e33be8	reset credentials	Reset credentials for a user if they forgot their password or something	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	t	t
b21220a7-45e1-4b10-8a72-40b7857d4814	saml ecp	SAML ECP Profile Authentication Flow	14468de3-0b67-44ab-a988-6565b42d2e10	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
cfc7f1ce-0fed-43e1-be84-51d63e25a473	browser-conditional-credential	266e0ee5-a56b-4faf-89f4-02c5567093d1
16278cdf-739c-4f17-8996-6cc5991df088	review profile config	266e0ee5-a56b-4faf-89f4-02c5567093d1
4a1114d7-615f-45b3-a88c-fefc6df02709	create unique user config	266e0ee5-a56b-4faf-89f4-02c5567093d1
34f72cf6-2e0e-4349-80b2-23cd40acb7ba	first-broker-login-conditional-credential	266e0ee5-a56b-4faf-89f4-02c5567093d1
ad335be6-af42-4874-8cfe-dadf56c852d9	browser-conditional-credential	14468de3-0b67-44ab-a988-6565b42d2e10
cfa50795-9483-409b-ba90-6c15a3cb60ad	create unique user config	14468de3-0b67-44ab-a988-6565b42d2e10
a5c2b5fc-86dc-41db-a6d2-5a513746a259	first-broker-login-conditional-credential	14468de3-0b67-44ab-a988-6565b42d2e10
ca8396d8-81bd-4b3b-b6c8-42bc394af398	review profile config	14468de3-0b67-44ab-a988-6565b42d2e10
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
16278cdf-739c-4f17-8996-6cc5991df088	missing	update.profile.on.first.login
34f72cf6-2e0e-4349-80b2-23cd40acb7ba	webauthn-passwordless	credentials
4a1114d7-615f-45b3-a88c-fefc6df02709	false	require.password.update.after.registration
cfc7f1ce-0fed-43e1-be84-51d63e25a473	webauthn-passwordless	credentials
a5c2b5fc-86dc-41db-a6d2-5a513746a259	webauthn-passwordless	credentials
ad335be6-af42-4874-8cfe-dadf56c852d9	webauthn-passwordless	credentials
ca8396d8-81bd-4b3b-b6c8-42bc394af398	missing	update.profile.on.first.login
cfa50795-9483-409b-ba90-6c15a3cb60ad	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	f	master-realm	0	f	\N	\N	t	\N	f	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
d0a046e1-427e-4a16-9bf1-8e6da31572bd	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	266e0ee5-a56b-4faf-89f4-02c5567093d1	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
139e3b65-55d2-41c8-95be-45bb7b554d46	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	266e0ee5-a56b-4faf-89f4-02c5567093d1	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
70b0ab56-1c02-4185-9288-7ea85b30e65b	t	f	broker	0	f	\N	\N	t	\N	f	266e0ee5-a56b-4faf-89f4-02c5567093d1	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
c5424ef9-8012-4f99-b4ad-e8456f980f8c	t	t	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	266e0ee5-a56b-4faf-89f4-02c5567093d1	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
d3b78464-c319-41c9-9203-92d49a5cc371	t	t	admin-cli	0	t	\N	\N	f	\N	f	266e0ee5-a56b-4faf-89f4-02c5567093d1	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
b1017ee6-dea2-4077-8adb-69e681cd685c	t	f	TP2-realm	0	f	\N	\N	t	\N	f	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N	0	f	f	TP2 Realm	f	client-secret	\N	\N	\N	t	f	f	f
75061a78-e9fa-4f5e-b792-aa249d94d9b2	t	f	account	0	t	\N	/realms/TP2/account/	f	\N	f	14468de3-0b67-44ab-a988-6565b42d2e10	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
7f184a64-7758-4108-9017-05ec9db69fc2	t	f	account-console	0	t	\N	/realms/TP2/account/	f	\N	f	14468de3-0b67-44ab-a988-6565b42d2e10	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
67ea9778-a4c3-4152-a9d4-b192aba6c53b	t	t	admin-cli	0	t	\N	\N	f	\N	f	14468de3-0b67-44ab-a988-6565b42d2e10	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
21cea034-65f6-4724-9b50-2d2d0b2165fa	t	f	broker	0	f	\N	\N	t	\N	f	14468de3-0b67-44ab-a988-6565b42d2e10	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
c0474998-cebc-48b9-b387-d72b0cc776db	t	t	quarkuss	0	t	\N		f		f	14468de3-0b67-44ab-a988-6565b42d2e10	openid-connect	-1	t	f		f	client-secret			\N	t	f	t	f
93eef193-1f2c-41ad-97c3-61454ea1c87a	t	f	realm-management	0	f	\N	\N	t	\N	f	14468de3-0b67-44ab-a988-6565b42d2e10	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
6c422063-458c-4c28-a3e7-0c7febd3489d	t	t	security-admin-console	0	t	\N	/admin/TP2/console/	f	\N	f	14468de3-0b67-44ab-a988-6565b42d2e10	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
d0a046e1-427e-4a16-9bf1-8e6da31572bd	post.logout.redirect.uris	+
139e3b65-55d2-41c8-95be-45bb7b554d46	post.logout.redirect.uris	+
139e3b65-55d2-41c8-95be-45bb7b554d46	pkce.code.challenge.method	S256
c5424ef9-8012-4f99-b4ad-e8456f980f8c	post.logout.redirect.uris	+
c5424ef9-8012-4f99-b4ad-e8456f980f8c	pkce.code.challenge.method	S256
c5424ef9-8012-4f99-b4ad-e8456f980f8c	client.use.lightweight.access.token.enabled	true
d3b78464-c319-41c9-9203-92d49a5cc371	client.use.lightweight.access.token.enabled	true
75061a78-e9fa-4f5e-b792-aa249d94d9b2	realm_client	false
75061a78-e9fa-4f5e-b792-aa249d94d9b2	post.logout.redirect.uris	+
7f184a64-7758-4108-9017-05ec9db69fc2	realm_client	false
7f184a64-7758-4108-9017-05ec9db69fc2	post.logout.redirect.uris	+
7f184a64-7758-4108-9017-05ec9db69fc2	pkce.code.challenge.method	S256
67ea9778-a4c3-4152-a9d4-b192aba6c53b	realm_client	false
67ea9778-a4c3-4152-a9d4-b192aba6c53b	client.use.lightweight.access.token.enabled	true
67ea9778-a4c3-4152-a9d4-b192aba6c53b	post.logout.redirect.uris	+
21cea034-65f6-4724-9b50-2d2d0b2165fa	realm_client	true
21cea034-65f6-4724-9b50-2d2d0b2165fa	post.logout.redirect.uris	+
c0474998-cebc-48b9-b387-d72b0cc776db	id.token.as.detached.signature	false
c0474998-cebc-48b9-b387-d72b0cc776db	logout.confirmation.enabled	false
c0474998-cebc-48b9-b387-d72b0cc776db	client.introspection.response.allow.jwt.claim.enabled	false
c0474998-cebc-48b9-b387-d72b0cc776db	oauth2.jwt.authorization.grant.enabled	false
c0474998-cebc-48b9-b387-d72b0cc776db	standard.token.exchange.enabled	false
c0474998-cebc-48b9-b387-d72b0cc776db	frontchannel.logout.session.required	true
c0474998-cebc-48b9-b387-d72b0cc776db	oauth2.device.authorization.grant.enabled	false
c0474998-cebc-48b9-b387-d72b0cc776db	backchannel.logout.revoke.offline.tokens	false
c0474998-cebc-48b9-b387-d72b0cc776db	use.refresh.tokens	true
c0474998-cebc-48b9-b387-d72b0cc776db	realm_client	false
c0474998-cebc-48b9-b387-d72b0cc776db	oidc.ciba.grant.enabled	false
c0474998-cebc-48b9-b387-d72b0cc776db	client.use.lightweight.access.token.enabled	false
c0474998-cebc-48b9-b387-d72b0cc776db	id.token.signed.response.alg	RS256
c0474998-cebc-48b9-b387-d72b0cc776db	backchannel.logout.session.required	true
c0474998-cebc-48b9-b387-d72b0cc776db	client_credentials.use_refresh_token	false
c0474998-cebc-48b9-b387-d72b0cc776db	request.object.required	not required
c0474998-cebc-48b9-b387-d72b0cc776db	access.token.header.type.rfc9068	false
c0474998-cebc-48b9-b387-d72b0cc776db	acr.loa.map	{}
c0474998-cebc-48b9-b387-d72b0cc776db	require.pushed.authorization.requests	false
c0474998-cebc-48b9-b387-d72b0cc776db	tls.client.certificate.bound.access.tokens	false
c0474998-cebc-48b9-b387-d72b0cc776db	display.on.consent.screen	false
c0474998-cebc-48b9-b387-d72b0cc776db	token.response.type.bearer.lower-case	false
c0474998-cebc-48b9-b387-d72b0cc776db	dpop.bound.access.tokens	false
c0474998-cebc-48b9-b387-d72b0cc776db	post.logout.redirect.uris	+
93eef193-1f2c-41ad-97c3-61454ea1c87a	realm_client	true
93eef193-1f2c-41ad-97c3-61454ea1c87a	post.logout.redirect.uris	+
6c422063-458c-4c28-a3e7-0c7febd3489d	realm_client	false
6c422063-458c-4c28-a3e7-0c7febd3489d	client.use.lightweight.access.token.enabled	true
6c422063-458c-4c28-a3e7-0c7febd3489d	post.logout.redirect.uris	+
6c422063-458c-4c28-a3e7-0c7febd3489d	pkce.code.challenge.method	S256
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
cb7039ff-d699-4ac8-8637-77b2014dd78e	offline_access	266e0ee5-a56b-4faf-89f4-02c5567093d1	OpenID Connect built-in scope: offline_access	openid-connect
d18178b4-7c29-41ff-939a-21a4cf302f93	role_list	266e0ee5-a56b-4faf-89f4-02c5567093d1	SAML role list	saml
10bbd390-375f-4a3a-93db-9d70ce8baf60	saml_organization	266e0ee5-a56b-4faf-89f4-02c5567093d1	Organization Membership	saml
efb0d74d-738c-491a-8248-0c775e921e35	profile	266e0ee5-a56b-4faf-89f4-02c5567093d1	OpenID Connect built-in scope: profile	openid-connect
d9f0ec48-a61a-4b8b-af6d-e8c55ef61320	email	266e0ee5-a56b-4faf-89f4-02c5567093d1	OpenID Connect built-in scope: email	openid-connect
182b9b02-e111-4344-b25a-dbc703d8be36	address	266e0ee5-a56b-4faf-89f4-02c5567093d1	OpenID Connect built-in scope: address	openid-connect
4058f2fa-2216-456b-acf6-44ffe1268764	phone	266e0ee5-a56b-4faf-89f4-02c5567093d1	OpenID Connect built-in scope: phone	openid-connect
1f893991-b6b7-4f02-9509-3b8b081629d5	roles	266e0ee5-a56b-4faf-89f4-02c5567093d1	OpenID Connect scope for add user roles to the access token	openid-connect
b862c517-f8ac-42d0-b616-9118946ff2a4	web-origins	266e0ee5-a56b-4faf-89f4-02c5567093d1	OpenID Connect scope for add allowed web origins to the access token	openid-connect
a0873344-f21b-4924-881e-1726af8b7f46	microprofile-jwt	266e0ee5-a56b-4faf-89f4-02c5567093d1	Microprofile - JWT built-in scope	openid-connect
bcf89bf0-2104-44d2-b702-af32316be728	acr	266e0ee5-a56b-4faf-89f4-02c5567093d1	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
d5599a2c-05aa-4e11-a037-c060cb6b415b	basic	266e0ee5-a56b-4faf-89f4-02c5567093d1	OpenID Connect scope for add all basic claims to the token	openid-connect
554d322d-511d-4de6-8f97-d1d0d96b6a7e	service_account	266e0ee5-a56b-4faf-89f4-02c5567093d1	Specific scope for a client enabled for service accounts	openid-connect
bbe47bbc-2a27-4774-ac84-94ff3e296a21	organization	266e0ee5-a56b-4faf-89f4-02c5567093d1	Additional claims about the organization a subject belongs to	openid-connect
e4ddddba-2368-4235-88c7-8817584ee8e3	profile	14468de3-0b67-44ab-a988-6565b42d2e10	OpenID Connect built-in scope: profile	openid-connect
9f382c08-97d9-4676-9133-840e0403ad82	roles	14468de3-0b67-44ab-a988-6565b42d2e10	OpenID Connect scope for add user roles to the access token	openid-connect
8bc3ea3b-b0d9-4320-a683-c603e87dd0b1	basic	14468de3-0b67-44ab-a988-6565b42d2e10	OpenID Connect scope for add all basic claims to the token	openid-connect
20199fd2-a00f-4315-8d28-a9592ae0de58	acr	14468de3-0b67-44ab-a988-6565b42d2e10	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
785411aa-b95a-4da2-b30a-59caed9117d5	microprofile-jwt	14468de3-0b67-44ab-a988-6565b42d2e10	Microprofile - JWT built-in scope	openid-connect
c851ee29-11a9-4a0a-980e-43e6862ab51b	address	14468de3-0b67-44ab-a988-6565b42d2e10	OpenID Connect built-in scope: address	openid-connect
cfcb4050-685e-48ac-859d-fe4699a1fdba	web-origins	14468de3-0b67-44ab-a988-6565b42d2e10	OpenID Connect scope for add allowed web origins to the access token	openid-connect
d71bb4a5-1f58-423d-85ec-c5f364886bf4	email	14468de3-0b67-44ab-a988-6565b42d2e10	OpenID Connect built-in scope: email	openid-connect
a13456b8-6e7e-4360-9e17-912cb932f988	phone	14468de3-0b67-44ab-a988-6565b42d2e10	OpenID Connect built-in scope: phone	openid-connect
c179a1e5-bca1-4219-9415-78dafb575ba9	service_account	14468de3-0b67-44ab-a988-6565b42d2e10	Specific scope for a client enabled for service accounts	openid-connect
1ae35d46-6a5f-439a-ae48-cf86a8195d7f	organization	14468de3-0b67-44ab-a988-6565b42d2e10	Additional claims about the organization a subject belongs to	openid-connect
957b6caf-6a8a-4b30-b9f2-e7254fb91c1c	role_list	14468de3-0b67-44ab-a988-6565b42d2e10	SAML role list	saml
65571631-4197-4b5e-ba18-2cf894a4622d	offline_access	14468de3-0b67-44ab-a988-6565b42d2e10	OpenID Connect built-in scope: offline_access	openid-connect
b1d3ebb9-433d-4c96-b9b2-2d20be61c3bc	saml_organization	14468de3-0b67-44ab-a988-6565b42d2e10	Organization Membership	saml
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
cb7039ff-d699-4ac8-8637-77b2014dd78e	true	display.on.consent.screen
cb7039ff-d699-4ac8-8637-77b2014dd78e	${offlineAccessScopeConsentText}	consent.screen.text
d18178b4-7c29-41ff-939a-21a4cf302f93	true	display.on.consent.screen
d18178b4-7c29-41ff-939a-21a4cf302f93	${samlRoleListScopeConsentText}	consent.screen.text
10bbd390-375f-4a3a-93db-9d70ce8baf60	false	display.on.consent.screen
efb0d74d-738c-491a-8248-0c775e921e35	true	display.on.consent.screen
efb0d74d-738c-491a-8248-0c775e921e35	${profileScopeConsentText}	consent.screen.text
efb0d74d-738c-491a-8248-0c775e921e35	true	include.in.token.scope
d9f0ec48-a61a-4b8b-af6d-e8c55ef61320	true	display.on.consent.screen
d9f0ec48-a61a-4b8b-af6d-e8c55ef61320	${emailScopeConsentText}	consent.screen.text
d9f0ec48-a61a-4b8b-af6d-e8c55ef61320	true	include.in.token.scope
182b9b02-e111-4344-b25a-dbc703d8be36	true	display.on.consent.screen
182b9b02-e111-4344-b25a-dbc703d8be36	${addressScopeConsentText}	consent.screen.text
182b9b02-e111-4344-b25a-dbc703d8be36	true	include.in.token.scope
4058f2fa-2216-456b-acf6-44ffe1268764	true	display.on.consent.screen
4058f2fa-2216-456b-acf6-44ffe1268764	${phoneScopeConsentText}	consent.screen.text
4058f2fa-2216-456b-acf6-44ffe1268764	true	include.in.token.scope
1f893991-b6b7-4f02-9509-3b8b081629d5	true	display.on.consent.screen
1f893991-b6b7-4f02-9509-3b8b081629d5	${rolesScopeConsentText}	consent.screen.text
1f893991-b6b7-4f02-9509-3b8b081629d5	false	include.in.token.scope
b862c517-f8ac-42d0-b616-9118946ff2a4	false	display.on.consent.screen
b862c517-f8ac-42d0-b616-9118946ff2a4		consent.screen.text
b862c517-f8ac-42d0-b616-9118946ff2a4	false	include.in.token.scope
a0873344-f21b-4924-881e-1726af8b7f46	false	display.on.consent.screen
a0873344-f21b-4924-881e-1726af8b7f46	true	include.in.token.scope
bcf89bf0-2104-44d2-b702-af32316be728	false	display.on.consent.screen
bcf89bf0-2104-44d2-b702-af32316be728	false	include.in.token.scope
d5599a2c-05aa-4e11-a037-c060cb6b415b	false	display.on.consent.screen
d5599a2c-05aa-4e11-a037-c060cb6b415b	false	include.in.token.scope
554d322d-511d-4de6-8f97-d1d0d96b6a7e	false	display.on.consent.screen
554d322d-511d-4de6-8f97-d1d0d96b6a7e	false	include.in.token.scope
bbe47bbc-2a27-4774-ac84-94ff3e296a21	true	display.on.consent.screen
bbe47bbc-2a27-4774-ac84-94ff3e296a21	${organizationScopeConsentText}	consent.screen.text
bbe47bbc-2a27-4774-ac84-94ff3e296a21	true	include.in.token.scope
e4ddddba-2368-4235-88c7-8817584ee8e3	true	include.in.token.scope
e4ddddba-2368-4235-88c7-8817584ee8e3	${profileScopeConsentText}	consent.screen.text
e4ddddba-2368-4235-88c7-8817584ee8e3	true	display.on.consent.screen
9f382c08-97d9-4676-9133-840e0403ad82	false	include.in.token.scope
9f382c08-97d9-4676-9133-840e0403ad82	${rolesScopeConsentText}	consent.screen.text
9f382c08-97d9-4676-9133-840e0403ad82	true	display.on.consent.screen
8bc3ea3b-b0d9-4320-a683-c603e87dd0b1	false	include.in.token.scope
8bc3ea3b-b0d9-4320-a683-c603e87dd0b1	false	display.on.consent.screen
20199fd2-a00f-4315-8d28-a9592ae0de58	false	include.in.token.scope
20199fd2-a00f-4315-8d28-a9592ae0de58	false	display.on.consent.screen
785411aa-b95a-4da2-b30a-59caed9117d5	true	include.in.token.scope
785411aa-b95a-4da2-b30a-59caed9117d5	false	display.on.consent.screen
c851ee29-11a9-4a0a-980e-43e6862ab51b	true	include.in.token.scope
c851ee29-11a9-4a0a-980e-43e6862ab51b	${addressScopeConsentText}	consent.screen.text
c851ee29-11a9-4a0a-980e-43e6862ab51b	true	display.on.consent.screen
cfcb4050-685e-48ac-859d-fe4699a1fdba	false	include.in.token.scope
cfcb4050-685e-48ac-859d-fe4699a1fdba		consent.screen.text
cfcb4050-685e-48ac-859d-fe4699a1fdba	false	display.on.consent.screen
d71bb4a5-1f58-423d-85ec-c5f364886bf4	true	include.in.token.scope
d71bb4a5-1f58-423d-85ec-c5f364886bf4	${emailScopeConsentText}	consent.screen.text
d71bb4a5-1f58-423d-85ec-c5f364886bf4	true	display.on.consent.screen
a13456b8-6e7e-4360-9e17-912cb932f988	true	include.in.token.scope
a13456b8-6e7e-4360-9e17-912cb932f988	${phoneScopeConsentText}	consent.screen.text
a13456b8-6e7e-4360-9e17-912cb932f988	true	display.on.consent.screen
c179a1e5-bca1-4219-9415-78dafb575ba9	false	include.in.token.scope
c179a1e5-bca1-4219-9415-78dafb575ba9	false	display.on.consent.screen
1ae35d46-6a5f-439a-ae48-cf86a8195d7f	true	include.in.token.scope
1ae35d46-6a5f-439a-ae48-cf86a8195d7f	${organizationScopeConsentText}	consent.screen.text
1ae35d46-6a5f-439a-ae48-cf86a8195d7f	true	display.on.consent.screen
957b6caf-6a8a-4b30-b9f2-e7254fb91c1c	${samlRoleListScopeConsentText}	consent.screen.text
957b6caf-6a8a-4b30-b9f2-e7254fb91c1c	true	display.on.consent.screen
65571631-4197-4b5e-ba18-2cf894a4622d	${offlineAccessScopeConsentText}	consent.screen.text
65571631-4197-4b5e-ba18-2cf894a4622d	true	display.on.consent.screen
b1d3ebb9-433d-4c96-b9b2-2d20be61c3bc	false	display.on.consent.screen
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
d0a046e1-427e-4a16-9bf1-8e6da31572bd	b862c517-f8ac-42d0-b616-9118946ff2a4	t
d0a046e1-427e-4a16-9bf1-8e6da31572bd	bcf89bf0-2104-44d2-b702-af32316be728	t
d0a046e1-427e-4a16-9bf1-8e6da31572bd	d9f0ec48-a61a-4b8b-af6d-e8c55ef61320	t
d0a046e1-427e-4a16-9bf1-8e6da31572bd	d5599a2c-05aa-4e11-a037-c060cb6b415b	t
d0a046e1-427e-4a16-9bf1-8e6da31572bd	1f893991-b6b7-4f02-9509-3b8b081629d5	t
d0a046e1-427e-4a16-9bf1-8e6da31572bd	efb0d74d-738c-491a-8248-0c775e921e35	t
d0a046e1-427e-4a16-9bf1-8e6da31572bd	182b9b02-e111-4344-b25a-dbc703d8be36	f
d0a046e1-427e-4a16-9bf1-8e6da31572bd	4058f2fa-2216-456b-acf6-44ffe1268764	f
d0a046e1-427e-4a16-9bf1-8e6da31572bd	cb7039ff-d699-4ac8-8637-77b2014dd78e	f
d0a046e1-427e-4a16-9bf1-8e6da31572bd	bbe47bbc-2a27-4774-ac84-94ff3e296a21	f
d0a046e1-427e-4a16-9bf1-8e6da31572bd	a0873344-f21b-4924-881e-1726af8b7f46	f
139e3b65-55d2-41c8-95be-45bb7b554d46	b862c517-f8ac-42d0-b616-9118946ff2a4	t
139e3b65-55d2-41c8-95be-45bb7b554d46	bcf89bf0-2104-44d2-b702-af32316be728	t
139e3b65-55d2-41c8-95be-45bb7b554d46	d9f0ec48-a61a-4b8b-af6d-e8c55ef61320	t
139e3b65-55d2-41c8-95be-45bb7b554d46	d5599a2c-05aa-4e11-a037-c060cb6b415b	t
139e3b65-55d2-41c8-95be-45bb7b554d46	1f893991-b6b7-4f02-9509-3b8b081629d5	t
139e3b65-55d2-41c8-95be-45bb7b554d46	efb0d74d-738c-491a-8248-0c775e921e35	t
139e3b65-55d2-41c8-95be-45bb7b554d46	182b9b02-e111-4344-b25a-dbc703d8be36	f
139e3b65-55d2-41c8-95be-45bb7b554d46	4058f2fa-2216-456b-acf6-44ffe1268764	f
139e3b65-55d2-41c8-95be-45bb7b554d46	cb7039ff-d699-4ac8-8637-77b2014dd78e	f
139e3b65-55d2-41c8-95be-45bb7b554d46	bbe47bbc-2a27-4774-ac84-94ff3e296a21	f
139e3b65-55d2-41c8-95be-45bb7b554d46	a0873344-f21b-4924-881e-1726af8b7f46	f
d3b78464-c319-41c9-9203-92d49a5cc371	b862c517-f8ac-42d0-b616-9118946ff2a4	t
d3b78464-c319-41c9-9203-92d49a5cc371	bcf89bf0-2104-44d2-b702-af32316be728	t
d3b78464-c319-41c9-9203-92d49a5cc371	d9f0ec48-a61a-4b8b-af6d-e8c55ef61320	t
d3b78464-c319-41c9-9203-92d49a5cc371	d5599a2c-05aa-4e11-a037-c060cb6b415b	t
d3b78464-c319-41c9-9203-92d49a5cc371	1f893991-b6b7-4f02-9509-3b8b081629d5	t
d3b78464-c319-41c9-9203-92d49a5cc371	efb0d74d-738c-491a-8248-0c775e921e35	t
d3b78464-c319-41c9-9203-92d49a5cc371	182b9b02-e111-4344-b25a-dbc703d8be36	f
d3b78464-c319-41c9-9203-92d49a5cc371	4058f2fa-2216-456b-acf6-44ffe1268764	f
d3b78464-c319-41c9-9203-92d49a5cc371	cb7039ff-d699-4ac8-8637-77b2014dd78e	f
d3b78464-c319-41c9-9203-92d49a5cc371	bbe47bbc-2a27-4774-ac84-94ff3e296a21	f
d3b78464-c319-41c9-9203-92d49a5cc371	a0873344-f21b-4924-881e-1726af8b7f46	f
70b0ab56-1c02-4185-9288-7ea85b30e65b	b862c517-f8ac-42d0-b616-9118946ff2a4	t
70b0ab56-1c02-4185-9288-7ea85b30e65b	bcf89bf0-2104-44d2-b702-af32316be728	t
70b0ab56-1c02-4185-9288-7ea85b30e65b	d9f0ec48-a61a-4b8b-af6d-e8c55ef61320	t
70b0ab56-1c02-4185-9288-7ea85b30e65b	d5599a2c-05aa-4e11-a037-c060cb6b415b	t
70b0ab56-1c02-4185-9288-7ea85b30e65b	1f893991-b6b7-4f02-9509-3b8b081629d5	t
70b0ab56-1c02-4185-9288-7ea85b30e65b	efb0d74d-738c-491a-8248-0c775e921e35	t
70b0ab56-1c02-4185-9288-7ea85b30e65b	182b9b02-e111-4344-b25a-dbc703d8be36	f
70b0ab56-1c02-4185-9288-7ea85b30e65b	4058f2fa-2216-456b-acf6-44ffe1268764	f
70b0ab56-1c02-4185-9288-7ea85b30e65b	cb7039ff-d699-4ac8-8637-77b2014dd78e	f
70b0ab56-1c02-4185-9288-7ea85b30e65b	bbe47bbc-2a27-4774-ac84-94ff3e296a21	f
70b0ab56-1c02-4185-9288-7ea85b30e65b	a0873344-f21b-4924-881e-1726af8b7f46	f
fe1a2e3c-5060-4662-a935-5d5655e3ac08	b862c517-f8ac-42d0-b616-9118946ff2a4	t
fe1a2e3c-5060-4662-a935-5d5655e3ac08	bcf89bf0-2104-44d2-b702-af32316be728	t
fe1a2e3c-5060-4662-a935-5d5655e3ac08	d9f0ec48-a61a-4b8b-af6d-e8c55ef61320	t
fe1a2e3c-5060-4662-a935-5d5655e3ac08	d5599a2c-05aa-4e11-a037-c060cb6b415b	t
fe1a2e3c-5060-4662-a935-5d5655e3ac08	1f893991-b6b7-4f02-9509-3b8b081629d5	t
fe1a2e3c-5060-4662-a935-5d5655e3ac08	efb0d74d-738c-491a-8248-0c775e921e35	t
fe1a2e3c-5060-4662-a935-5d5655e3ac08	182b9b02-e111-4344-b25a-dbc703d8be36	f
fe1a2e3c-5060-4662-a935-5d5655e3ac08	4058f2fa-2216-456b-acf6-44ffe1268764	f
fe1a2e3c-5060-4662-a935-5d5655e3ac08	cb7039ff-d699-4ac8-8637-77b2014dd78e	f
fe1a2e3c-5060-4662-a935-5d5655e3ac08	bbe47bbc-2a27-4774-ac84-94ff3e296a21	f
fe1a2e3c-5060-4662-a935-5d5655e3ac08	a0873344-f21b-4924-881e-1726af8b7f46	f
c5424ef9-8012-4f99-b4ad-e8456f980f8c	b862c517-f8ac-42d0-b616-9118946ff2a4	t
c5424ef9-8012-4f99-b4ad-e8456f980f8c	bcf89bf0-2104-44d2-b702-af32316be728	t
c5424ef9-8012-4f99-b4ad-e8456f980f8c	d9f0ec48-a61a-4b8b-af6d-e8c55ef61320	t
c5424ef9-8012-4f99-b4ad-e8456f980f8c	d5599a2c-05aa-4e11-a037-c060cb6b415b	t
c5424ef9-8012-4f99-b4ad-e8456f980f8c	1f893991-b6b7-4f02-9509-3b8b081629d5	t
c5424ef9-8012-4f99-b4ad-e8456f980f8c	efb0d74d-738c-491a-8248-0c775e921e35	t
c5424ef9-8012-4f99-b4ad-e8456f980f8c	182b9b02-e111-4344-b25a-dbc703d8be36	f
c5424ef9-8012-4f99-b4ad-e8456f980f8c	4058f2fa-2216-456b-acf6-44ffe1268764	f
c5424ef9-8012-4f99-b4ad-e8456f980f8c	cb7039ff-d699-4ac8-8637-77b2014dd78e	f
c5424ef9-8012-4f99-b4ad-e8456f980f8c	bbe47bbc-2a27-4774-ac84-94ff3e296a21	f
c5424ef9-8012-4f99-b4ad-e8456f980f8c	a0873344-f21b-4924-881e-1726af8b7f46	f
75061a78-e9fa-4f5e-b792-aa249d94d9b2	e4ddddba-2368-4235-88c7-8817584ee8e3	t
75061a78-e9fa-4f5e-b792-aa249d94d9b2	9f382c08-97d9-4676-9133-840e0403ad82	t
75061a78-e9fa-4f5e-b792-aa249d94d9b2	8bc3ea3b-b0d9-4320-a683-c603e87dd0b1	t
75061a78-e9fa-4f5e-b792-aa249d94d9b2	20199fd2-a00f-4315-8d28-a9592ae0de58	t
75061a78-e9fa-4f5e-b792-aa249d94d9b2	cfcb4050-685e-48ac-859d-fe4699a1fdba	t
75061a78-e9fa-4f5e-b792-aa249d94d9b2	d71bb4a5-1f58-423d-85ec-c5f364886bf4	t
75061a78-e9fa-4f5e-b792-aa249d94d9b2	785411aa-b95a-4da2-b30a-59caed9117d5	f
75061a78-e9fa-4f5e-b792-aa249d94d9b2	65571631-4197-4b5e-ba18-2cf894a4622d	f
75061a78-e9fa-4f5e-b792-aa249d94d9b2	c851ee29-11a9-4a0a-980e-43e6862ab51b	f
75061a78-e9fa-4f5e-b792-aa249d94d9b2	a13456b8-6e7e-4360-9e17-912cb932f988	f
75061a78-e9fa-4f5e-b792-aa249d94d9b2	1ae35d46-6a5f-439a-ae48-cf86a8195d7f	f
7f184a64-7758-4108-9017-05ec9db69fc2	e4ddddba-2368-4235-88c7-8817584ee8e3	t
7f184a64-7758-4108-9017-05ec9db69fc2	9f382c08-97d9-4676-9133-840e0403ad82	t
7f184a64-7758-4108-9017-05ec9db69fc2	8bc3ea3b-b0d9-4320-a683-c603e87dd0b1	t
7f184a64-7758-4108-9017-05ec9db69fc2	20199fd2-a00f-4315-8d28-a9592ae0de58	t
7f184a64-7758-4108-9017-05ec9db69fc2	cfcb4050-685e-48ac-859d-fe4699a1fdba	t
7f184a64-7758-4108-9017-05ec9db69fc2	d71bb4a5-1f58-423d-85ec-c5f364886bf4	t
7f184a64-7758-4108-9017-05ec9db69fc2	785411aa-b95a-4da2-b30a-59caed9117d5	f
7f184a64-7758-4108-9017-05ec9db69fc2	65571631-4197-4b5e-ba18-2cf894a4622d	f
7f184a64-7758-4108-9017-05ec9db69fc2	c851ee29-11a9-4a0a-980e-43e6862ab51b	f
7f184a64-7758-4108-9017-05ec9db69fc2	a13456b8-6e7e-4360-9e17-912cb932f988	f
7f184a64-7758-4108-9017-05ec9db69fc2	1ae35d46-6a5f-439a-ae48-cf86a8195d7f	f
67ea9778-a4c3-4152-a9d4-b192aba6c53b	e4ddddba-2368-4235-88c7-8817584ee8e3	t
67ea9778-a4c3-4152-a9d4-b192aba6c53b	9f382c08-97d9-4676-9133-840e0403ad82	t
67ea9778-a4c3-4152-a9d4-b192aba6c53b	8bc3ea3b-b0d9-4320-a683-c603e87dd0b1	t
67ea9778-a4c3-4152-a9d4-b192aba6c53b	20199fd2-a00f-4315-8d28-a9592ae0de58	t
67ea9778-a4c3-4152-a9d4-b192aba6c53b	cfcb4050-685e-48ac-859d-fe4699a1fdba	t
67ea9778-a4c3-4152-a9d4-b192aba6c53b	d71bb4a5-1f58-423d-85ec-c5f364886bf4	t
67ea9778-a4c3-4152-a9d4-b192aba6c53b	785411aa-b95a-4da2-b30a-59caed9117d5	f
67ea9778-a4c3-4152-a9d4-b192aba6c53b	65571631-4197-4b5e-ba18-2cf894a4622d	f
67ea9778-a4c3-4152-a9d4-b192aba6c53b	c851ee29-11a9-4a0a-980e-43e6862ab51b	f
67ea9778-a4c3-4152-a9d4-b192aba6c53b	a13456b8-6e7e-4360-9e17-912cb932f988	f
67ea9778-a4c3-4152-a9d4-b192aba6c53b	1ae35d46-6a5f-439a-ae48-cf86a8195d7f	f
21cea034-65f6-4724-9b50-2d2d0b2165fa	e4ddddba-2368-4235-88c7-8817584ee8e3	t
21cea034-65f6-4724-9b50-2d2d0b2165fa	9f382c08-97d9-4676-9133-840e0403ad82	t
21cea034-65f6-4724-9b50-2d2d0b2165fa	8bc3ea3b-b0d9-4320-a683-c603e87dd0b1	t
21cea034-65f6-4724-9b50-2d2d0b2165fa	20199fd2-a00f-4315-8d28-a9592ae0de58	t
21cea034-65f6-4724-9b50-2d2d0b2165fa	cfcb4050-685e-48ac-859d-fe4699a1fdba	t
21cea034-65f6-4724-9b50-2d2d0b2165fa	d71bb4a5-1f58-423d-85ec-c5f364886bf4	t
21cea034-65f6-4724-9b50-2d2d0b2165fa	785411aa-b95a-4da2-b30a-59caed9117d5	f
21cea034-65f6-4724-9b50-2d2d0b2165fa	65571631-4197-4b5e-ba18-2cf894a4622d	f
21cea034-65f6-4724-9b50-2d2d0b2165fa	c851ee29-11a9-4a0a-980e-43e6862ab51b	f
21cea034-65f6-4724-9b50-2d2d0b2165fa	a13456b8-6e7e-4360-9e17-912cb932f988	f
21cea034-65f6-4724-9b50-2d2d0b2165fa	1ae35d46-6a5f-439a-ae48-cf86a8195d7f	f
c0474998-cebc-48b9-b387-d72b0cc776db	e4ddddba-2368-4235-88c7-8817584ee8e3	t
c0474998-cebc-48b9-b387-d72b0cc776db	9f382c08-97d9-4676-9133-840e0403ad82	t
c0474998-cebc-48b9-b387-d72b0cc776db	8bc3ea3b-b0d9-4320-a683-c603e87dd0b1	t
c0474998-cebc-48b9-b387-d72b0cc776db	20199fd2-a00f-4315-8d28-a9592ae0de58	t
c0474998-cebc-48b9-b387-d72b0cc776db	cfcb4050-685e-48ac-859d-fe4699a1fdba	t
c0474998-cebc-48b9-b387-d72b0cc776db	d71bb4a5-1f58-423d-85ec-c5f364886bf4	t
c0474998-cebc-48b9-b387-d72b0cc776db	785411aa-b95a-4da2-b30a-59caed9117d5	f
c0474998-cebc-48b9-b387-d72b0cc776db	65571631-4197-4b5e-ba18-2cf894a4622d	f
c0474998-cebc-48b9-b387-d72b0cc776db	c851ee29-11a9-4a0a-980e-43e6862ab51b	f
c0474998-cebc-48b9-b387-d72b0cc776db	a13456b8-6e7e-4360-9e17-912cb932f988	f
c0474998-cebc-48b9-b387-d72b0cc776db	1ae35d46-6a5f-439a-ae48-cf86a8195d7f	f
93eef193-1f2c-41ad-97c3-61454ea1c87a	e4ddddba-2368-4235-88c7-8817584ee8e3	t
93eef193-1f2c-41ad-97c3-61454ea1c87a	9f382c08-97d9-4676-9133-840e0403ad82	t
93eef193-1f2c-41ad-97c3-61454ea1c87a	8bc3ea3b-b0d9-4320-a683-c603e87dd0b1	t
93eef193-1f2c-41ad-97c3-61454ea1c87a	20199fd2-a00f-4315-8d28-a9592ae0de58	t
93eef193-1f2c-41ad-97c3-61454ea1c87a	cfcb4050-685e-48ac-859d-fe4699a1fdba	t
93eef193-1f2c-41ad-97c3-61454ea1c87a	d71bb4a5-1f58-423d-85ec-c5f364886bf4	t
93eef193-1f2c-41ad-97c3-61454ea1c87a	785411aa-b95a-4da2-b30a-59caed9117d5	f
93eef193-1f2c-41ad-97c3-61454ea1c87a	65571631-4197-4b5e-ba18-2cf894a4622d	f
93eef193-1f2c-41ad-97c3-61454ea1c87a	c851ee29-11a9-4a0a-980e-43e6862ab51b	f
93eef193-1f2c-41ad-97c3-61454ea1c87a	a13456b8-6e7e-4360-9e17-912cb932f988	f
93eef193-1f2c-41ad-97c3-61454ea1c87a	1ae35d46-6a5f-439a-ae48-cf86a8195d7f	f
6c422063-458c-4c28-a3e7-0c7febd3489d	e4ddddba-2368-4235-88c7-8817584ee8e3	t
6c422063-458c-4c28-a3e7-0c7febd3489d	9f382c08-97d9-4676-9133-840e0403ad82	t
6c422063-458c-4c28-a3e7-0c7febd3489d	8bc3ea3b-b0d9-4320-a683-c603e87dd0b1	t
6c422063-458c-4c28-a3e7-0c7febd3489d	20199fd2-a00f-4315-8d28-a9592ae0de58	t
6c422063-458c-4c28-a3e7-0c7febd3489d	cfcb4050-685e-48ac-859d-fe4699a1fdba	t
6c422063-458c-4c28-a3e7-0c7febd3489d	d71bb4a5-1f58-423d-85ec-c5f364886bf4	t
6c422063-458c-4c28-a3e7-0c7febd3489d	785411aa-b95a-4da2-b30a-59caed9117d5	f
6c422063-458c-4c28-a3e7-0c7febd3489d	65571631-4197-4b5e-ba18-2cf894a4622d	f
6c422063-458c-4c28-a3e7-0c7febd3489d	c851ee29-11a9-4a0a-980e-43e6862ab51b	f
6c422063-458c-4c28-a3e7-0c7febd3489d	a13456b8-6e7e-4360-9e17-912cb932f988	f
6c422063-458c-4c28-a3e7-0c7febd3489d	1ae35d46-6a5f-439a-ae48-cf86a8195d7f	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
cb7039ff-d699-4ac8-8637-77b2014dd78e	1c5c520a-20bd-4b6b-88d6-82d301c9dd42
65571631-4197-4b5e-ba18-2cf894a4622d	4fee6c90-ed20-4009-be67-b4ef7aa89c76
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
51fbebd8-4f77-4efb-bbd9-f3d923999889	Trusted Hosts	266e0ee5-a56b-4faf-89f4-02c5567093d1	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	266e0ee5-a56b-4faf-89f4-02c5567093d1	anonymous
18417c61-be1e-45ab-98dd-240974c93c1b	Consent Required	266e0ee5-a56b-4faf-89f4-02c5567093d1	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	266e0ee5-a56b-4faf-89f4-02c5567093d1	anonymous
8b68f107-62ce-4de3-b033-ce24b5c6b72f	Full Scope Disabled	266e0ee5-a56b-4faf-89f4-02c5567093d1	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	266e0ee5-a56b-4faf-89f4-02c5567093d1	anonymous
be498bf9-d357-4db0-bfcf-414774b3bff2	Max Clients Limit	266e0ee5-a56b-4faf-89f4-02c5567093d1	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	266e0ee5-a56b-4faf-89f4-02c5567093d1	anonymous
040cd595-f407-413a-acf3-4a34f4e20141	Allowed Protocol Mapper Types	266e0ee5-a56b-4faf-89f4-02c5567093d1	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	266e0ee5-a56b-4faf-89f4-02c5567093d1	anonymous
b409a5be-ce88-4c5d-9c9f-5480acddecad	Allowed Client Scopes	266e0ee5-a56b-4faf-89f4-02c5567093d1	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	266e0ee5-a56b-4faf-89f4-02c5567093d1	anonymous
2022f6bf-0508-46a5-9052-97cfad792f2b	Allowed Registration Web Origins	266e0ee5-a56b-4faf-89f4-02c5567093d1	registration-web-origins	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	266e0ee5-a56b-4faf-89f4-02c5567093d1	anonymous
1f6725e1-567c-4a40-baca-595648218bde	Allowed Protocol Mapper Types	266e0ee5-a56b-4faf-89f4-02c5567093d1	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	266e0ee5-a56b-4faf-89f4-02c5567093d1	authenticated
6e22b1ca-9dd4-4c00-b0bd-7867596584f4	Allowed Client Scopes	266e0ee5-a56b-4faf-89f4-02c5567093d1	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	266e0ee5-a56b-4faf-89f4-02c5567093d1	authenticated
1545c1f6-74ef-48fc-8893-eee3ca4dff1b	Allowed Registration Web Origins	266e0ee5-a56b-4faf-89f4-02c5567093d1	registration-web-origins	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	266e0ee5-a56b-4faf-89f4-02c5567093d1	authenticated
c686b2ef-f2b8-495b-a724-7afb8e4e4b56	rsa-generated	266e0ee5-a56b-4faf-89f4-02c5567093d1	rsa-generated	org.keycloak.keys.KeyProvider	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N
5b5df947-d340-4ad2-b27b-4c83b45cc065	rsa-enc-generated	266e0ee5-a56b-4faf-89f4-02c5567093d1	rsa-enc-generated	org.keycloak.keys.KeyProvider	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N
e70bc8a2-95e2-4cb5-a3b3-b97c05d949f8	hmac-generated-hs512	266e0ee5-a56b-4faf-89f4-02c5567093d1	hmac-generated	org.keycloak.keys.KeyProvider	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N
698613cb-6f1f-416e-81e0-36299f6e4459	aes-generated	266e0ee5-a56b-4faf-89f4-02c5567093d1	aes-generated	org.keycloak.keys.KeyProvider	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N
8dd27e3e-a481-4049-a486-ff85b85763b8	\N	266e0ee5-a56b-4faf-89f4-02c5567093d1	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N
59a57ec8-769f-49ac-a46b-b983a799f9a1	Allowed Registration Web Origins	14468de3-0b67-44ab-a988-6565b42d2e10	registration-web-origins	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	14468de3-0b67-44ab-a988-6565b42d2e10	authenticated
1ad60cc9-f1a7-4d6c-8d35-4ae540b46b0f	Trusted Hosts	14468de3-0b67-44ab-a988-6565b42d2e10	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	14468de3-0b67-44ab-a988-6565b42d2e10	anonymous
f0844c0f-83db-4cfc-abe5-8044d33f5d7e	Allowed Client Scopes	14468de3-0b67-44ab-a988-6565b42d2e10	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	14468de3-0b67-44ab-a988-6565b42d2e10	anonymous
a72c26d7-9ec5-444c-8c86-1ee271ca4f57	Allowed Protocol Mapper Types	14468de3-0b67-44ab-a988-6565b42d2e10	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	14468de3-0b67-44ab-a988-6565b42d2e10	authenticated
20b12ed1-0085-471a-85d2-fd5025d3a0d2	Full Scope Disabled	14468de3-0b67-44ab-a988-6565b42d2e10	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	14468de3-0b67-44ab-a988-6565b42d2e10	anonymous
a07e7b5f-1ef4-4f33-b11d-a95a0d7bfc38	Max Clients Limit	14468de3-0b67-44ab-a988-6565b42d2e10	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	14468de3-0b67-44ab-a988-6565b42d2e10	anonymous
4e022e77-89bc-4023-b5ed-559e2e164593	Consent Required	14468de3-0b67-44ab-a988-6565b42d2e10	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	14468de3-0b67-44ab-a988-6565b42d2e10	anonymous
900d92a9-36ea-4ae9-9d95-45bb0b146a29	Allowed Client Scopes	14468de3-0b67-44ab-a988-6565b42d2e10	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	14468de3-0b67-44ab-a988-6565b42d2e10	authenticated
5867bd1b-0a75-444a-b0c0-728242c8de9a	Allowed Protocol Mapper Types	14468de3-0b67-44ab-a988-6565b42d2e10	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	14468de3-0b67-44ab-a988-6565b42d2e10	anonymous
61795d87-d54b-4c81-b771-843d7e18f655	Allowed Registration Web Origins	14468de3-0b67-44ab-a988-6565b42d2e10	registration-web-origins	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	14468de3-0b67-44ab-a988-6565b42d2e10	anonymous
46426640-58b6-4b8f-b2d0-dc7fb459aad5	\N	14468de3-0b67-44ab-a988-6565b42d2e10	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	14468de3-0b67-44ab-a988-6565b42d2e10	\N
b048d838-9fe5-4e1b-b59d-e6547d4f5b23	rsa-generated	14468de3-0b67-44ab-a988-6565b42d2e10	rsa-generated	org.keycloak.keys.KeyProvider	14468de3-0b67-44ab-a988-6565b42d2e10	\N
6f95231c-4970-4f7b-8485-cf80485fa6c4	rsa-enc-generated	14468de3-0b67-44ab-a988-6565b42d2e10	rsa-enc-generated	org.keycloak.keys.KeyProvider	14468de3-0b67-44ab-a988-6565b42d2e10	\N
33296dbc-85b1-4a74-b206-ce8600cfae0d	hmac-generated-hs512	14468de3-0b67-44ab-a988-6565b42d2e10	hmac-generated	org.keycloak.keys.KeyProvider	14468de3-0b67-44ab-a988-6565b42d2e10	\N
ee257445-c7d4-4c9a-b976-4a1293e450f2	aes-generated	14468de3-0b67-44ab-a988-6565b42d2e10	aes-generated	org.keycloak.keys.KeyProvider	14468de3-0b67-44ab-a988-6565b42d2e10	\N
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
27a56d8b-fc36-40dc-9f74-5fbc8b89e743	be498bf9-d357-4db0-bfcf-414774b3bff2	max-clients	200
4c9c830b-4090-4e0b-836d-f64725fee377	040cd595-f407-413a-acf3-4a34f4e20141	allowed-protocol-mapper-types	saml-role-list-mapper
2840844b-56ae-4c38-b451-de1b414fb1eb	040cd595-f407-413a-acf3-4a34f4e20141	allowed-protocol-mapper-types	saml-user-property-mapper
88d1db8c-9b79-4997-9a21-8becab395bed	040cd595-f407-413a-acf3-4a34f4e20141	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
f8636f9a-3320-4a8b-b89c-1e2d198794f1	040cd595-f407-413a-acf3-4a34f4e20141	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
2a6fe1bb-a684-4256-93b3-2ff3ba3796ad	040cd595-f407-413a-acf3-4a34f4e20141	allowed-protocol-mapper-types	saml-user-attribute-mapper
b2265aaa-e781-434b-abe2-6b55f8b1f458	040cd595-f407-413a-acf3-4a34f4e20141	allowed-protocol-mapper-types	oidc-full-name-mapper
cb4ee7a1-aeb3-4df6-b310-8aa96fe31b24	040cd595-f407-413a-acf3-4a34f4e20141	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
12ef6e8d-6936-4b26-86f3-5c6e043d5e7b	040cd595-f407-413a-acf3-4a34f4e20141	allowed-protocol-mapper-types	oidc-address-mapper
0bdb628c-c093-400f-a4b7-47f8cdf9ce98	b409a5be-ce88-4c5d-9c9f-5480acddecad	allow-default-scopes	true
1df2b5dc-d9d4-4973-9f02-edaf682cba10	51fbebd8-4f77-4efb-bbd9-f3d923999889	client-uris-must-match	true
6bd9aa9b-66c9-4b42-93dd-bc1e99bbb7a8	51fbebd8-4f77-4efb-bbd9-f3d923999889	host-sending-registration-request-must-match	true
8eca39a1-1ae0-46cb-af30-551a47cb4b4c	6e22b1ca-9dd4-4c00-b0bd-7867596584f4	allow-default-scopes	true
a345c108-c617-4f48-917b-138bf45d985f	1f6725e1-567c-4a40-baca-595648218bde	allowed-protocol-mapper-types	saml-user-attribute-mapper
914f950e-7927-42ad-b06b-bfffb2bf0b8f	1f6725e1-567c-4a40-baca-595648218bde	allowed-protocol-mapper-types	saml-role-list-mapper
93fdbcf6-8479-40e2-ba7f-ba4764c2c98b	1f6725e1-567c-4a40-baca-595648218bde	allowed-protocol-mapper-types	oidc-full-name-mapper
34ae866a-e231-44bc-96c3-f37b7d403836	1f6725e1-567c-4a40-baca-595648218bde	allowed-protocol-mapper-types	saml-user-property-mapper
864f7e51-f627-42c0-9208-55ec16868d0f	1f6725e1-567c-4a40-baca-595648218bde	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
5fe101a1-1b81-434a-899d-29ff92c327a3	1f6725e1-567c-4a40-baca-595648218bde	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
521bd4b0-0928-4999-bbf5-4999f32a1848	1f6725e1-567c-4a40-baca-595648218bde	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
3c6cbd8a-0ef2-47c7-b603-d4c82cad7b36	1f6725e1-567c-4a40-baca-595648218bde	allowed-protocol-mapper-types	oidc-address-mapper
b65304b1-1b2d-4506-b107-6de49ae61abc	c686b2ef-f2b8-495b-a724-7afb8e4e4b56	privateKey	MIIEowIBAAKCAQEAuBeTCjUSEfvMJRHU8wmY1WGoIIwq8fQUuwSdKeU/oOf2wIb2o+nBmoJtAmgaRHptaorK0diSKI4llLxzm0KMhQffEF/AsVJ1tUSlOfKAIyq56LhUS+FZeJyrOmvp73q83ZxXaL+cMDXsWQaH5a4nPm8q/avOJcfkRuxVPBbWVA/rhhRo50c8DKzNU5EK7ktFCC4OwC6TY2x++bwQ6hxDQR7wddRCZeVWIy1P2Vb0ZWmeA39js84YEz1jW0yiInHSODvhLQPnu2wonqox/WOZydED9b7HQEDjsq8s1lPnTJGQ6LfIvFNUd0AwHuPtkVy6x5OVVSIKo/3QGChof7OaPwIDAQABAoIBAEOidaVUZjUxO4mLCZ/ZMMuEu45psQV/1XX4df2EemIVlzSY4VjLcxPfQ0mVEcGC8Vwpbea3GMvJnckNi7PJOXNOtwd/Bn6fexuEAuhNTgKdmfwEbQQL4SFM/iPSrfoMMAODgyG69BlKVnFG0vrxhv2LPlJAotaCoD3malJPWaM8Lai84xd4vxnhTKB5bItlqG4zivQgNo4xbADsVCFcY1CuFzMBbLHj0w08D0e8OUONjxdXfu/ngqx/BZDlBiWj1bADP4mQt26qK76MeLIiij0FSNFEchVql5eTwb5wAwWwU/yf/p4xARQvx35x0eoHT5xjF6TFoMSRfAekvsYODIECgYEA8fndjkMpzGCMlgFkI/OIRoO+9AZ9QIcvObuQC88zPl/cj7UvXfMnB/ZEGCcRS9fSOHoHcVnlK6+XVaNZMoFCWNDMrpDBZpPkfWu7tX4bHXPHntKUJQOt+3Q+OzgrruSCJXGBJaST7/+E+9iEAerKWNjTXihBK+04nh2bKU4H+F8CgYEAwsLmac8tQC7E3A6upU6P1ZXOodzvtKZw61ASqWrF7QgHwPYjZXygL2qF3ZofCC5BT+xG83ErDIpqpAPWL8mQ/8Y4Z5IoFW+56WkRaQNBzgRCct5BzCDsVXSF5XPde3oe1v0dTFUvGecVOBQtWbHULYpwpPw2W2e/78Vs67kzKiECgYEAw6C2tmUmTc1g24WUaFxjOF8a6j601I52Z75z3phNXYgy0Rwyh0olrBI1SzGKkj6R/obprYJ3/LGhL+M4IdTOxu9IC3mMYln+yEdpInopgc4w/P5SNvqalkiMZ2QqLOMhNRRmzQAZelaiNNn/H22q2dmySNVSmyjWNT7KSsKDPxECgYBS6yOqHLiJQOAzSFT2sDHwny0wIJ41bT9aD+dCFeFafza94o1DYgHY7iM8K6fWlcrcuh2i+6V2W1/3oGKKSejf3IabIdDK/5xJUaBF80sK6SlZOmMNA19bKpbvD5tWPLHwmiblHsdE4etYys5cB6fsE6rNs0t5Mvy2mnk7CshLwQKBgERb+Hhf7cqJ6D6en8nsER2YD2zF1HVBS2q0PZpOUdplfGdmu5YaWWybQpYRje3P71CEOgUwghHze+wRsDOkIKdhwyjY5zxmOmgowRwYkCbuQk9cU0A+FhyowWBYVXWiL/LLVJtbQnrznNjgxGlulJ/s8+jxDLj3Izlsl2EInvgd
180180a8-0118-44ab-a20a-599e870ae92a	c686b2ef-f2b8-495b-a724-7afb8e4e4b56	certificate	MIICmzCCAYMCBgGeMM07ODANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjYwNTE2MTIzODM2WhcNMzYwNTE2MTI0MDE2WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC4F5MKNRIR+8wlEdTzCZjVYaggjCrx9BS7BJ0p5T+g5/bAhvaj6cGagm0CaBpEem1qisrR2JIojiWUvHObQoyFB98QX8CxUnW1RKU58oAjKrnouFRL4Vl4nKs6a+nverzdnFdov5wwNexZBoflric+byr9q84lx+RG7FU8FtZUD+uGFGjnRzwMrM1TkQruS0UILg7ALpNjbH75vBDqHENBHvB11EJl5VYjLU/ZVvRlaZ4Df2OzzhgTPWNbTKIicdI4O+EtA+e7bCieqjH9Y5nJ0QP1vsdAQOOyryzWU+dMkZDot8i8U1R3QDAe4+2RXLrHk5VVIgqj/dAYKGh/s5o/AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAIqVcq21Mn+WNwSsD7l4UX0rDoxyOH3wXw14v+T9gHWi/ZQDFYo5Yp8w0R1tUi7RY9n2hVN2UZEstW3I2/rnhLoOdEtmASQCuW/tPC5RdH1+J1AgLEDojDRmRiWQD87Gn72sKlPJ6OE4GHuDII9yTP+pmR/JvPvi+CqrJ5rMn6Yl5hUNr9WY/VNbiMIIxs555hWQjbs8enRVh623dbGutqmq2ISTkQ5IFwaYTwPaDYnSA54yNNtkKq1WQBBnPE0Nh+O2H5agqHDWxn13n3YQS7phit9ZUKOAA9kXNSIhmwPjw06QbRpsuMkC5qHQIvk0GZMRJmHscfIqUSPat5jOYco=
88a0c9f4-2024-43c1-83fe-dccfec69acb6	c686b2ef-f2b8-495b-a724-7afb8e4e4b56	keyUse	SIG
3dfe5689-b85d-4772-902c-5ec6ac12d142	c686b2ef-f2b8-495b-a724-7afb8e4e4b56	priority	100
edf78694-138c-40a0-898e-4e36a743192b	5b5df947-d340-4ad2-b27b-4c83b45cc065	priority	100
93e56293-ebb7-4ef6-bf0c-ae39e3a840f7	5b5df947-d340-4ad2-b27b-4c83b45cc065	certificate	MIICmzCCAYMCBgGeMM08oTANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjYwNTE2MTIzODM3WhcNMzYwNTE2MTI0MDE3WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCt6V2BjJH2wxo4OPHDSKiWpAp9RE8T2+n+txe9kXZgSwVTl6JriuZZAJnaYEN+7h+B6+t63Wbi61i/k4XPGnznZ4+A4FwEyJjUpQj0FpuaURcPdBIotI0xCN0C6dDhFgfJlH8T69S6AQQzP9/HBh9zhC9X4nKIEnha28iMeLx3DHNfdbb7LtwcF5MsbKaZ4ywsCkJTrxYIS8Te7NeUKjw60Ina9KOKVDu3iFX1yX6+UuiQ2M5Kq7xWoJfS/O/NUl4U2Jc3xq8RDqKRpgyLFDCdOOxDLh45pVLdHlTqqtKveZaTM1Lyu7ZlVsE95ZhCCcTftr8ciq0lbCW921CYy1+xAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAA1yRpdL4yuO36lxstGMvAvUY6bIV0MVGZLfuU4AVXnATI2n9HGLCkHEFGczIGkKlExOLu0Cfpq4LPetUCFbgKZ1OI/2qcMvByk4ya1u+GBtPdrBbwHHU6cFDznZiHzkvzE7GP/hlecztrKyh1tHwj2XfUMwJZOxJi391DL3aHDz06aUzjGD2cUcxdcdEFyoX4KVNOR0yMzgvGiv+YIzJC7WvB9YT9kX5UK7O+FUFVRixNuwPRqwgd+UYQG337HlnBAakg3we00us5Nemj9jCFkxO8IuLJooIP+KG7UkIXEkkQLu5azVKL6oPWEHhxspuKoD/BwmOysmFPzlU6XAIwM=
fea34f11-0f8b-40ec-a10b-30b07c906217	5b5df947-d340-4ad2-b27b-4c83b45cc065	keyUse	ENC
2cb6e5b8-1421-4859-8539-fcc23425b2dc	5b5df947-d340-4ad2-b27b-4c83b45cc065	algorithm	RSA-OAEP
a29258ae-d29a-4e0a-a8a1-d76455cf25a0	33296dbc-85b1-4a74-b206-ce8600cfae0d	priority	100
a3ad4933-02c3-48d3-9271-1f0f98c52a96	ee257445-c7d4-4c9a-b976-4a1293e450f2	kid	53d5f74f-b574-481f-8882-8dc262d020f7
96d2cd33-5f56-4914-a29e-b68938c04e96	ee257445-c7d4-4c9a-b976-4a1293e450f2	priority	100
bd404342-3899-4b3b-a58e-4a2d573150e2	ee257445-c7d4-4c9a-b976-4a1293e450f2	secret	p-LWTw5cN0WP2Dpon2kXbg
6ff0ccdf-609c-40bf-a86a-910ea74e2942	5b5df947-d340-4ad2-b27b-4c83b45cc065	privateKey	MIIEpAIBAAKCAQEAreldgYyR9sMaODjxw0iolqQKfURPE9vp/rcXvZF2YEsFU5eia4rmWQCZ2mBDfu4fgevret1m4utYv5OFzxp852ePgOBcBMiY1KUI9BabmlEXD3QSKLSNMQjdAunQ4RYHyZR/E+vUugEEMz/fxwYfc4QvV+JyiBJ4WtvIjHi8dwxzX3W2+y7cHBeTLGymmeMsLApCU68WCEvE3uzXlCo8OtCJ2vSjilQ7t4hV9cl+vlLokNjOSqu8VqCX0vzvzVJeFNiXN8avEQ6ikaYMixQwnTjsQy4eOaVS3R5U6qrSr3mWkzNS8ru2ZVbBPeWYQgnE37a/HIqtJWwlvdtQmMtfsQIDAQABAoIBADvfFUPeQvny3PnyELksMG3792h8tcSedwYrvk6S32/zI9hNYasoXHjTjiPx9Aqkq9Asihr4Uc1ZPGpnvS85bTq1GmBB3SwAayz5zAVMKzGLLScyzHWbAuiYpo20NSboULIDH2SaUdffNbT3DnEUGIvKPApDeS6DPU/6TiaeAjPxUdh59vlHuYkXwiVycUfjbOh+3FaBkad/1UneMcrGmkmGYY8lq9pbJ8SM+AvOcFiNDCGgkX1Ps2Js4goah7TWrvEbToTHa9JcHZ/M2w+EGG4ZK7t6cfJQI+Up79aSjYnIlh8SFicWk47RSRilgnraEGB81X7u7KDVAarLgilsCGkCgYEA345LZwx1Q0sjqfLuo2BriiagxnOP2WgAinY2kJt0a0BGGVW2JBTvKFnYdXEhhsMJNYKARIpeEyFrE3YEtnQCMEgDAORLMI51XvIu643iH9r6SCoFsoD1f7x6EdJuMMxe+EZcVqtiKRFQ6zOUOT1fjBfzrXJi78S77/qCNCVnVnMCgYEAxyam7QWuse2ZcU0MBGxnt07fOoEKD/oSwkxaAuGmTg+pEBSazT/8mHbBI7+yp8Xxh4Ae6Ge4D4d9rPMlRZZrzH6tPka0+ALWcdl8aBUCl58HlvOfIm/i+PElpXaROw+r8hBiGj4sblYfqWdl09Z6fAN0HsLc+KHGq6IFefsXxEsCgYAKZavMFyA9CPmXpdzDbHCT9Ef18tn12ohr6CORhilb85lPBFV8SBz3W3Zdv+03P0rmWjNs/KJzcVJxjUOa2LphVHgPSo7Uq0t6JvlXqzmhEaYiRRIOw0CnuDRVL9xAGMEx+tPAlCf0kQGabsOuBdSzx0ll/7PqQtQazSPRGQw9UQKBgQCHfTF18ja/EKIjJkL1w3bwjHVszRu2cPFQRTe73B8T3q2rpgkHeO/2Hl0aYDJA2HeRM0ZT4TSlRA3pm2aRKFxgvRJKWzqFvRB+VnPAMAMaenRka4yplit6KD3vi3IVF31o62KC7ie2TVuvGgx6CeI8+vCGeRZzBUUvwcQuD/lEbwKBgQCwPMuEQLss/Vn47ETdmVVam/0cTxFbRbadQkoSwhUpBhmIm/AOedbYs10PQXHKfZQcz5JkdePXLn4h5X66uz2WjJgkLTWnI6hYYDjVrbFv4CkRZGEJoUkVfuwzeenWnAf+fPrmbnzsQPbZ40ev4GKWVhNABx+EatKbuzCD4w91MQ==
91395d7a-b471-4fa8-b682-ae366b2a0450	698613cb-6f1f-416e-81e0-36299f6e4459	kid	ea4c9379-78d0-4466-b7a5-6b2769fd0bf1
b112fccb-5915-4521-ad73-e7eebcb09095	698613cb-6f1f-416e-81e0-36299f6e4459	secret	vvKbwboIwCRCoHUsSuaFpQ
c1bbe898-9a52-4c26-a315-7cf79226a551	698613cb-6f1f-416e-81e0-36299f6e4459	priority	100
e237cbc5-e1c2-42bd-8f6e-b4531a577f5f	e70bc8a2-95e2-4cb5-a3b3-b97c05d949f8	kid	c7a0240b-5928-4911-a0cb-8736145204c5
b9d3e466-d685-463e-84c2-80d48ae19931	e70bc8a2-95e2-4cb5-a3b3-b97c05d949f8	secret	9SBn4J4rnu69sNybeeiyE5C0cGLB2pVTLCBT0sUM8-pLTy9bONPwiAUkv6onW1ca8dw9iDv5wyzWI-QGuReEoADq-C0O2bn1l-mUdWVxdNiZ-siZggKrNBQPg76HsyC8Z-nid3rwBKBn4FSGW4gYFFUrS9ISVpAbtsQ2B9Lk_pU
99b2d313-252d-409b-a452-0fcafba71b68	e70bc8a2-95e2-4cb5-a3b3-b97c05d949f8	algorithm	HS512
dc35df90-1e5e-4eb3-9b51-d31364d7f189	e70bc8a2-95e2-4cb5-a3b3-b97c05d949f8	priority	100
da0981bd-2e05-421e-9a68-96fb4ac454a5	8dd27e3e-a481-4049-a486-ff85b85763b8	kc.user.profile.config	{"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
e48faca4-c271-4705-8aab-ced5a8cfcd34	1ad60cc9-f1a7-4d6c-8d35-4ae540b46b0f	host-sending-registration-request-must-match	true
462ff7b3-dbf3-4995-85b5-de1342ed8e9e	1ad60cc9-f1a7-4d6c-8d35-4ae540b46b0f	client-uris-must-match	true
2137eba2-769b-4fb4-95ef-70151c21de4a	f0844c0f-83db-4cfc-abe5-8044d33f5d7e	allow-default-scopes	true
527a4865-4311-462a-b782-6cdd5a2baf6c	a72c26d7-9ec5-444c-8c86-1ee271ca4f57	allowed-protocol-mapper-types	saml-user-property-mapper
53b72555-2bbe-4a2c-9a13-815f8094e983	a72c26d7-9ec5-444c-8c86-1ee271ca4f57	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
17900e7b-fc1d-4ab5-80b3-3d20de3845a8	a72c26d7-9ec5-444c-8c86-1ee271ca4f57	allowed-protocol-mapper-types	oidc-address-mapper
52a8523d-029a-47cc-bc41-5b8fd1b9c8b2	a72c26d7-9ec5-444c-8c86-1ee271ca4f57	allowed-protocol-mapper-types	saml-role-list-mapper
a70b549b-59e8-411d-9dd1-3e995051c266	a72c26d7-9ec5-444c-8c86-1ee271ca4f57	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
449f1952-191e-4715-8b0d-2d63e3b45c2d	a72c26d7-9ec5-444c-8c86-1ee271ca4f57	allowed-protocol-mapper-types	oidc-full-name-mapper
11d61234-3b39-422e-95b1-73891b5d1556	a72c26d7-9ec5-444c-8c86-1ee271ca4f57	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
c4e098c7-fee3-4ea2-9445-b6c1aceb35e2	a72c26d7-9ec5-444c-8c86-1ee271ca4f57	allowed-protocol-mapper-types	saml-user-attribute-mapper
6042ffdd-1e4d-4a84-84ab-0e11658171a1	a07e7b5f-1ef4-4f33-b11d-a95a0d7bfc38	max-clients	200
767e450f-eed0-4c9a-9691-f0e888dfa651	b048d838-9fe5-4e1b-b59d-e6547d4f5b23	certificate	MIIClTCCAX0CBgGd6fLVLDANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANUUDIwHhcNMjYwNTAyMTgyNjM4WhcNMzYwNTAyMTgyODE4WjAOMQwwCgYDVQQDDANUUDIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCy++HmBU+u0LbsYeUArcM9ICuYhEWUJhK1ahEbis+G8c+5gJaagFejCvVOsI5UAdCSfwDQzoifAVAMzBJyQ74PEzz1UNbwhNkM0nuD+7/uk3euBdfp2wNjhKcxSOIjH7smrry7pJomQy+Bp0OUmf157Rbyr562XxGSasZlFNVvNyvZcXFW0OgGZ390OZYJqR+lkW5FjbqcoQASbAbfJQEcnBV6VFeb2HIJGv44wv6KaI9/O6ZH6/QWfxK6fiv8t2dYurrQXCm10cw3VkhR8Ty55FgBkUgGtcGfFqxNnSI4tWth3ORmB4Sg4X3XV9JmuLplgjUYUJzYwb7lF5umXYnXAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAEj4Dw7ILNGWP6Qw/h6P6IRXAiRUjiOTQon4sQ9PsRB74jFEZzKBLefj3R5U7LLgGy9Ef8FOCqg0v+3KXHiW62ewEgG2Jl5ZySjJ1aasmFm2ek6r7/FDN2qFLwxpLUJFWDRL99WqHJ/UiRRL67C5MgAYmy5Y1XIPlJ8J2U5NwthddzSTD8s3LiLA0AYE3SMuySuAYuNqUidbrvVyzxbQbNYRTAvRiMordvvzE3dYIKuCem42NYHr0ehH0xclu4l3ppvXLzQNcRxtkDGwz1h1TlXSjPQEBQJWjVvw6crVOgv9MF7AKsen7nARWllXaSQinNLlJn0bG7iC9C2AH1AmWI4=
d34658cd-739f-4a6b-83f1-cde7448c11ad	b048d838-9fe5-4e1b-b59d-e6547d4f5b23	privateKey	MIIEogIBAAKCAQEAsvvh5gVPrtC27GHlAK3DPSArmIRFlCYStWoRG4rPhvHPuYCWmoBXowr1TrCOVAHQkn8A0M6InwFQDMwSckO+DxM89VDW8ITZDNJ7g/u/7pN3rgXX6dsDY4SnMUjiIx+7Jq68u6SaJkMvgadDlJn9ee0W8q+etl8RkmrGZRTVbzcr2XFxVtDoBmd/dDmWCakfpZFuRY26nKEAEmwG3yUBHJwVelRXm9hyCRr+OML+imiPfzumR+v0Fn8Sun4r/LdnWLq60FwptdHMN1ZIUfE8ueRYAZFIBrXBnxasTZ0iOLVrYdzkZgeEoOF911fSZri6ZYI1GFCc2MG+5Rebpl2J1wIDAQABAoIBAD5+inLJWfg9MhG5YL9q7KfUKsS3MqA25wNnBJAsWKfSmOg5iNxrga4RLnQKW7fjZlMwezVtV/DFAZFmU+6Hzr3uxrMVRed3S14ZxDziUzLXVMtziN9DtJwz/jjMLQF8m9k22/lc0OIZRWYs5ADn/8Rpz0Bvp6gf67/G/nze2GNbN7QrK3XvHxC2ymP2CBucCZB6oak2lu3hyfuedjAbFOw73g+Vx4p5YQcRLWqn80l69vdQ2RgNYRksC/ip9cYKhjOTPuEIZedonL5asNvrGo+iGaXyBe63ogHLTl6uu27EYn5UgVfccuScWqkN2bvuqxviC014M4kWm/UX/PZJb1kCgYEA2uyPVCebp1dnoxOgwtxkFEfwlfJ4Q3gMSAMF2z1MSy+5rXl/018YCA58yHN5M1NHPC55kUHuhY0tImh4FzIlTF0hxywL0S9u4U6U0SCgehLYQkDgguKIk9x6jlK7yWc5d9n3eZ9x5nU9oWHAFLlr9o7L7PxNh5h1qKKeYuwChRsCgYEA0Uu4RCvPzkt6e/H4xypndGi8Mk5cKBlaHCjyLqV9luNa6bzhR6euX9aXq9Ui+W/HstosoxH6PeBg3G67Mw2UX6wHL83k5F5xGfmIKWC6VHioNl/eItlzK3wAxI9HfHHEbmHb9M0TT3eCh/IRj/INguPYIevYSpbUZ3uszknZ5fUCgYBRhwMhXdazjPNFYcvehWCnxNqtnKx4w74fGzEVIlDFNzK4jaSyvJkgdvS1WXtrR7ohiVUwaRNAnQCP7cO7L6uAMrafi6Gi9z0dnrwA3Vul2lq64Zo6Y85k8hiZ4+mW6WAXaA6nNl+eaU7YSKTVku/H1AnRaWwd8QLwGA9P24BcvQKBgDO3ZCbkNIsjN3bdCb4dCkdHgglkN31pFk0TCRThq7DXKSXMmFYeZwYjfoLlPakpJ81X/+Ojk5Qql4Sgj/1Dg8BIP9ZeKAsOEyB5+l1PG3u3/MjC058E4GKEV6Q6S03CxukHoVRSQE1ImKaC+Df7db88EbIAFwgHUSDo/IBU21TpAoGAcfEs8TlpthRSFCYAWHsadl+GCSfBbbelwe9RGyp4/dngKeyCIQasLn/GHq8u2Reul0+trUU/eOL3e0VuV/juJiEkM3D4dfFWvjfS2ZX46itUnYF+WYNrqZHg37eBT+DgTs4u2n2VLpYsnMH94QwwkR9fp7ky0mwcepAjc12w1DI=
746c9c12-ccbe-4ac6-964d-b6a06778cea5	b048d838-9fe5-4e1b-b59d-e6547d4f5b23	priority	100
b8f981d4-9d0e-4506-8354-4dd7f59f95c1	b048d838-9fe5-4e1b-b59d-e6547d4f5b23	keyUse	SIG
b616f22e-b517-4c0a-98d0-5946648ba6f4	6f95231c-4970-4f7b-8485-cf80485fa6c4	certificate	MIIClTCCAX0CBgGd6fLVaDANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANUUDIwHhcNMjYwNTAyMTgyNjM4WhcNMzYwNTAyMTgyODE4WjAOMQwwCgYDVQQDDANUUDIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCcYmdglpd9C9FSHBVJC/HAVsyVAKloH/werIrfKIHjSbUIHTPJBkBryLbUSVpnfwZ6+mZ/vFPzrtaa7YWRrXjjN91qA0NsdLQVTkh8133tm4aUZPO+ocF2KIJsNjC6RNKZCQnRp3PXy0tZTZXkYiBS/eVXD56UxyMVYg4eiHkow9JtCGu+VuCIm4YklZ1+9Z44zEZVuEBun+H9/EG04HEJmn6K/dtrTs31ygsyxeCPj6U9yR3eWWDVbEat7/6rEj5Aim1sveNE579gA0pOa3jkFrFRfc8Ce/XN2c9xpg74daMm5DRLpkLz/MOGBOq/D+lmIfjCuSJALtkw9Lkuz2s3AgMBAAEwDQYJKoZIhvcNAQELBQADggEBADZ10L646Rs7fhE2ojl8R7IHeqjMJgFe9nzAbT5aLqOtEA/up5xjYv9HbW7n//7BfNpDXgc3/nSoY0MD7T4Ku+fNjXZzRzmlfgrCO8cy7mcDa3THIPyAY60EG/w0mPYDTesv4czDsJTZjx3U9btBOtQ9LwmtusI4ql2tOOsZs0UIJADd6HugMrpFWo2oSAMyNmChSxrNpZPFF8qBlkhpz8+Zvxs8BQvr6+B+C+Vj97af+DMT1bxaQRN0FSQB63wJKDqpMfsFyIzKrbOVMvLb4IwcanfZQ+uuHLYNF8RcWFyAIvtOHKVXl3PJXjJmOBytHPQTzrfKI6ixr3EV7C/zZrc=
e157aa70-8785-4b83-b1bf-9f473c62e05a	6f95231c-4970-4f7b-8485-cf80485fa6c4	keyUse	ENC
15d3607a-a46d-4636-bc9c-bcbf792ac0a6	6f95231c-4970-4f7b-8485-cf80485fa6c4	privateKey	MIIEogIBAAKCAQEAnGJnYJaXfQvRUhwVSQvxwFbMlQCpaB/8HqyK3yiB40m1CB0zyQZAa8i21ElaZ38Gevpmf7xT867Wmu2Fka144zfdagNDbHS0FU5IfNd97ZuGlGTzvqHBdiiCbDYwukTSmQkJ0adz18tLWU2V5GIgUv3lVw+elMcjFWIOHoh5KMPSbQhrvlbgiJuGJJWdfvWeOMxGVbhAbp/h/fxBtOBxCZp+iv3ba07N9coLMsXgj4+lPckd3llg1WxGre/+qxI+QIptbL3jROe/YANKTmt45BaxUX3PAnv1zdnPcaYO+HWjJuQ0S6ZC8/zDhgTqvw/pZiH4wrkiQC7ZMPS5Ls9rNwIDAQABAoIBABEf43MbunX6e87yfVA06yGlP5zXaDWbPwf62/Ao5uRFN3oufHO4aAiFf6PKbohjzAlebyfwrv7BuAVaGiTEKrcy8F+CAPmY4/lrS5vEGymQPNH2JgzLeLxgHjwMSRS0oZ0ZdMZNAG3yeItMaCwMpL6ByAHbF4HyNoDKboJgbmgMsYZcaGV5qXZpskme97z6QbuYjinTNhNwkTqt8qDVJ5dGcRQUQpAskOJXojtIlbKnzDEGF+c6OaLv6i2UB9fZQlePuwo9jrkSIr6aOJLW4lGXyG6oiLm/uAIaVmVJou/zX+zHs9xO4i0mbgjH6KiU4sp4zIbYfobRqA5iWF2qUqUCgYEA15cBbztnwqQEWZOg+sZMjw476givFlaVkxF85U+pHNk2Oa1PXYeuCgaKQ2cv31YwA4W6kWKECehUAQXYqujkkHhNiqdjfJEhdRDKXHa8xKK/8Nob/kqQ7N6wVpTKra1uk2bXTAVelKiCJkYbadEMd/GeevqSmi6avwgSknOue7UCgYEAubJyZ0OYqv2k+NSdwvPyiTkkupqlCWUocfHlPzk49GT4lJwj3YcygE3C7QWc7QHizZWEJOF+coxeT1eAK4HJbwqjfh+ZirnzbALQcIZQ70Z9Zsn/5lx5lryaOzeR1ZAT0ZYT6W75GJQMwXwg4vTqFb9eO2QgIgkeI67DjbvDlrsCgYBG7UYqixe64G0R71DB0CV11w/9EfhQWBIDfXhilM+lTwzY8tyuf6nRYI9yV2tXhapsLj3QAOJBxC6G256Js+8mXH3eRO2lGLYyJmD9BI9b/dM58PfOtEdztlu7UF5Rv0ImumnQd9/C9qFC6EOyj3UTrOkfunoqwXRlrsk1Z1ubFQKBgCdR7sGI4anLPYRm2OTv7Lo7vFg66Jk9rzu5YbZqcnHlc3FcQofk2b+rN4witSDGVnT7pNh+Wtz8dffM6lnMCJAXq5jILiXey/lh+yrodfjEb0c1nJb1m9VcKDhDwwB6moe1hI/YLKyUpMLPetMz0uE5/UUMJXWvgo9BsSywxnCDAoGAc80LalIweG2xMP1gMsx/L3hSN3qf+pU8tUVWEVYxtB+aPSfhcDofTt0KvBQ/tqEPq0spH4R9cMkf9Z8sVPaZ+vDEKiHnHX+lTxoQD2Xedu6zb9NZzpxIUnnOIGHd+1JJL/Qv28ZllVJO1rC8tFz4ecivnEYp0z3N7fjUEGzDT9Q=
b0c097d9-4e42-4fe7-ba20-6d1541bb4f80	6f95231c-4970-4f7b-8485-cf80485fa6c4	algorithm	RSA-OAEP
930ceee7-9506-4d43-9c16-a1630263c3f5	6f95231c-4970-4f7b-8485-cf80485fa6c4	priority	100
cb1c83b5-367a-48d2-81bc-ac47b6087b9f	900d92a9-36ea-4ae9-9d95-45bb0b146a29	allow-default-scopes	true
de79bd94-eba3-45ee-a8d9-2d0497443e92	5867bd1b-0a75-444a-b0c0-728242c8de9a	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
d047f953-c545-4b0c-a037-73b8725f13c1	5867bd1b-0a75-444a-b0c0-728242c8de9a	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
db4b75b7-c1f6-42f7-bc6a-ab6bac00d4a0	5867bd1b-0a75-444a-b0c0-728242c8de9a	allowed-protocol-mapper-types	saml-user-property-mapper
20ae214e-1ec9-40d7-8c6b-3f51a7c074d2	5867bd1b-0a75-444a-b0c0-728242c8de9a	allowed-protocol-mapper-types	oidc-full-name-mapper
326e657f-bbb5-4ecc-a5bb-1b1f532acd41	5867bd1b-0a75-444a-b0c0-728242c8de9a	allowed-protocol-mapper-types	saml-user-attribute-mapper
c962e6fa-eb17-4a78-9648-e053070c01a6	5867bd1b-0a75-444a-b0c0-728242c8de9a	allowed-protocol-mapper-types	saml-role-list-mapper
e1202a58-f7cc-46bd-9741-158944563963	5867bd1b-0a75-444a-b0c0-728242c8de9a	allowed-protocol-mapper-types	oidc-address-mapper
5b6e2480-e785-4897-98da-70beff4261a4	5867bd1b-0a75-444a-b0c0-728242c8de9a	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
141a4ed6-d7d5-4c08-90fa-624495cd1c35	46426640-58b6-4b8f-b2d0-dc7fb459aad5	kc.user.profile.config	{"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"required":{"roles":["user"]},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
7ebc833d-c248-4648-871f-d06293ad48da	33296dbc-85b1-4a74-b206-ce8600cfae0d	algorithm	HS512
1d8264ce-fb44-40ee-b4a1-f7ca8d37d5ca	33296dbc-85b1-4a74-b206-ce8600cfae0d	kid	a274c02f-e5e3-4b65-8c7b-8ca108a87a75
1762d5a4-d4dc-4a82-832f-0530e1895469	33296dbc-85b1-4a74-b206-ce8600cfae0d	secret	oAZldyCBa93EcTt_xRPfZbrfjrpGaQVqU7KqihiHMg9daDWUjgaGRHr2s0V7R_ToRYMkP3oR8vJc-ZuOOmLv7Y5DIA9tyPeEvIEB9-YWLwbzOynfN_rdZYgNEKNzBOmegcJ3_3tIo7p5dTg4kTXcfoe0F3uDDUsRVX11dTpNYj0
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.composite_role (composite, child_role) FROM stdin;
7b40d8d5-434b-4884-ae83-4afd3a15d34d	42068a11-3d4f-4f94-aea1-920bf463f22c
7b40d8d5-434b-4884-ae83-4afd3a15d34d	fb7b964d-4dd5-443d-8393-07881758a422
7b40d8d5-434b-4884-ae83-4afd3a15d34d	7efd5d73-17e2-48d6-a621-86c84548ade1
7b40d8d5-434b-4884-ae83-4afd3a15d34d	ad8c65c1-e9ea-41b0-a64c-15f67ef3a7bf
7b40d8d5-434b-4884-ae83-4afd3a15d34d	bb497a78-9bef-4c0d-84c2-1de042dc9902
7b40d8d5-434b-4884-ae83-4afd3a15d34d	5c2ea366-4970-40ac-a5bc-6616cbfb62c1
7b40d8d5-434b-4884-ae83-4afd3a15d34d	7797a4a8-b84c-4797-bec4-a78b94815297
7b40d8d5-434b-4884-ae83-4afd3a15d34d	2bf916f5-e75d-49cc-ac80-4b275e8f8008
7b40d8d5-434b-4884-ae83-4afd3a15d34d	6fde2777-47ef-4b70-8739-98e73ec784ef
7b40d8d5-434b-4884-ae83-4afd3a15d34d	2ebff3ab-ed84-47bb-a621-48ad78004400
7b40d8d5-434b-4884-ae83-4afd3a15d34d	f82b5852-08d0-474e-8319-18524a660d19
7b40d8d5-434b-4884-ae83-4afd3a15d34d	8282088e-5839-4910-bce2-6d44c40cbeaf
7b40d8d5-434b-4884-ae83-4afd3a15d34d	4a027d71-1a4c-434d-8456-d763c830b93b
7b40d8d5-434b-4884-ae83-4afd3a15d34d	4ff5dd30-ce21-4685-ad4b-543996cd0f17
7b40d8d5-434b-4884-ae83-4afd3a15d34d	4aaeea63-ac38-4cb5-a497-8d74cb0ed2ab
7b40d8d5-434b-4884-ae83-4afd3a15d34d	496a2d9e-0b43-483a-a503-3f7c085d741e
7b40d8d5-434b-4884-ae83-4afd3a15d34d	6b324e2d-3a22-4d90-b171-d95a40b0035d
7b40d8d5-434b-4884-ae83-4afd3a15d34d	ab990b31-e663-498b-b7c2-1189681ba0b8
bb497a78-9bef-4c0d-84c2-1de042dc9902	496a2d9e-0b43-483a-a503-3f7c085d741e
ad8c65c1-e9ea-41b0-a64c-15f67ef3a7bf	4aaeea63-ac38-4cb5-a497-8d74cb0ed2ab
ad8c65c1-e9ea-41b0-a64c-15f67ef3a7bf	ab990b31-e663-498b-b7c2-1189681ba0b8
29fe7f1f-24bc-4ffc-a3b7-8f7899d8638a	4cf7e150-3c60-462a-a7eb-a915fa280a96
29fe7f1f-24bc-4ffc-a3b7-8f7899d8638a	59e9a4f2-be59-471c-a717-c7cad87561ce
59e9a4f2-be59-471c-a717-c7cad87561ce	5354ddaf-b195-48e3-a33b-76c17fca2001
5ca52fe2-dbd2-42f0-a1c9-d9e61b582123	ab5540d6-19cf-4632-b5a7-387ebac99b06
7b40d8d5-434b-4884-ae83-4afd3a15d34d	5723c8e8-e8d4-4341-ac97-4b28d5530d3b
29fe7f1f-24bc-4ffc-a3b7-8f7899d8638a	1c5c520a-20bd-4b6b-88d6-82d301c9dd42
29fe7f1f-24bc-4ffc-a3b7-8f7899d8638a	8e7fc856-aa37-4dad-bd96-ae8dd469b836
7b40d8d5-434b-4884-ae83-4afd3a15d34d	98a79390-1373-4028-b22a-f4beee8530e6
7b40d8d5-434b-4884-ae83-4afd3a15d34d	cac2dba9-8348-44d3-85f1-3b3af577d891
7b40d8d5-434b-4884-ae83-4afd3a15d34d	07afc6ce-4bff-43e1-b0af-a875468d5242
7b40d8d5-434b-4884-ae83-4afd3a15d34d	62bd8825-292b-40e5-a33c-369450dd6fa9
7b40d8d5-434b-4884-ae83-4afd3a15d34d	c333ecb4-fa64-4b67-abcf-3f9718496f23
7b40d8d5-434b-4884-ae83-4afd3a15d34d	3377524f-ec81-4752-ab1a-6c0edc438cb7
7b40d8d5-434b-4884-ae83-4afd3a15d34d	24c9afe4-9289-4087-a633-7d087e24aa47
7b40d8d5-434b-4884-ae83-4afd3a15d34d	9633d151-3099-438d-a4b6-8390bef0e657
7b40d8d5-434b-4884-ae83-4afd3a15d34d	ca5974d0-2c0a-42e4-8c9f-3c531e06ac43
7b40d8d5-434b-4884-ae83-4afd3a15d34d	c673f92e-42d2-4561-a13b-7aefc1ab0fea
7b40d8d5-434b-4884-ae83-4afd3a15d34d	cd4e0079-f3ed-44ce-a465-d54029197b75
7b40d8d5-434b-4884-ae83-4afd3a15d34d	b804c393-7880-4d38-9f65-09fe76abf140
7b40d8d5-434b-4884-ae83-4afd3a15d34d	5a07baeb-584b-467c-83e2-890b78e0f5ce
7b40d8d5-434b-4884-ae83-4afd3a15d34d	d2541de7-cde3-449f-8476-7450a016d9c5
7b40d8d5-434b-4884-ae83-4afd3a15d34d	09e2bdfb-5dca-4da5-9890-00f48841186d
7b40d8d5-434b-4884-ae83-4afd3a15d34d	041b2395-257a-43c4-ade8-2e929fa96130
7b40d8d5-434b-4884-ae83-4afd3a15d34d	b357b230-26d7-4028-882b-f67a011a8a9c
62bd8825-292b-40e5-a33c-369450dd6fa9	09e2bdfb-5dca-4da5-9890-00f48841186d
07afc6ce-4bff-43e1-b0af-a875468d5242	d2541de7-cde3-449f-8476-7450a016d9c5
07afc6ce-4bff-43e1-b0af-a875468d5242	b357b230-26d7-4028-882b-f67a011a8a9c
8a3b9be4-a634-4772-aef7-e5947104a3e1	4fee6c90-ed20-4009-be67-b4ef7aa89c76
8a3b9be4-a634-4772-aef7-e5947104a3e1	351e6d3d-662b-4d66-835d-702a224f2b91
8a3b9be4-a634-4772-aef7-e5947104a3e1	f10a90da-a607-4502-83c0-fb3266810a50
8a3b9be4-a634-4772-aef7-e5947104a3e1	c47cf8f5-55fd-4f03-b4d7-bcc140328e14
aa911fe7-d6ba-46c3-a7e7-57511d40f41e	20547e78-a702-47b9-9ce7-c607e60deb02
aa911fe7-d6ba-46c3-a7e7-57511d40f41e	bf57b233-eb02-4d19-978e-f00c1abdb688
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	e263c824-0992-4b17-b089-ca3cbe9fbdb8
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	aa911fe7-d6ba-46c3-a7e7-57511d40f41e
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	20547e78-a702-47b9-9ce7-c607e60deb02
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	67928a8d-489f-415e-aba9-ce370cb05b3a
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	bf57b233-eb02-4d19-978e-f00c1abdb688
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	ad5ccd6b-4e02-42b4-bc23-c58a12840034
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	a8821c59-092e-4a7e-b41a-cccb9084fc15
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	79299d8e-a149-493d-8d7d-b12930c567f9
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	d1ed1cb6-1ef8-4b0c-9ad1-45f8782576ce
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	5e04c2cd-6e4c-4096-922e-7d2eed46528b
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	7903c869-4860-4990-94d9-e866c3d6fe4d
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	5bc83cec-fc4c-438a-93b3-5a6e479c9446
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	817dd8c0-065e-43ee-ae50-be467525da87
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	cff97677-c06a-4d14-8e53-df1620a33dc4
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	01d34f26-0726-49a6-ab0f-8ff234539fd1
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	d68b4881-ea5e-4a36-bb8c-d4021af9dc9a
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	ac58e36c-cffc-42d0-a7cf-282f424ea043
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	168828ed-a6c4-4704-98cd-bd4704a2d354
ac58e36c-cffc-42d0-a7cf-282f424ea043	7903c869-4860-4990-94d9-e866c3d6fe4d
4f99fd77-abf9-467e-aacb-c9ceb1eafde7	076f7f68-3024-485a-a3d6-281d3e2c1a9a
c47cf8f5-55fd-4f03-b4d7-bcc140328e14	ece19bad-841b-409e-ae6c-752e2dd062a4
7b40d8d5-434b-4884-ae83-4afd3a15d34d	d8033681-8077-494a-b621-ef42557c9a70
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority, version) FROM stdin;
083032ae-97b0-417f-80a3-e610feb9b87e	\N	password	160dd65c-a471-4d1f-84bd-2881486cec39	1778935220439	\N	{"value":"A7od94jaJEbUsPlCsTTuHUMfmd1jrKt4W25CM1EbZL8=","salt":"NclRvy7YgwRQKJDB9Ns1tQ==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
cf09171e-9f9c-468d-83aa-dcfdf1162544	\N	password	e6633081-cf68-408c-ba9f-4b756d4c1a93	1778964640834	\N	{"value":"Iau7LVJDXV1xlxI005pIiAmbJ+2354aSofjefbF/2bk=","salt":"fzAB87jLITF0ZZC1dM++nA==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2026-05-16 12:39:56.124075	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.33.0	\N	\N	8935189548
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2026-05-16 12:39:56.151649	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.33.0	\N	\N	8935189548
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2026-05-16 12:39:56.226128	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.33.0	\N	\N	8935189548
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2026-05-16 12:39:56.237618	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.33.0	\N	\N	8935189548
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2026-05-16 12:39:56.500924	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.33.0	\N	\N	8935189548
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2026-05-16 12:39:56.515372	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.33.0	\N	\N	8935189548
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2026-05-16 12:39:56.74829	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.33.0	\N	\N	8935189548
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2026-05-16 12:39:56.764147	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.33.0	\N	\N	8935189548
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2026-05-16 12:39:56.788982	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.33.0	\N	\N	8935189548
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2026-05-16 12:39:57.012877	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.33.0	\N	\N	8935189548
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2026-05-16 12:39:57.202985	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.33.0	\N	\N	8935189548
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2026-05-16 12:39:57.214024	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.33.0	\N	\N	8935189548
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2026-05-16 12:39:57.273641	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.33.0	\N	\N	8935189548
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-05-16 12:39:57.333485	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.33.0	\N	\N	8935189548
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-05-16 12:39:57.341675	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-05-16 12:39:57.347997	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.33.0	\N	\N	8935189548
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-05-16 12:39:57.35458	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.33.0	\N	\N	8935189548
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2026-05-16 12:39:57.436916	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.33.0	\N	\N	8935189548
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2026-05-16 12:39:57.550759	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.33.0	\N	\N	8935189548
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2026-05-16 12:39:57.564548	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.33.0	\N	\N	8935189548
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2026-05-16 12:40:05.67782	119	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.33.0	\N	\N	8935189548
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2026-05-16 12:39:57.572933	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.33.0	\N	\N	8935189548
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2026-05-16 12:39:57.58091	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.33.0	\N	\N	8935189548
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2026-05-16 12:39:57.689761	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.33.0	\N	\N	8935189548
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2026-05-16 12:39:57.70384	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.33.0	\N	\N	8935189548
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2026-05-16 12:39:57.709864	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.33.0	\N	\N	8935189548
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2026-05-16 12:39:58.205897	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.33.0	\N	\N	8935189548
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2026-05-16 12:39:58.408675	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.33.0	\N	\N	8935189548
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2026-05-16 12:39:58.416124	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.33.0	\N	\N	8935189548
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2026-05-16 12:39:58.621758	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.33.0	\N	\N	8935189548
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2026-05-16 12:39:58.670681	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.33.0	\N	\N	8935189548
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2026-05-16 12:39:58.725538	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.33.0	\N	\N	8935189548
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2026-05-16 12:39:58.734097	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.33.0	\N	\N	8935189548
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-05-16 12:39:58.745283	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-05-16 12:39:58.749132	34	MARK_RAN	9:f9753208029f582525ed12011a19d054	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.33.0	\N	\N	8935189548
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-05-16 12:39:58.828655	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.33.0	\N	\N	8935189548
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2026-05-16 12:39:58.84986	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.33.0	\N	\N	8935189548
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-05-16 12:39:58.881386	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	8935189548
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2026-05-16 12:39:58.893492	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.33.0	\N	\N	8935189548
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2026-05-16 12:39:58.905388	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.33.0	\N	\N	8935189548
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2026-05-16 12:39:58.910614	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.33.0	\N	\N	8935189548
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2026-05-16 12:39:58.916089	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.33.0	\N	\N	8935189548
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2026-05-16 12:39:58.927429	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.33.0	\N	\N	8935189548
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2026-05-16 12:40:01.46897	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.33.0	\N	\N	8935189548
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2026-05-16 12:40:01.485873	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.33.0	\N	\N	8935189548
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-05-16 12:40:01.501117	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.33.0	\N	\N	8935189548
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-05-16 12:40:01.51307	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.33.0	\N	\N	8935189548
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-05-16 12:40:01.518972	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.33.0	\N	\N	8935189548
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-05-16 12:40:01.824283	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.33.0	\N	\N	8935189548
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-05-16 12:40:01.840352	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.33.0	\N	\N	8935189548
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2026-05-16 12:40:01.995669	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.33.0	\N	\N	8935189548
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2026-05-16 12:40:02.639684	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.33.0	\N	\N	8935189548
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2026-05-16 12:40:02.648432	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	8935189548
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2026-05-16 12:40:02.655522	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.33.0	\N	\N	8935189548
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2026-05-16 12:40:02.662608	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.33.0	\N	\N	8935189548
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-05-16 12:40:02.684587	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.33.0	\N	\N	8935189548
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-05-16 12:40:02.701057	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.33.0	\N	\N	8935189548
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-05-16 12:40:02.845694	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.33.0	\N	\N	8935189548
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-05-16 12:40:03.607309	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.33.0	\N	\N	8935189548
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2026-05-16 12:40:03.670129	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.33.0	\N	\N	8935189548
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2026-05-16 12:40:03.686397	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.33.0	\N	\N	8935189548
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2026-05-16 12:40:03.705983	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.33.0	\N	\N	8935189548
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2026-05-16 12:40:03.723472	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.33.0	\N	\N	8935189548
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2026-05-16 12:40:03.732314	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.33.0	\N	\N	8935189548
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2026-05-16 12:40:03.739724	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.33.0	\N	\N	8935189548
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2026-05-16 12:40:03.744933	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.33.0	\N	\N	8935189548
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2026-05-16 12:40:03.821025	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.33.0	\N	\N	8935189548
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2026-05-16 12:40:03.875195	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.33.0	\N	\N	8935189548
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2026-05-16 12:40:03.886948	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.33.0	\N	\N	8935189548
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2026-05-16 12:40:03.951265	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.33.0	\N	\N	8935189548
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2026-05-16 12:40:03.966857	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.33.0	\N	\N	8935189548
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2026-05-16 12:40:03.980948	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.33.0	\N	\N	8935189548
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-05-16 12:40:04.002912	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.33.0	\N	\N	8935189548
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-05-16 12:40:04.022691	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.33.0	\N	\N	8935189548
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-05-16 12:40:04.030952	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.33.0	\N	\N	8935189548
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-05-16 12:40:04.072737	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.33.0	\N	\N	8935189548
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-05-16 12:40:04.1602	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.33.0	\N	\N	8935189548
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-05-16 12:40:04.177594	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.33.0	\N	\N	8935189548
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-05-16 12:40:04.186311	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.33.0	\N	\N	8935189548
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-05-16 12:40:04.288504	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.33.0	\N	\N	8935189548
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-05-16 12:40:04.298481	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.33.0	\N	\N	8935189548
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-05-16 12:40:04.381251	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.33.0	\N	\N	8935189548
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-05-16 12:40:04.387279	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	8935189548
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-05-16 12:40:04.40052	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	8935189548
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-05-16 12:40:04.406615	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	8935189548
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-05-16 12:40:04.475365	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.33.0	\N	\N	8935189548
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2026-05-16 12:40:04.484062	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.33.0	\N	\N	8935189548
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2026-05-16 12:40:04.499607	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.33.0	\N	\N	8935189548
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2026-05-16 12:40:04.540208	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.33.0	\N	\N	8935189548
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-05-16 12:40:04.562486	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.33.0	\N	\N	8935189548
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-05-16 12:40:04.58072	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.33.0	\N	\N	8935189548
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-05-16 12:40:04.65838	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-05-16 12:40:04.672771	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.33.0	\N	\N	8935189548
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-05-16 12:40:04.676295	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.33.0	\N	\N	8935189548
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-05-16 12:40:04.695495	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.33.0	\N	\N	8935189548
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-05-16 12:40:04.701891	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.33.0	\N	\N	8935189548
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-05-16 12:40:04.721404	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.33.0	\N	\N	8935189548
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-05-16 12:40:04.915915	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-05-16 12:40:04.923171	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	8935189548
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-05-16 12:40:04.946572	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	8935189548
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-05-16 12:40:05.026148	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	8935189548
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-05-16 12:40:05.034524	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	8935189548
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-05-16 12:40:05.105965	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.33.0	\N	\N	8935189548
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-05-16 12:40:05.117118	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.33.0	\N	\N	8935189548
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2026-05-16 12:40:05.136191	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.33.0	\N	\N	8935189548
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2026-05-16 12:40:05.197844	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.33.0	\N	\N	8935189548
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2026-05-16 12:40:05.272281	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.33.0	\N	\N	8935189548
18.0.15-30992-index-consent	keycloak	META-INF/jpa-changelog-18.0.15.xml	2026-05-16 12:40:05.357276	107	EXECUTED	9:80071ede7a05604b1f4906f3bf3b00f0	createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE		\N	4.33.0	\N	\N	8935189548
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2026-05-16 12:40:05.370862	108	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.33.0	\N	\N	8935189548
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-05-16 12:40:05.444586	109	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.33.0	\N	\N	8935189548
20.0.0-12964-supported-dbs-edb-migration	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-05-16 12:40:05.510808	110	EXECUTED	9:a6b18a8e38062df5793edbe064f4aecd	dropIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE; createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.33.0	\N	\N	8935189548
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-05-16 12:40:05.514766	111	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.33.0	\N	\N	8935189548
client-attributes-string-accomodation-fixed-pre-drop-index	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-05-16 12:40:05.532121	112	EXECUTED	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	8935189548
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-05-16 12:40:05.553243	113	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	8935189548
client-attributes-string-accomodation-fixed-post-create-index	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-05-16 12:40:05.558394	114	MARK_RAN	9:bd2bd0fc7768cf0845ac96a8786fa735	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	8935189548
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2026-05-16 12:40:05.567754	115	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.33.0	\N	\N	8935189548
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2026-05-16 12:40:05.655616	116	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.33.0	\N	\N	8935189548
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2026-05-16 12:40:05.662573	117	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.33.0	\N	\N	8935189548
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2026-05-16 12:40:05.672722	118	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.33.0	\N	\N	8935189548
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2026-05-16 12:40:05.696051	120	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.33.0	\N	\N	8935189548
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2026-05-16 12:40:05.708988	121	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.33.0	\N	\N	8935189548
24.0.0-9758	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-05-16 12:40:05.958373	122	EXECUTED	9:502c557a5189f600f0f445a9b49ebbce	addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...		\N	4.33.0	\N	\N	8935189548
24.0.0-9758-2	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-05-16 12:40:05.964353	123	EXECUTED	9:bf0fdee10afdf597a987adbf291db7b2	customChange		\N	4.33.0	\N	\N	8935189548
24.0.0-26618-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-05-16 12:40:05.972965	124	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	8935189548
24.0.0-26618-reindex	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-05-16 12:40:06.04226	125	EXECUTED	9:08707c0f0db1cef6b352db03a60edc7f	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	8935189548
24.0.0-26618-edb-migration	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-05-16 12:40:06.112417	126	EXECUTED	9:2f684b29d414cd47efe3a3599f390741	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES; createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	8935189548
24.0.2-27228	keycloak	META-INF/jpa-changelog-24.0.2.xml	2026-05-16 12:40:06.12125	127	EXECUTED	9:eaee11f6b8aa25d2cc6a84fb86fc6238	customChange		\N	4.33.0	\N	\N	8935189548
24.0.2-27967-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.2.xml	2026-05-16 12:40:06.129675	128	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	8935189548
24.0.2-27967-reindex	keycloak	META-INF/jpa-changelog-24.0.2.xml	2026-05-16 12:40:06.136766	129	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	8935189548
25.0.0-28265-tables	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-05-16 12:40:06.151777	130	EXECUTED	9:deda2df035df23388af95bbd36c17cef	addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	8935189548
25.0.0-28265-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-05-16 12:40:06.213228	131	EXECUTED	9:3e96709818458ae49f3c679ae58d263a	createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
25.0.0-28265-index-cleanup-uss-createdon	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-05-16 12:40:06.254895	132	EXECUTED	9:78ab4fc129ed5e8265dbcc3485fba92f	dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
25.0.0-28265-index-cleanup-uss-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-05-16 12:40:06.31028	133	EXECUTED	9:de5f7c1f7e10994ed8b62e621d20eaab	dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
25.0.0-28265-index-cleanup-uss-by-usersess	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-05-16 12:40:06.329089	134	EXECUTED	9:6eee220d024e38e89c799417ec33667f	dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
25.0.0-28265-index-cleanup-css-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-05-16 12:40:06.349978	135	EXECUTED	9:5411d2fb2891d3e8d63ddb55dfa3c0c9	dropIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	8935189548
25.0.0-28265-index-2-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-05-16 12:40:06.353917	136	MARK_RAN	9:b7ef76036d3126bb83c2423bf4d449d6	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
25.0.0-28265-index-2-not-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-05-16 12:40:06.452095	137	EXECUTED	9:23396cf51ab8bc1ae6f0cac7f9f6fcf7	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
25.0.0-org	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-05-16 12:40:06.507986	138	EXECUTED	9:5c859965c2c9b9c72136c360649af157	createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN		\N	4.33.0	\N	\N	8935189548
unique-consentuser	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-05-16 12:40:06.53623	139	EXECUTED	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.33.0	\N	\N	8935189548
unique-consentuser-edb-migration	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-05-16 12:40:06.550197	140	MARK_RAN	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.33.0	\N	\N	8935189548
unique-consentuser-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-05-16 12:40:06.558185	141	MARK_RAN	9:b79478aad5adaa1bc428e31563f55e8e	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.33.0	\N	\N	8935189548
25.0.0-28861-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-05-16 12:40:06.68365	142	EXECUTED	9:b9acb58ac958d9ada0fe12a5d4794ab1	createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET		\N	4.33.0	\N	\N	8935189548
26.0.0-org-alias	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-05-16 12:40:06.705282	143	EXECUTED	9:6ef7d63e4412b3c2d66ed179159886a4	addColumn tableName=ORG; update tableName=ORG; addNotNullConstraint columnName=ALIAS, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_ALIAS, tableName=ORG		\N	4.33.0	\N	\N	8935189548
26.0.0-org-group	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-05-16 12:40:06.720938	144	EXECUTED	9:da8e8087d80ef2ace4f89d8c5b9ca223	addColumn tableName=KEYCLOAK_GROUP; update tableName=KEYCLOAK_GROUP; addNotNullConstraint columnName=TYPE, tableName=KEYCLOAK_GROUP; customChange		\N	4.33.0	\N	\N	8935189548
26.0.0-org-indexes	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-05-16 12:40:06.804023	145	EXECUTED	9:79b05dcd610a8c7f25ec05135eec0857	createIndex indexName=IDX_ORG_DOMAIN_ORG_ID, tableName=ORG_DOMAIN		\N	4.33.0	\N	\N	8935189548
26.0.0-org-group-membership	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-05-16 12:40:06.822483	146	EXECUTED	9:a6ace2ce583a421d89b01ba2a28dc2d4	addColumn tableName=USER_GROUP_MEMBERSHIP; update tableName=USER_GROUP_MEMBERSHIP; addNotNullConstraint columnName=MEMBERSHIP_TYPE, tableName=USER_GROUP_MEMBERSHIP		\N	4.33.0	\N	\N	8935189548
31296-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-05-16 12:40:06.845544	147	EXECUTED	9:64ef94489d42a358e8304b0e245f0ed4	createTable tableName=REVOKED_TOKEN; addPrimaryKey constraintName=CONSTRAINT_RT, tableName=REVOKED_TOKEN		\N	4.33.0	\N	\N	8935189548
31725-index-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-05-16 12:40:06.914334	148	EXECUTED	9:b994246ec2bf7c94da881e1d28782c7b	createIndex indexName=IDX_REV_TOKEN_ON_EXPIRE, tableName=REVOKED_TOKEN		\N	4.33.0	\N	\N	8935189548
26.0.0-idps-for-login	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-05-16 12:40:07.03092	149	EXECUTED	9:51f5fffadf986983d4bd59582c6c1604	addColumn tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_REALM_ORG, tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER; customChange		\N	4.33.0	\N	\N	8935189548
26.0.0-32583-drop-redundant-index-on-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-05-16 12:40:07.041265	150	EXECUTED	9:24972d83bf27317a055d234187bb4af9	dropIndex indexName=IDX_US_SESS_ID_ON_CL_SESS, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	8935189548
26.0.0.32582-remove-tables-user-session-user-session-note-and-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-05-16 12:40:07.061778	151	EXECUTED	9:febdc0f47f2ed241c59e60f58c3ceea5	dropTable tableName=CLIENT_SESSION_ROLE; dropTable tableName=CLIENT_SESSION_NOTE; dropTable tableName=CLIENT_SESSION_PROT_MAPPER; dropTable tableName=CLIENT_SESSION_AUTH_STATUS; dropTable tableName=CLIENT_USER_SESSION_NOTE; dropTable tableName=CLI...		\N	4.33.0	\N	\N	8935189548
26.0.0-33201-org-redirect-url	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-05-16 12:40:07.070884	152	EXECUTED	9:4d0e22b0ac68ebe9794fa9cb752ea660	addColumn tableName=ORG		\N	4.33.0	\N	\N	8935189548
29399-jdbc-ping-default	keycloak	META-INF/jpa-changelog-26.1.0.xml	2026-05-16 12:40:07.12825	153	EXECUTED	9:007dbe99d7203fca403b89d4edfdf21e	createTable tableName=JGROUPS_PING; addPrimaryKey constraintName=CONSTRAINT_JGROUPS_PING, tableName=JGROUPS_PING		\N	4.33.0	\N	\N	8935189548
26.1.0-34013	keycloak	META-INF/jpa-changelog-26.1.0.xml	2026-05-16 12:40:07.143146	154	EXECUTED	9:e6b686a15759aef99a6d758a5c4c6a26	addColumn tableName=ADMIN_EVENT_ENTITY		\N	4.33.0	\N	\N	8935189548
26.1.0-34380	keycloak	META-INF/jpa-changelog-26.1.0.xml	2026-05-16 12:40:07.15398	155	EXECUTED	9:ac8b9edb7c2b6c17a1c7a11fcf5ccf01	dropTable tableName=USERNAME_LOGIN_FAILURE		\N	4.33.0	\N	\N	8935189548
26.2.0-36750	keycloak	META-INF/jpa-changelog-26.2.0.xml	2026-05-16 12:40:07.200672	156	EXECUTED	9:b49ce951c22f7eb16480ff085640a33a	createTable tableName=SERVER_CONFIG		\N	4.33.0	\N	\N	8935189548
26.2.0-26106	keycloak	META-INF/jpa-changelog-26.2.0.xml	2026-05-16 12:40:07.211422	157	EXECUTED	9:b5877d5dab7d10ff3a9d209d7beb6680	addColumn tableName=CREDENTIAL		\N	4.33.0	\N	\N	8935189548
26.2.6-39866-duplicate	keycloak	META-INF/jpa-changelog-26.2.6.xml	2026-05-16 12:40:07.220631	158	EXECUTED	9:1dc67ccee24f30331db2cba4f372e40e	customChange		\N	4.33.0	\N	\N	8935189548
26.2.6-39866-uk	keycloak	META-INF/jpa-changelog-26.2.6.xml	2026-05-16 12:40:07.243938	159	EXECUTED	9:b70b76f47210cf0a5f4ef0e219eac7cd	addUniqueConstraint constraintName=UK_MIGRATION_VERSION, tableName=MIGRATION_MODEL		\N	4.33.0	\N	\N	8935189548
26.2.6-40088-duplicate	keycloak	META-INF/jpa-changelog-26.2.6.xml	2026-05-16 12:40:07.253266	160	EXECUTED	9:cc7e02ed69ab31979afb1982f9670e8f	customChange		\N	4.33.0	\N	\N	8935189548
26.2.6-40088-uk	keycloak	META-INF/jpa-changelog-26.2.6.xml	2026-05-16 12:40:07.267511	161	EXECUTED	9:5bb848128da7bc4595cc507383325241	addUniqueConstraint constraintName=UK_MIGRATION_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.33.0	\N	\N	8935189548
26.3.0-groups-description	keycloak	META-INF/jpa-changelog-26.3.0.xml	2026-05-16 12:40:07.284906	162	EXECUTED	9:e1a3c05574326fb5b246b73b9a4c4d49	addColumn tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	8935189548
26.4.0-40933-saml-encryption-attributes	keycloak	META-INF/jpa-changelog-26.4.0.xml	2026-05-16 12:40:07.296248	163	EXECUTED	9:7e9eaba362ca105efdda202303a4fe49	customChange		\N	4.33.0	\N	\N	8935189548
26.4.0-51321	keycloak	META-INF/jpa-changelog-26.4.0.xml	2026-05-16 12:40:07.374519	164	EXECUTED	9:34bab2bc56f75ffd7e347c580874e306	createIndex indexName=IDX_EVENT_ENTITY_USER_ID_TYPE, tableName=EVENT_ENTITY		\N	4.33.0	\N	\N	8935189548
40343-workflow-state-table	keycloak	META-INF/jpa-changelog-26.4.0.xml	2026-05-16 12:40:07.505815	165	EXECUTED	9:ed3ab4723ceed210e5b5e60ac4562106	createTable tableName=WORKFLOW_STATE; addPrimaryKey constraintName=PK_WORKFLOW_STATE, tableName=WORKFLOW_STATE; addUniqueConstraint constraintName=UQ_WORKFLOW_RESOURCE, tableName=WORKFLOW_STATE; createIndex indexName=IDX_WORKFLOW_STATE_STEP, table...		\N	4.33.0	\N	\N	8935189548
26.5.0-index-offline-css-by-client	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-05-16 12:40:07.5681	166	EXECUTED	9:383e981ce95d16e32af757b7998820f7	createIndex indexName=IDX_OFFLINE_CSS_BY_CLIENT, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	8935189548
26.5.0-index-offline-css-by-client-storage-provider	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-05-16 12:40:07.644465	167	EXECUTED	9:f5bc200e6fa7d7e483854dee535ca425	createIndex indexName=IDX_OFFLINE_CSS_BY_CLIENT_STORAGE_PROVIDER, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	8935189548
26.5.0-idp-config-allow-null-fixed-drop-mssql-index	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-05-16 12:40:07.648667	168	MARK_RAN	9:50c51d2c98cd1d624eb1c485c3cf1f75	dropIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER		\N	4.33.0	\N	\N	8935189548
26.5.0-idp-config-allow-null	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-05-16 12:40:07.665228	169	EXECUTED	9:b667fb087874303b324c1af7fae4f606	dropDefaultValue columnName=TRUST_EMAIL, tableName=IDENTITY_PROVIDER; dropNotNullConstraint columnName=TRUST_EMAIL, tableName=IDENTITY_PROVIDER; dropNotNullConstraint columnName=STORE_TOKEN, tableName=IDENTITY_PROVIDER; dropDefaultValue columnName...		\N	4.33.0	\N	\N	8935189548
26.5.0-idp-config-allow-null-fixed-create-mssql-index	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-05-16 12:40:07.668827	170	MARK_RAN	9:dcbbb24c151c3b0b59f12fede23cc94d	createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER		\N	4.33.0	\N	\N	8935189548
26.5.0-remove-workflow-provider-id-column	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-05-16 12:40:07.730872	171	EXECUTED	9:d8eeb324484d45e946d03b953e168b21	dropIndex indexName=IDX_WORKFLOW_STATE_PROVIDER, tableName=WORKFLOW_STATE; createIndex indexName=IDX_WORKFLOW_STATE_PROVIDER, tableName=WORKFLOW_STATE; dropColumn columnName=WORKFLOW_PROVIDER_ID, tableName=WORKFLOW_STATE		\N	4.33.0	\N	\N	8935189548
26.5.0-add-remember-me	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-05-16 12:40:07.739864	172	EXECUTED	9:a7273ea8b21bd2f674c9c49141999f05	addColumn tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
26.5.0-add-sess-refresh-idx	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-05-16 12:40:07.809698	173	EXECUTED	9:ce49383d317ccbcd3434d1f21172b0b7	createIndex indexName=IDX_USER_SESSION_EXPIRATION_CREATED, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
26.5.0-add-sess-create-idx	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-05-16 12:40:07.887485	174	EXECUTED	9:aaee09e23a4d8468fbc5c51b7b314c58	createIndex indexName=IDX_USER_SESSION_EXPIRATION_LAST_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
26.5.0-drop-sess-refresh-idx	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-05-16 12:40:07.903553	175	EXECUTED	9:f0082210b6ccbbaf81287c27aa23753c	dropIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	8935189548
26.5.0-mysql-mariadb-default-charset-collation	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-05-16 12:40:07.912752	176	MARK_RAN	9:1b383fa60d2db0a8952b365e725f9d16	customChange		\N	4.33.0	\N	\N	8935189548
26.5.0-invitations-table-fixed2	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-05-16 12:40:08.1033	177	EXECUTED	9:322cb11fc03181903dcd67a54f8b3cf0	createTable tableName=ORG_INVITATION; addForeignKeyConstraint baseTableName=ORG_INVITATION, constraintName=FK_ORG_INVITATION_ORG, referencedTableName=ORG; createIndex indexName=IDX_ORG_INVITATION_ORG_ID, tableName=ORG_INVITATION; createIndex index...		\N	4.33.0	\N	\N	8935189548
26.6.0-45009-broker-link-user-id	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-05-16 12:40:08.178837	178	EXECUTED	9:05026bbbc8d2ead5afcbda2f5fdf3a2b	createIndex indexName=IDX_BROKER_LINK_USER_ID, tableName=BROKER_LINK		\N	4.33.0	\N	\N	8935189548
26.6.0-45009-broker-link-identity-provider	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-05-16 12:40:08.259659	179	EXECUTED	9:7d9a0253c9de7be754efef8bba4265bd	createIndex indexName=IDX_BROKER_LINK_IDENTITY_PROVIDER, tableName=BROKER_LINK		\N	4.33.0	\N	\N	8935189548
26.6.0-org-group-relationship	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-05-16 12:40:08.327267	180	EXECUTED	9:05685853fba030f53548ac6bf23245e3	addColumn tableName=KEYCLOAK_GROUP; addForeignKeyConstraint baseTableName=KEYCLOAK_GROUP, constraintName=FK_GROUP_ORGANIZATION, referencedTableName=ORG; createIndex indexName=IDX_GROUP_ORG_ID, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	8935189548
26.6.0-44424-index-css-user-session-and-offline	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-05-16 12:40:08.385786	181	EXECUTED	9:a704d8598df241a3fd3cb91b6ab4b2d4	createIndex indexName=IDX_OFFLINE_CSS_BY_USER_SESSION_AND_OFFLINE, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	8935189548
26.6.0-44424-create-realm-in-client-session	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-05-16 12:40:08.399596	182	EXECUTED	9:77dbbc72d943e98cfe472ba8cc56a31c	addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	8935189548
26.6.0-44424-set-realm-in-client-session	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-05-16 12:40:08.407412	183	EXECUTED	9:3964a3148d32a55ef81126e23cdf6721	customChange		\N	4.33.0	\N	\N	8935189548
26.6.0-44424-idx-css-realm-and-clients	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-05-16 12:40:08.486487	184	EXECUTED	9:a093877fff41185ac24103be80e00968	createIndex indexName=IDX_OFFLINE_CSS_BY_CLIENT_AND_REALM, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	8935189548
26.6.0-add-last-modified-timestamp-user	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-05-16 12:40:08.498569	185	EXECUTED	9:8aa583d2cdd9e913dff42fecd626c560	addColumn tableName=USER_ENTITY		\N	4.33.0	\N	\N	8935189548
26.6.0-add-timestamps-group	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-05-16 12:40:08.513574	186	EXECUTED	9:4363d45dc25105a3fc5db9ff6936b0a9	addColumn tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	8935189548
26.6.0-43829-user-created-timestamp-index	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-05-16 12:40:08.596332	187	EXECUTED	9:f2531a49b8bb21a7a97966d88fd1a411	createIndex indexName=IDX_USER_CREATED_TIMESTAMP, tableName=USER_ENTITY		\N	4.33.0	\N	\N	8935189548
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
266e0ee5-a56b-4faf-89f4-02c5567093d1	cb7039ff-d699-4ac8-8637-77b2014dd78e	f
266e0ee5-a56b-4faf-89f4-02c5567093d1	d18178b4-7c29-41ff-939a-21a4cf302f93	t
266e0ee5-a56b-4faf-89f4-02c5567093d1	10bbd390-375f-4a3a-93db-9d70ce8baf60	t
266e0ee5-a56b-4faf-89f4-02c5567093d1	efb0d74d-738c-491a-8248-0c775e921e35	t
266e0ee5-a56b-4faf-89f4-02c5567093d1	d9f0ec48-a61a-4b8b-af6d-e8c55ef61320	t
266e0ee5-a56b-4faf-89f4-02c5567093d1	182b9b02-e111-4344-b25a-dbc703d8be36	f
266e0ee5-a56b-4faf-89f4-02c5567093d1	4058f2fa-2216-456b-acf6-44ffe1268764	f
266e0ee5-a56b-4faf-89f4-02c5567093d1	1f893991-b6b7-4f02-9509-3b8b081629d5	t
266e0ee5-a56b-4faf-89f4-02c5567093d1	b862c517-f8ac-42d0-b616-9118946ff2a4	t
266e0ee5-a56b-4faf-89f4-02c5567093d1	a0873344-f21b-4924-881e-1726af8b7f46	f
266e0ee5-a56b-4faf-89f4-02c5567093d1	bcf89bf0-2104-44d2-b702-af32316be728	t
266e0ee5-a56b-4faf-89f4-02c5567093d1	d5599a2c-05aa-4e11-a037-c060cb6b415b	t
266e0ee5-a56b-4faf-89f4-02c5567093d1	bbe47bbc-2a27-4774-ac84-94ff3e296a21	f
14468de3-0b67-44ab-a988-6565b42d2e10	957b6caf-6a8a-4b30-b9f2-e7254fb91c1c	t
14468de3-0b67-44ab-a988-6565b42d2e10	b1d3ebb9-433d-4c96-b9b2-2d20be61c3bc	t
14468de3-0b67-44ab-a988-6565b42d2e10	e4ddddba-2368-4235-88c7-8817584ee8e3	t
14468de3-0b67-44ab-a988-6565b42d2e10	d71bb4a5-1f58-423d-85ec-c5f364886bf4	t
14468de3-0b67-44ab-a988-6565b42d2e10	9f382c08-97d9-4676-9133-840e0403ad82	t
14468de3-0b67-44ab-a988-6565b42d2e10	cfcb4050-685e-48ac-859d-fe4699a1fdba	t
14468de3-0b67-44ab-a988-6565b42d2e10	20199fd2-a00f-4315-8d28-a9592ae0de58	t
14468de3-0b67-44ab-a988-6565b42d2e10	8bc3ea3b-b0d9-4320-a683-c603e87dd0b1	t
14468de3-0b67-44ab-a988-6565b42d2e10	65571631-4197-4b5e-ba18-2cf894a4622d	f
14468de3-0b67-44ab-a988-6565b42d2e10	c851ee29-11a9-4a0a-980e-43e6862ab51b	f
14468de3-0b67-44ab-a988-6565b42d2e10	a13456b8-6e7e-4360-9e17-912cb932f988	f
14468de3-0b67-44ab-a988-6565b42d2e10	785411aa-b95a-4da2-b30a-59caed9117d5	f
14468de3-0b67-44ab-a988-6565b42d2e10	1ae35d46-6a5f-439a-ae48-cf86a8195d7f	f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only, organization_id, hide_on_login) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: jgroups_ping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.jgroups_ping (address, name, cluster_name, ip, coord) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_group (id, name, parent_group, realm_id, type, description, org_id, created_timestamp, last_modified_timestamp) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
29fe7f1f-24bc-4ffc-a3b7-8f7899d8638a	266e0ee5-a56b-4faf-89f4-02c5567093d1	f	${role_default-roles}	default-roles-master	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N	\N
42068a11-3d4f-4f94-aea1-920bf463f22c	266e0ee5-a56b-4faf-89f4-02c5567093d1	f	${role_create-realm}	create-realm	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N	\N
7b40d8d5-434b-4884-ae83-4afd3a15d34d	266e0ee5-a56b-4faf-89f4-02c5567093d1	f	${role_admin}	admin	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N	\N
fb7b964d-4dd5-443d-8393-07881758a422	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_create-client}	create-client	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
7efd5d73-17e2-48d6-a621-86c84548ade1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_view-realm}	view-realm	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
ad8c65c1-e9ea-41b0-a64c-15f67ef3a7bf	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_view-users}	view-users	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
bb497a78-9bef-4c0d-84c2-1de042dc9902	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_view-clients}	view-clients	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
5c2ea366-4970-40ac-a5bc-6616cbfb62c1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_view-events}	view-events	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
7797a4a8-b84c-4797-bec4-a78b94815297	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_view-identity-providers}	view-identity-providers	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
2bf916f5-e75d-49cc-ac80-4b275e8f8008	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_view-authorization}	view-authorization	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
6fde2777-47ef-4b70-8739-98e73ec784ef	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_manage-realm}	manage-realm	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
2ebff3ab-ed84-47bb-a621-48ad78004400	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_manage-users}	manage-users	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
f82b5852-08d0-474e-8319-18524a660d19	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_manage-clients}	manage-clients	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
8282088e-5839-4910-bce2-6d44c40cbeaf	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_manage-events}	manage-events	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
4a027d71-1a4c-434d-8456-d763c830b93b	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_manage-identity-providers}	manage-identity-providers	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
4ff5dd30-ce21-4685-ad4b-543996cd0f17	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_manage-authorization}	manage-authorization	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
4aaeea63-ac38-4cb5-a497-8d74cb0ed2ab	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_query-users}	query-users	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
496a2d9e-0b43-483a-a503-3f7c085d741e	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_query-clients}	query-clients	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
6b324e2d-3a22-4d90-b171-d95a40b0035d	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_query-realms}	query-realms	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
ab990b31-e663-498b-b7c2-1189681ba0b8	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_query-groups}	query-groups	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
4cf7e150-3c60-462a-a7eb-a915fa280a96	d0a046e1-427e-4a16-9bf1-8e6da31572bd	t	${role_view-profile}	view-profile	266e0ee5-a56b-4faf-89f4-02c5567093d1	d0a046e1-427e-4a16-9bf1-8e6da31572bd	\N
59e9a4f2-be59-471c-a717-c7cad87561ce	d0a046e1-427e-4a16-9bf1-8e6da31572bd	t	${role_manage-account}	manage-account	266e0ee5-a56b-4faf-89f4-02c5567093d1	d0a046e1-427e-4a16-9bf1-8e6da31572bd	\N
5354ddaf-b195-48e3-a33b-76c17fca2001	d0a046e1-427e-4a16-9bf1-8e6da31572bd	t	${role_manage-account-links}	manage-account-links	266e0ee5-a56b-4faf-89f4-02c5567093d1	d0a046e1-427e-4a16-9bf1-8e6da31572bd	\N
8d214bc2-f647-4b45-95ec-276d54914767	d0a046e1-427e-4a16-9bf1-8e6da31572bd	t	${role_view-applications}	view-applications	266e0ee5-a56b-4faf-89f4-02c5567093d1	d0a046e1-427e-4a16-9bf1-8e6da31572bd	\N
ab5540d6-19cf-4632-b5a7-387ebac99b06	d0a046e1-427e-4a16-9bf1-8e6da31572bd	t	${role_view-consent}	view-consent	266e0ee5-a56b-4faf-89f4-02c5567093d1	d0a046e1-427e-4a16-9bf1-8e6da31572bd	\N
5ca52fe2-dbd2-42f0-a1c9-d9e61b582123	d0a046e1-427e-4a16-9bf1-8e6da31572bd	t	${role_manage-consent}	manage-consent	266e0ee5-a56b-4faf-89f4-02c5567093d1	d0a046e1-427e-4a16-9bf1-8e6da31572bd	\N
eb3e37ca-1e15-4c26-8d34-90336fd1205e	d0a046e1-427e-4a16-9bf1-8e6da31572bd	t	${role_view-groups}	view-groups	266e0ee5-a56b-4faf-89f4-02c5567093d1	d0a046e1-427e-4a16-9bf1-8e6da31572bd	\N
1893f0d4-ee14-4654-8edc-ed550327d24b	d0a046e1-427e-4a16-9bf1-8e6da31572bd	t	${role_delete-account}	delete-account	266e0ee5-a56b-4faf-89f4-02c5567093d1	d0a046e1-427e-4a16-9bf1-8e6da31572bd	\N
d65e0e0c-de3a-4df9-84cd-2a6f42c53fcc	70b0ab56-1c02-4185-9288-7ea85b30e65b	t	${role_read-token}	read-token	266e0ee5-a56b-4faf-89f4-02c5567093d1	70b0ab56-1c02-4185-9288-7ea85b30e65b	\N
5723c8e8-e8d4-4341-ac97-4b28d5530d3b	fe1a2e3c-5060-4662-a935-5d5655e3ac08	t	${role_impersonation}	impersonation	266e0ee5-a56b-4faf-89f4-02c5567093d1	fe1a2e3c-5060-4662-a935-5d5655e3ac08	\N
1c5c520a-20bd-4b6b-88d6-82d301c9dd42	266e0ee5-a56b-4faf-89f4-02c5567093d1	f	${role_offline-access}	offline_access	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N	\N
8e7fc856-aa37-4dad-bd96-ae8dd469b836	266e0ee5-a56b-4faf-89f4-02c5567093d1	f	${role_uma_authorization}	uma_authorization	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N	\N
8a3b9be4-a634-4772-aef7-e5947104a3e1	14468de3-0b67-44ab-a988-6565b42d2e10	f	${role_default-roles}	default-roles-tp2	14468de3-0b67-44ab-a988-6565b42d2e10	\N	\N
98a79390-1373-4028-b22a-f4beee8530e6	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_create-client}	create-client	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
cac2dba9-8348-44d3-85f1-3b3af577d891	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_view-realm}	view-realm	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
07afc6ce-4bff-43e1-b0af-a875468d5242	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_view-users}	view-users	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
62bd8825-292b-40e5-a33c-369450dd6fa9	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_view-clients}	view-clients	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
c333ecb4-fa64-4b67-abcf-3f9718496f23	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_view-events}	view-events	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
3377524f-ec81-4752-ab1a-6c0edc438cb7	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_view-identity-providers}	view-identity-providers	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
24c9afe4-9289-4087-a633-7d087e24aa47	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_view-authorization}	view-authorization	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
9633d151-3099-438d-a4b6-8390bef0e657	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_manage-realm}	manage-realm	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
ca5974d0-2c0a-42e4-8c9f-3c531e06ac43	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_manage-users}	manage-users	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
c673f92e-42d2-4561-a13b-7aefc1ab0fea	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_manage-clients}	manage-clients	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
cd4e0079-f3ed-44ce-a465-d54029197b75	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_manage-events}	manage-events	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
b804c393-7880-4d38-9f65-09fe76abf140	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_manage-identity-providers}	manage-identity-providers	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
5a07baeb-584b-467c-83e2-890b78e0f5ce	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_manage-authorization}	manage-authorization	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
d2541de7-cde3-449f-8476-7450a016d9c5	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_query-users}	query-users	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
09e2bdfb-5dca-4da5-9890-00f48841186d	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_query-clients}	query-clients	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
041b2395-257a-43c4-ade8-2e929fa96130	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_query-realms}	query-realms	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
b357b230-26d7-4028-882b-f67a011a8a9c	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_query-groups}	query-groups	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
4fee6c90-ed20-4009-be67-b4ef7aa89c76	14468de3-0b67-44ab-a988-6565b42d2e10	f	${role_offline-access}	offline_access	14468de3-0b67-44ab-a988-6565b42d2e10	\N	\N
8da79ecc-01f0-4f83-baa0-9ec0faa3cbf7	14468de3-0b67-44ab-a988-6565b42d2e10	f		USER	14468de3-0b67-44ab-a988-6565b42d2e10	\N	\N
351e6d3d-662b-4d66-835d-702a224f2b91	14468de3-0b67-44ab-a988-6565b42d2e10	f	${role_uma_authorization}	uma_authorization	14468de3-0b67-44ab-a988-6565b42d2e10	\N	\N
00140e1d-95ac-4337-9b06-9933de47304a	14468de3-0b67-44ab-a988-6565b42d2e10	f		ADM	14468de3-0b67-44ab-a988-6565b42d2e10	\N	\N
e263c824-0992-4b17-b089-ca3cbe9fbdb8	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_view-identity-providers}	view-identity-providers	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
aa911fe7-d6ba-46c3-a7e7-57511d40f41e	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_view-users}	view-users	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
20547e78-a702-47b9-9ce7-c607e60deb02	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_query-groups}	query-groups	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
ef0cb7f8-9e5e-4707-9eae-77816f9e228f	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_realm-admin}	realm-admin	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
67928a8d-489f-415e-aba9-ce370cb05b3a	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_manage-authorization}	manage-authorization	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
bf57b233-eb02-4d19-978e-f00c1abdb688	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_query-users}	query-users	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
ad5ccd6b-4e02-42b4-bc23-c58a12840034	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_manage-realm}	manage-realm	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
a8821c59-092e-4a7e-b41a-cccb9084fc15	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_view-events}	view-events	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
79299d8e-a149-493d-8d7d-b12930c567f9	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_create-client}	create-client	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
d1ed1cb6-1ef8-4b0c-9ad1-45f8782576ce	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_manage-users}	manage-users	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
5e04c2cd-6e4c-4096-922e-7d2eed46528b	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_manage-events}	manage-events	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
7903c869-4860-4990-94d9-e866c3d6fe4d	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_query-clients}	query-clients	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
5bc83cec-fc4c-438a-93b3-5a6e479c9446	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_manage-identity-providers}	manage-identity-providers	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
817dd8c0-065e-43ee-ae50-be467525da87	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_manage-clients}	manage-clients	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
cff97677-c06a-4d14-8e53-df1620a33dc4	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_query-realms}	query-realms	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
d68b4881-ea5e-4a36-bb8c-d4021af9dc9a	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_impersonation}	impersonation	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
01d34f26-0726-49a6-ab0f-8ff234539fd1	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_view-realm}	view-realm	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
168828ed-a6c4-4704-98cd-bd4704a2d354	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_view-authorization}	view-authorization	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
ac58e36c-cffc-42d0-a7cf-282f424ea043	93eef193-1f2c-41ad-97c3-61454ea1c87a	t	${role_view-clients}	view-clients	14468de3-0b67-44ab-a988-6565b42d2e10	93eef193-1f2c-41ad-97c3-61454ea1c87a	\N
c5799110-16c7-45e4-81e9-7b402958c08b	c0474998-cebc-48b9-b387-d72b0cc776db	t		realm-admin	14468de3-0b67-44ab-a988-6565b42d2e10	c0474998-cebc-48b9-b387-d72b0cc776db	\N
8b015e33-d9b3-4f57-8cc7-ebea84b6c857	21cea034-65f6-4724-9b50-2d2d0b2165fa	t	${role_read-token}	read-token	14468de3-0b67-44ab-a988-6565b42d2e10	21cea034-65f6-4724-9b50-2d2d0b2165fa	\N
076f7f68-3024-485a-a3d6-281d3e2c1a9a	75061a78-e9fa-4f5e-b792-aa249d94d9b2	t	${role_view-consent}	view-consent	14468de3-0b67-44ab-a988-6565b42d2e10	75061a78-e9fa-4f5e-b792-aa249d94d9b2	\N
f10a90da-a607-4502-83c0-fb3266810a50	75061a78-e9fa-4f5e-b792-aa249d94d9b2	t	${role_view-profile}	view-profile	14468de3-0b67-44ab-a988-6565b42d2e10	75061a78-e9fa-4f5e-b792-aa249d94d9b2	\N
2d24a11f-8222-4fb4-9d07-e545737768b9	75061a78-e9fa-4f5e-b792-aa249d94d9b2	t	${role_view-groups}	view-groups	14468de3-0b67-44ab-a988-6565b42d2e10	75061a78-e9fa-4f5e-b792-aa249d94d9b2	\N
4f99fd77-abf9-467e-aacb-c9ceb1eafde7	75061a78-e9fa-4f5e-b792-aa249d94d9b2	t	${role_manage-consent}	manage-consent	14468de3-0b67-44ab-a988-6565b42d2e10	75061a78-e9fa-4f5e-b792-aa249d94d9b2	\N
ece19bad-841b-409e-ae6c-752e2dd062a4	75061a78-e9fa-4f5e-b792-aa249d94d9b2	t	${role_manage-account-links}	manage-account-links	14468de3-0b67-44ab-a988-6565b42d2e10	75061a78-e9fa-4f5e-b792-aa249d94d9b2	\N
08747b62-4459-4937-ba27-318557d4c823	75061a78-e9fa-4f5e-b792-aa249d94d9b2	t	${role_delete-account}	delete-account	14468de3-0b67-44ab-a988-6565b42d2e10	75061a78-e9fa-4f5e-b792-aa249d94d9b2	\N
c47cf8f5-55fd-4f03-b4d7-bcc140328e14	75061a78-e9fa-4f5e-b792-aa249d94d9b2	t	${role_manage-account}	manage-account	14468de3-0b67-44ab-a988-6565b42d2e10	75061a78-e9fa-4f5e-b792-aa249d94d9b2	\N
6c35cf7f-935a-4cc3-8a9a-fd4f8e0391aa	75061a78-e9fa-4f5e-b792-aa249d94d9b2	t	${role_view-applications}	view-applications	14468de3-0b67-44ab-a988-6565b42d2e10	75061a78-e9fa-4f5e-b792-aa249d94d9b2	\N
d8033681-8077-494a-b621-ef42557c9a70	b1017ee6-dea2-4077-8adb-69e681cd685c	t	${role_impersonation}	impersonation	266e0ee5-a56b-4faf-89f4-02c5567093d1	b1017ee6-dea2-4077-8adb-69e681cd685c	\N
cb9b3268-1c83-419a-b412-4c80c35baa2e	266e0ee5-a56b-4faf-89f4-02c5567093d1	f		ADM	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N	\N
b96764af-c9ea-4e48-b1ef-372f5d213730	266e0ee5-a56b-4faf-89f4-02c5567093d1	f		USER	266e0ee5-a56b-4faf-89f4-02c5567093d1	\N	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.migration_model (id, version, update_time) FROM stdin;
n5kqe	26.6.1	1778935215
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id, version, realm_id) FROM stdin;
nyoPvm4Mk4prEYkfQXeJ58Qd	c0474998-cebc-48b9-b387-d72b0cc776db	0	1778966444	{"authMethod":"openid-connect","notes":{"clientId":"c0474998-cebc-48b9-b387-d72b0cc776db","userSessionStartedAt":"1778966444","iss":"http://localhost:8080/realms/TP2","startedAt":"1778966444","level-of-authentication":"-1"}}	local	local	0	14468de3-0b67-44ab-a988-6565b42d2e10
NWBxJR5IFWt2wNYbs1l9Q6UA	c0474998-cebc-48b9-b387-d72b0cc776db	0	1778966928	{"authMethod":"openid-connect","notes":{"clientId":"c0474998-cebc-48b9-b387-d72b0cc776db","userSessionStartedAt":"1778966928","iss":"http://localhost:8080/realms/TP2","startedAt":"1778966928","level-of-authentication":"-1"}}	local	local	0	14468de3-0b67-44ab-a988-6565b42d2e10
WeW8_e55iZtOYMme0WuTDXop	c0474998-cebc-48b9-b387-d72b0cc776db	0	1778965007	{"authMethod":"openid-connect","notes":{"clientId":"c0474998-cebc-48b9-b387-d72b0cc776db","userSessionStartedAt":"1778965007","iss":"http://localhost:8080/realms/TP2","startedAt":"1778965007","level-of-authentication":"-1"}}	local	local	0	14468de3-0b67-44ab-a988-6565b42d2e10
nAq2oXtamwYuTtsUYfHffkbM	c0474998-cebc-48b9-b387-d72b0cc776db	0	1778965443	{"authMethod":"openid-connect","notes":{"clientId":"c0474998-cebc-48b9-b387-d72b0cc776db","userSessionStartedAt":"1778965443","iss":"http://localhost:8080/realms/TP2","startedAt":"1778965443","level-of-authentication":"-1"}}	local	local	0	14468de3-0b67-44ab-a988-6565b42d2e10
MIQ4Cu1pcRdcBnvzj0PCS3Os	c0474998-cebc-48b9-b387-d72b0cc776db	0	1778965849	{"authMethod":"openid-connect","notes":{"clientId":"c0474998-cebc-48b9-b387-d72b0cc776db","userSessionStartedAt":"1778965849","iss":"http://localhost:8080/realms/TP2","startedAt":"1778965849","level-of-authentication":"-1"}}	local	local	0	14468de3-0b67-44ab-a988-6565b42d2e10
9sz0LstSuYGuSWacQfRb05fa	c0474998-cebc-48b9-b387-d72b0cc776db	0	1778965949	{"authMethod":"openid-connect","notes":{"clientId":"c0474998-cebc-48b9-b387-d72b0cc776db","userSessionStartedAt":"1778965949","iss":"http://localhost:8080/realms/TP2","startedAt":"1778965949","level-of-authentication":"-1"}}	local	local	0	14468de3-0b67-44ab-a988-6565b42d2e10
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh, broker_session_id, version, remember_me) FROM stdin;
WeW8_e55iZtOYMme0WuTDXop	e6633081-cf68-408c-ba9f-4b756d4c1a93	14468de3-0b67-44ab-a988-6565b42d2e10	1778965007	0	{"ipAddress":"172.19.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTkuMC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiQ2hyb21lLzE0OC4wLjAiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","authenticators-completed":"{\\"93e09def-24e8-4f18-9495-2989817b39ce\\":1778965007,\\"f4235931-e982-4e89-b6d2-abe3bd99aa73\\":1778965007}"},"state":"LOGGED_IN"}	1778965007	\N	0	f
nAq2oXtamwYuTtsUYfHffkbM	e6633081-cf68-408c-ba9f-4b756d4c1a93	14468de3-0b67-44ab-a988-6565b42d2e10	1778965443	0	{"ipAddress":"172.19.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTkuMC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiQ2hyb21lLzE0OC4wLjAiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","authenticators-completed":"{\\"93e09def-24e8-4f18-9495-2989817b39ce\\":1778965443,\\"f4235931-e982-4e89-b6d2-abe3bd99aa73\\":1778965443}"},"state":"LOGGED_IN"}	1778965443	\N	0	f
MIQ4Cu1pcRdcBnvzj0PCS3Os	e6633081-cf68-408c-ba9f-4b756d4c1a93	14468de3-0b67-44ab-a988-6565b42d2e10	1778965849	0	{"ipAddress":"172.19.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTkuMC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiQ2hyb21lLzE0OC4wLjAiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","authenticators-completed":"{\\"93e09def-24e8-4f18-9495-2989817b39ce\\":1778965849,\\"f4235931-e982-4e89-b6d2-abe3bd99aa73\\":1778965849}"},"state":"LOGGED_IN"}	1778965849	\N	0	f
9sz0LstSuYGuSWacQfRb05fa	e6633081-cf68-408c-ba9f-4b756d4c1a93	14468de3-0b67-44ab-a988-6565b42d2e10	1778965949	0	{"ipAddress":"172.19.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTkuMC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiQ2hyb21lLzE0OC4wLjAiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","authenticators-completed":"{\\"93e09def-24e8-4f18-9495-2989817b39ce\\":1778965949,\\"f4235931-e982-4e89-b6d2-abe3bd99aa73\\":1778965949}"},"state":"LOGGED_IN"}	1778965949	\N	0	f
nyoPvm4Mk4prEYkfQXeJ58Qd	e6633081-cf68-408c-ba9f-4b756d4c1a93	14468de3-0b67-44ab-a988-6565b42d2e10	1778966444	0	{"ipAddress":"172.19.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTkuMC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiQ2hyb21lLzE0OC4wLjAiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","authenticators-completed":"{\\"93e09def-24e8-4f18-9495-2989817b39ce\\":1778966444,\\"f4235931-e982-4e89-b6d2-abe3bd99aa73\\":1778966444}"},"state":"LOGGED_IN"}	1778966444	\N	0	f
NWBxJR5IFWt2wNYbs1l9Q6UA	e6633081-cf68-408c-ba9f-4b756d4c1a93	14468de3-0b67-44ab-a988-6565b42d2e10	1778966928	0	{"ipAddress":"172.19.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTkuMC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiQ2hyb21lLzE0OC4wLjAiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","authenticators-completed":"{\\"93e09def-24e8-4f18-9495-2989817b39ce\\":1778966928,\\"f4235931-e982-4e89-b6d2-abe3bd99aa73\\":1778966928}"},"state":"LOGGED_IN"}	1778966928	\N	0	f
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.org (id, enabled, realm_id, group_id, name, description, alias, redirect_url) FROM stdin;
\.


--
-- Data for Name: org_domain; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.org_domain (id, name, verified, org_id) FROM stdin;
\.


--
-- Data for Name: org_invitation; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.org_invitation (id, organization_id, email, first_name, last_name, created_at, expires_at, invite_link) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
63c1d6ba-3e13-4f57-8728-cd4ee0344b96	audience resolve	openid-connect	oidc-audience-resolve-mapper	139e3b65-55d2-41c8-95be-45bb7b554d46	\N
e40e345d-7656-4d29-9281-d5ee671702c7	locale	openid-connect	oidc-usermodel-attribute-mapper	c5424ef9-8012-4f99-b4ad-e8456f980f8c	\N
6464cc04-5da8-4ca0-9074-d08c03639d69	role list	saml	saml-role-list-mapper	\N	d18178b4-7c29-41ff-939a-21a4cf302f93
c479957d-ea31-46b0-bad1-2b6fac4f4e1c	organization	saml	saml-organization-membership-mapper	\N	10bbd390-375f-4a3a-93db-9d70ce8baf60
78b2aac9-9da4-46a8-a0de-39c377497da8	full name	openid-connect	oidc-full-name-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
8263bb7f-f5cb-44dc-871c-409be8843cfc	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
d2d821bc-44b9-460c-9d48-48c8ea918db4	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
8c371b9b-e7ad-4ab7-b1d4-57d9b56344f7	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
e9d65b6e-bfda-49ca-8105-48ec791a1765	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
3a7ec46b-b125-44b9-ae4a-92c81d361868	username	openid-connect	oidc-usermodel-attribute-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
90fe9f86-c973-4f1b-93b1-5b6475966a16	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
6f8054fa-be1b-4c02-8a6d-23482b691940	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
1a37e049-d8d9-4d1a-ac00-57f31a31d99c	website	openid-connect	oidc-usermodel-attribute-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
ef8ea625-62c2-4566-8d73-77be2d395696	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
c6d86e95-5618-4d33-9f4e-985971cf2ab2	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
27fa0576-7c7c-49f8-843e-c8b7122c023d	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
f0623de9-e1d0-4c49-a17b-13decf37d49c	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
e8cf8263-e05b-48d6-8edb-72c517c43c4c	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	efb0d74d-738c-491a-8248-0c775e921e35
a103f8b8-3395-4d4b-9bd7-7731d0de00a7	email	openid-connect	oidc-usermodel-attribute-mapper	\N	d9f0ec48-a61a-4b8b-af6d-e8c55ef61320
db24cb70-038e-4738-be2b-8c730d788a66	email verified	openid-connect	oidc-usermodel-property-mapper	\N	d9f0ec48-a61a-4b8b-af6d-e8c55ef61320
dd561d28-b896-4379-b469-214f1335e709	address	openid-connect	oidc-address-mapper	\N	182b9b02-e111-4344-b25a-dbc703d8be36
e5611644-9639-4501-9b5d-ac59ede4397c	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	4058f2fa-2216-456b-acf6-44ffe1268764
0da04bb9-f1f7-4036-b45b-c105547862f4	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	4058f2fa-2216-456b-acf6-44ffe1268764
bac559ea-0c5c-4c3c-b70f-ed9fec0f613e	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	1f893991-b6b7-4f02-9509-3b8b081629d5
03ee2eef-0338-47ee-8807-b09be8c4c2a9	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	1f893991-b6b7-4f02-9509-3b8b081629d5
fcf980e1-a0b6-4780-a9fc-67a679c23fc1	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	1f893991-b6b7-4f02-9509-3b8b081629d5
1871ac7c-4090-4841-a164-0855e65c2059	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	b862c517-f8ac-42d0-b616-9118946ff2a4
f854d54b-fb7b-4588-a7d2-f4d9c5283e6d	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	a0873344-f21b-4924-881e-1726af8b7f46
8a4506ab-30d6-44af-8e67-6018ea544d23	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	a0873344-f21b-4924-881e-1726af8b7f46
dbe64f6a-0e49-47d1-833e-56990598f4a5	acr loa level	openid-connect	oidc-acr-mapper	\N	bcf89bf0-2104-44d2-b702-af32316be728
0187aefb-ae1c-4f9c-80e0-72c24dc09b1d	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	d5599a2c-05aa-4e11-a037-c060cb6b415b
d1c6dc8c-747e-4509-aa1d-6b170c122c2b	sub	openid-connect	oidc-sub-mapper	\N	d5599a2c-05aa-4e11-a037-c060cb6b415b
974d7d50-d3c9-4ba4-867b-a771d242d993	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	\N	554d322d-511d-4de6-8f97-d1d0d96b6a7e
3bc16019-fb41-4dd9-9548-8cefef870c56	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	\N	554d322d-511d-4de6-8f97-d1d0d96b6a7e
80b7958e-15cc-4f5e-877a-8ba827899751	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	\N	554d322d-511d-4de6-8f97-d1d0d96b6a7e
bcebe724-d138-4f69-b255-1f2ec4ccf2fb	organization	openid-connect	oidc-organization-membership-mapper	\N	bbe47bbc-2a27-4774-ac84-94ff3e296a21
e5e61a35-1cea-45c8-871f-5b9d8ada39e3	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
999f4b98-9ff5-4cd8-8e3f-568c62095db0	full name	openid-connect	oidc-full-name-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
0a5cb653-e929-42fd-85e5-b94efb579cbd	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
7a832b13-8b1b-4533-8d64-3c3b23bb58b2	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
848ffd33-4ca5-4cd4-ae8a-99a44d3ffe76	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
fd95fe70-8a73-4817-80f0-614ded92193a	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
0bf42d4c-5251-4c20-b76d-99437eb7b709	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
b7f62e90-df6c-429e-889c-27c7b38c0475	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
41fce873-8dab-499f-bd8f-c56d2e192b68	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
3757c25d-2790-47b1-9af6-4ac9060173f3	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
beec59d8-aab9-469f-8e72-612efca0d5da	username	openid-connect	oidc-usermodel-attribute-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
1649e17b-1e7b-4d0b-876f-1f170baead37	website	openid-connect	oidc-usermodel-attribute-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
3c57da44-17dc-44dc-9efb-6ec0637bbbe8	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
cef0d884-c9f2-4536-bbca-e8da3f8e74bb	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	e4ddddba-2368-4235-88c7-8817584ee8e3
78708d3b-8dd0-410b-83cf-869a216d63e2	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	9f382c08-97d9-4676-9133-840e0403ad82
dfa81b93-8424-4d5c-8d0a-091bab765b6a	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	9f382c08-97d9-4676-9133-840e0403ad82
d5ce86ac-9194-4243-a109-5504dbe5384a	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	9f382c08-97d9-4676-9133-840e0403ad82
61d9b714-ed19-4750-bb78-af3045541ef8	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	8bc3ea3b-b0d9-4320-a683-c603e87dd0b1
359fad8c-0453-421a-ad56-b4e810fc3ebf	sub	openid-connect	oidc-sub-mapper	\N	8bc3ea3b-b0d9-4320-a683-c603e87dd0b1
f013e795-bd3e-4e07-a78b-0464b2c3ee6e	acr loa level	openid-connect	oidc-acr-mapper	\N	20199fd2-a00f-4315-8d28-a9592ae0de58
bc38d752-459a-46b1-8370-3b4b19982e1d	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	785411aa-b95a-4da2-b30a-59caed9117d5
ed3f1501-822b-4cf3-85bb-2e8105a41e03	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	785411aa-b95a-4da2-b30a-59caed9117d5
ae3930b5-4c26-445f-87a6-003e659ff384	address	openid-connect	oidc-address-mapper	\N	c851ee29-11a9-4a0a-980e-43e6862ab51b
30cb07ec-7542-45e6-beec-2c7892687abc	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	cfcb4050-685e-48ac-859d-fe4699a1fdba
28aa9826-b8cc-4cd1-820b-9a15d91b1f98	email	openid-connect	oidc-usermodel-attribute-mapper	\N	d71bb4a5-1f58-423d-85ec-c5f364886bf4
68eaa05a-b55f-45b0-9019-2257f2992ea2	email verified	openid-connect	oidc-usermodel-property-mapper	\N	d71bb4a5-1f58-423d-85ec-c5f364886bf4
70d625af-faae-41fb-b79c-98d6970463d3	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	a13456b8-6e7e-4360-9e17-912cb932f988
252642e6-6d1a-4da0-a7da-5326d92dca1f	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	a13456b8-6e7e-4360-9e17-912cb932f988
9473f3a7-0b98-42f1-9ae4-e737f0d107b2	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	\N	c179a1e5-bca1-4219-9415-78dafb575ba9
6f353f19-a35c-4862-8dd5-d93b53e96441	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	\N	c179a1e5-bca1-4219-9415-78dafb575ba9
8dc0cba5-2c7f-47bc-afcc-9192d60cb77e	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	\N	c179a1e5-bca1-4219-9415-78dafb575ba9
62f0dd79-696f-41db-83a2-5648ebb2ce48	organization	openid-connect	oidc-organization-membership-mapper	\N	1ae35d46-6a5f-439a-ae48-cf86a8195d7f
27da002d-9967-4f41-bb3d-5dd400d183e0	role list	saml	saml-role-list-mapper	\N	957b6caf-6a8a-4b30-b9f2-e7254fb91c1c
d7c655aa-10a3-4f16-9d44-d66daf7bd43f	organization	saml	saml-organization-membership-mapper	\N	b1d3ebb9-433d-4c96-b9b2-2d20be61c3bc
6a3214bd-2977-4f67-9bb6-5fa20f0b984c	audience resolve	openid-connect	oidc-audience-resolve-mapper	7f184a64-7758-4108-9017-05ec9db69fc2	\N
fc778a7b-0ed2-4b9b-8893-c8265dd4281f	locale	openid-connect	oidc-usermodel-attribute-mapper	6c422063-458c-4c28-a3e7-0c7febd3489d	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
e40e345d-7656-4d29-9281-d5ee671702c7	true	introspection.token.claim
e40e345d-7656-4d29-9281-d5ee671702c7	true	userinfo.token.claim
e40e345d-7656-4d29-9281-d5ee671702c7	locale	user.attribute
e40e345d-7656-4d29-9281-d5ee671702c7	true	id.token.claim
e40e345d-7656-4d29-9281-d5ee671702c7	true	access.token.claim
e40e345d-7656-4d29-9281-d5ee671702c7	locale	claim.name
e40e345d-7656-4d29-9281-d5ee671702c7	String	jsonType.label
6464cc04-5da8-4ca0-9074-d08c03639d69	false	single
6464cc04-5da8-4ca0-9074-d08c03639d69	Basic	attribute.nameformat
6464cc04-5da8-4ca0-9074-d08c03639d69	Role	attribute.name
1a37e049-d8d9-4d1a-ac00-57f31a31d99c	true	introspection.token.claim
1a37e049-d8d9-4d1a-ac00-57f31a31d99c	true	userinfo.token.claim
1a37e049-d8d9-4d1a-ac00-57f31a31d99c	website	user.attribute
1a37e049-d8d9-4d1a-ac00-57f31a31d99c	true	id.token.claim
1a37e049-d8d9-4d1a-ac00-57f31a31d99c	true	access.token.claim
1a37e049-d8d9-4d1a-ac00-57f31a31d99c	website	claim.name
1a37e049-d8d9-4d1a-ac00-57f31a31d99c	String	jsonType.label
27fa0576-7c7c-49f8-843e-c8b7122c023d	true	introspection.token.claim
27fa0576-7c7c-49f8-843e-c8b7122c023d	true	userinfo.token.claim
27fa0576-7c7c-49f8-843e-c8b7122c023d	zoneinfo	user.attribute
27fa0576-7c7c-49f8-843e-c8b7122c023d	true	id.token.claim
27fa0576-7c7c-49f8-843e-c8b7122c023d	true	access.token.claim
27fa0576-7c7c-49f8-843e-c8b7122c023d	zoneinfo	claim.name
27fa0576-7c7c-49f8-843e-c8b7122c023d	String	jsonType.label
3a7ec46b-b125-44b9-ae4a-92c81d361868	true	introspection.token.claim
3a7ec46b-b125-44b9-ae4a-92c81d361868	true	userinfo.token.claim
3a7ec46b-b125-44b9-ae4a-92c81d361868	username	user.attribute
3a7ec46b-b125-44b9-ae4a-92c81d361868	true	id.token.claim
3a7ec46b-b125-44b9-ae4a-92c81d361868	true	access.token.claim
3a7ec46b-b125-44b9-ae4a-92c81d361868	preferred_username	claim.name
3a7ec46b-b125-44b9-ae4a-92c81d361868	String	jsonType.label
6f8054fa-be1b-4c02-8a6d-23482b691940	true	introspection.token.claim
6f8054fa-be1b-4c02-8a6d-23482b691940	true	userinfo.token.claim
6f8054fa-be1b-4c02-8a6d-23482b691940	picture	user.attribute
6f8054fa-be1b-4c02-8a6d-23482b691940	true	id.token.claim
6f8054fa-be1b-4c02-8a6d-23482b691940	true	access.token.claim
6f8054fa-be1b-4c02-8a6d-23482b691940	picture	claim.name
6f8054fa-be1b-4c02-8a6d-23482b691940	String	jsonType.label
78b2aac9-9da4-46a8-a0de-39c377497da8	true	introspection.token.claim
78b2aac9-9da4-46a8-a0de-39c377497da8	true	userinfo.token.claim
78b2aac9-9da4-46a8-a0de-39c377497da8	true	id.token.claim
78b2aac9-9da4-46a8-a0de-39c377497da8	true	access.token.claim
8263bb7f-f5cb-44dc-871c-409be8843cfc	true	introspection.token.claim
8263bb7f-f5cb-44dc-871c-409be8843cfc	true	userinfo.token.claim
8263bb7f-f5cb-44dc-871c-409be8843cfc	lastName	user.attribute
8263bb7f-f5cb-44dc-871c-409be8843cfc	true	id.token.claim
8263bb7f-f5cb-44dc-871c-409be8843cfc	true	access.token.claim
8263bb7f-f5cb-44dc-871c-409be8843cfc	family_name	claim.name
8263bb7f-f5cb-44dc-871c-409be8843cfc	String	jsonType.label
8c371b9b-e7ad-4ab7-b1d4-57d9b56344f7	true	introspection.token.claim
8c371b9b-e7ad-4ab7-b1d4-57d9b56344f7	true	userinfo.token.claim
8c371b9b-e7ad-4ab7-b1d4-57d9b56344f7	middleName	user.attribute
8c371b9b-e7ad-4ab7-b1d4-57d9b56344f7	true	id.token.claim
8c371b9b-e7ad-4ab7-b1d4-57d9b56344f7	true	access.token.claim
8c371b9b-e7ad-4ab7-b1d4-57d9b56344f7	middle_name	claim.name
8c371b9b-e7ad-4ab7-b1d4-57d9b56344f7	String	jsonType.label
90fe9f86-c973-4f1b-93b1-5b6475966a16	true	introspection.token.claim
90fe9f86-c973-4f1b-93b1-5b6475966a16	true	userinfo.token.claim
90fe9f86-c973-4f1b-93b1-5b6475966a16	profile	user.attribute
90fe9f86-c973-4f1b-93b1-5b6475966a16	true	id.token.claim
90fe9f86-c973-4f1b-93b1-5b6475966a16	true	access.token.claim
90fe9f86-c973-4f1b-93b1-5b6475966a16	profile	claim.name
90fe9f86-c973-4f1b-93b1-5b6475966a16	String	jsonType.label
c6d86e95-5618-4d33-9f4e-985971cf2ab2	true	introspection.token.claim
c6d86e95-5618-4d33-9f4e-985971cf2ab2	true	userinfo.token.claim
c6d86e95-5618-4d33-9f4e-985971cf2ab2	birthdate	user.attribute
c6d86e95-5618-4d33-9f4e-985971cf2ab2	true	id.token.claim
c6d86e95-5618-4d33-9f4e-985971cf2ab2	true	access.token.claim
c6d86e95-5618-4d33-9f4e-985971cf2ab2	birthdate	claim.name
c6d86e95-5618-4d33-9f4e-985971cf2ab2	String	jsonType.label
d2d821bc-44b9-460c-9d48-48c8ea918db4	true	introspection.token.claim
d2d821bc-44b9-460c-9d48-48c8ea918db4	true	userinfo.token.claim
d2d821bc-44b9-460c-9d48-48c8ea918db4	firstName	user.attribute
d2d821bc-44b9-460c-9d48-48c8ea918db4	true	id.token.claim
d2d821bc-44b9-460c-9d48-48c8ea918db4	true	access.token.claim
d2d821bc-44b9-460c-9d48-48c8ea918db4	given_name	claim.name
d2d821bc-44b9-460c-9d48-48c8ea918db4	String	jsonType.label
e8cf8263-e05b-48d6-8edb-72c517c43c4c	true	introspection.token.claim
e8cf8263-e05b-48d6-8edb-72c517c43c4c	true	userinfo.token.claim
e8cf8263-e05b-48d6-8edb-72c517c43c4c	updatedAt	user.attribute
e8cf8263-e05b-48d6-8edb-72c517c43c4c	true	id.token.claim
e8cf8263-e05b-48d6-8edb-72c517c43c4c	true	access.token.claim
e8cf8263-e05b-48d6-8edb-72c517c43c4c	updated_at	claim.name
e8cf8263-e05b-48d6-8edb-72c517c43c4c	long	jsonType.label
e9d65b6e-bfda-49ca-8105-48ec791a1765	true	introspection.token.claim
e9d65b6e-bfda-49ca-8105-48ec791a1765	true	userinfo.token.claim
e9d65b6e-bfda-49ca-8105-48ec791a1765	nickname	user.attribute
e9d65b6e-bfda-49ca-8105-48ec791a1765	true	id.token.claim
e9d65b6e-bfda-49ca-8105-48ec791a1765	true	access.token.claim
e9d65b6e-bfda-49ca-8105-48ec791a1765	nickname	claim.name
e9d65b6e-bfda-49ca-8105-48ec791a1765	String	jsonType.label
ef8ea625-62c2-4566-8d73-77be2d395696	true	introspection.token.claim
ef8ea625-62c2-4566-8d73-77be2d395696	true	userinfo.token.claim
ef8ea625-62c2-4566-8d73-77be2d395696	gender	user.attribute
ef8ea625-62c2-4566-8d73-77be2d395696	true	id.token.claim
ef8ea625-62c2-4566-8d73-77be2d395696	true	access.token.claim
ef8ea625-62c2-4566-8d73-77be2d395696	gender	claim.name
ef8ea625-62c2-4566-8d73-77be2d395696	String	jsonType.label
f0623de9-e1d0-4c49-a17b-13decf37d49c	true	introspection.token.claim
f0623de9-e1d0-4c49-a17b-13decf37d49c	true	userinfo.token.claim
f0623de9-e1d0-4c49-a17b-13decf37d49c	locale	user.attribute
f0623de9-e1d0-4c49-a17b-13decf37d49c	true	id.token.claim
f0623de9-e1d0-4c49-a17b-13decf37d49c	true	access.token.claim
f0623de9-e1d0-4c49-a17b-13decf37d49c	locale	claim.name
f0623de9-e1d0-4c49-a17b-13decf37d49c	String	jsonType.label
a103f8b8-3395-4d4b-9bd7-7731d0de00a7	true	introspection.token.claim
a103f8b8-3395-4d4b-9bd7-7731d0de00a7	true	userinfo.token.claim
a103f8b8-3395-4d4b-9bd7-7731d0de00a7	email	user.attribute
a103f8b8-3395-4d4b-9bd7-7731d0de00a7	true	id.token.claim
a103f8b8-3395-4d4b-9bd7-7731d0de00a7	true	access.token.claim
a103f8b8-3395-4d4b-9bd7-7731d0de00a7	email	claim.name
a103f8b8-3395-4d4b-9bd7-7731d0de00a7	String	jsonType.label
db24cb70-038e-4738-be2b-8c730d788a66	true	introspection.token.claim
db24cb70-038e-4738-be2b-8c730d788a66	true	userinfo.token.claim
db24cb70-038e-4738-be2b-8c730d788a66	emailVerified	user.attribute
db24cb70-038e-4738-be2b-8c730d788a66	true	id.token.claim
db24cb70-038e-4738-be2b-8c730d788a66	true	access.token.claim
db24cb70-038e-4738-be2b-8c730d788a66	email_verified	claim.name
db24cb70-038e-4738-be2b-8c730d788a66	boolean	jsonType.label
dd561d28-b896-4379-b469-214f1335e709	formatted	user.attribute.formatted
dd561d28-b896-4379-b469-214f1335e709	country	user.attribute.country
dd561d28-b896-4379-b469-214f1335e709	true	introspection.token.claim
dd561d28-b896-4379-b469-214f1335e709	postal_code	user.attribute.postal_code
dd561d28-b896-4379-b469-214f1335e709	true	userinfo.token.claim
dd561d28-b896-4379-b469-214f1335e709	street	user.attribute.street
dd561d28-b896-4379-b469-214f1335e709	true	id.token.claim
dd561d28-b896-4379-b469-214f1335e709	region	user.attribute.region
dd561d28-b896-4379-b469-214f1335e709	true	access.token.claim
dd561d28-b896-4379-b469-214f1335e709	locality	user.attribute.locality
0da04bb9-f1f7-4036-b45b-c105547862f4	true	introspection.token.claim
0da04bb9-f1f7-4036-b45b-c105547862f4	true	userinfo.token.claim
0da04bb9-f1f7-4036-b45b-c105547862f4	phoneNumberVerified	user.attribute
0da04bb9-f1f7-4036-b45b-c105547862f4	true	id.token.claim
0da04bb9-f1f7-4036-b45b-c105547862f4	true	access.token.claim
0da04bb9-f1f7-4036-b45b-c105547862f4	phone_number_verified	claim.name
0da04bb9-f1f7-4036-b45b-c105547862f4	boolean	jsonType.label
e5611644-9639-4501-9b5d-ac59ede4397c	true	introspection.token.claim
e5611644-9639-4501-9b5d-ac59ede4397c	true	userinfo.token.claim
e5611644-9639-4501-9b5d-ac59ede4397c	phoneNumber	user.attribute
e5611644-9639-4501-9b5d-ac59ede4397c	true	id.token.claim
e5611644-9639-4501-9b5d-ac59ede4397c	true	access.token.claim
e5611644-9639-4501-9b5d-ac59ede4397c	phone_number	claim.name
e5611644-9639-4501-9b5d-ac59ede4397c	String	jsonType.label
03ee2eef-0338-47ee-8807-b09be8c4c2a9	true	introspection.token.claim
03ee2eef-0338-47ee-8807-b09be8c4c2a9	true	multivalued
03ee2eef-0338-47ee-8807-b09be8c4c2a9	foo	user.attribute
03ee2eef-0338-47ee-8807-b09be8c4c2a9	true	access.token.claim
03ee2eef-0338-47ee-8807-b09be8c4c2a9	resource_access.${client_id}.roles	claim.name
03ee2eef-0338-47ee-8807-b09be8c4c2a9	String	jsonType.label
bac559ea-0c5c-4c3c-b70f-ed9fec0f613e	true	introspection.token.claim
bac559ea-0c5c-4c3c-b70f-ed9fec0f613e	true	multivalued
bac559ea-0c5c-4c3c-b70f-ed9fec0f613e	foo	user.attribute
bac559ea-0c5c-4c3c-b70f-ed9fec0f613e	true	access.token.claim
bac559ea-0c5c-4c3c-b70f-ed9fec0f613e	realm_access.roles	claim.name
bac559ea-0c5c-4c3c-b70f-ed9fec0f613e	String	jsonType.label
fcf980e1-a0b6-4780-a9fc-67a679c23fc1	true	introspection.token.claim
fcf980e1-a0b6-4780-a9fc-67a679c23fc1	true	access.token.claim
1871ac7c-4090-4841-a164-0855e65c2059	true	introspection.token.claim
1871ac7c-4090-4841-a164-0855e65c2059	true	access.token.claim
8a4506ab-30d6-44af-8e67-6018ea544d23	true	introspection.token.claim
8a4506ab-30d6-44af-8e67-6018ea544d23	true	multivalued
8a4506ab-30d6-44af-8e67-6018ea544d23	foo	user.attribute
8a4506ab-30d6-44af-8e67-6018ea544d23	true	id.token.claim
8a4506ab-30d6-44af-8e67-6018ea544d23	true	access.token.claim
8a4506ab-30d6-44af-8e67-6018ea544d23	groups	claim.name
8a4506ab-30d6-44af-8e67-6018ea544d23	String	jsonType.label
f854d54b-fb7b-4588-a7d2-f4d9c5283e6d	true	introspection.token.claim
f854d54b-fb7b-4588-a7d2-f4d9c5283e6d	true	userinfo.token.claim
f854d54b-fb7b-4588-a7d2-f4d9c5283e6d	username	user.attribute
f854d54b-fb7b-4588-a7d2-f4d9c5283e6d	true	id.token.claim
f854d54b-fb7b-4588-a7d2-f4d9c5283e6d	true	access.token.claim
f854d54b-fb7b-4588-a7d2-f4d9c5283e6d	upn	claim.name
f854d54b-fb7b-4588-a7d2-f4d9c5283e6d	String	jsonType.label
dbe64f6a-0e49-47d1-833e-56990598f4a5	true	introspection.token.claim
dbe64f6a-0e49-47d1-833e-56990598f4a5	true	id.token.claim
dbe64f6a-0e49-47d1-833e-56990598f4a5	true	access.token.claim
0187aefb-ae1c-4f9c-80e0-72c24dc09b1d	AUTH_TIME	user.session.note
0187aefb-ae1c-4f9c-80e0-72c24dc09b1d	true	introspection.token.claim
0187aefb-ae1c-4f9c-80e0-72c24dc09b1d	true	id.token.claim
0187aefb-ae1c-4f9c-80e0-72c24dc09b1d	true	access.token.claim
0187aefb-ae1c-4f9c-80e0-72c24dc09b1d	auth_time	claim.name
0187aefb-ae1c-4f9c-80e0-72c24dc09b1d	long	jsonType.label
d1c6dc8c-747e-4509-aa1d-6b170c122c2b	true	introspection.token.claim
d1c6dc8c-747e-4509-aa1d-6b170c122c2b	true	access.token.claim
3bc16019-fb41-4dd9-9548-8cefef870c56	clientHost	user.session.note
3bc16019-fb41-4dd9-9548-8cefef870c56	true	introspection.token.claim
3bc16019-fb41-4dd9-9548-8cefef870c56	true	id.token.claim
3bc16019-fb41-4dd9-9548-8cefef870c56	true	access.token.claim
3bc16019-fb41-4dd9-9548-8cefef870c56	clientHost	claim.name
3bc16019-fb41-4dd9-9548-8cefef870c56	String	jsonType.label
80b7958e-15cc-4f5e-877a-8ba827899751	clientAddress	user.session.note
80b7958e-15cc-4f5e-877a-8ba827899751	true	introspection.token.claim
80b7958e-15cc-4f5e-877a-8ba827899751	true	id.token.claim
80b7958e-15cc-4f5e-877a-8ba827899751	true	access.token.claim
80b7958e-15cc-4f5e-877a-8ba827899751	clientAddress	claim.name
80b7958e-15cc-4f5e-877a-8ba827899751	String	jsonType.label
974d7d50-d3c9-4ba4-867b-a771d242d993	client_id	user.session.note
974d7d50-d3c9-4ba4-867b-a771d242d993	true	introspection.token.claim
974d7d50-d3c9-4ba4-867b-a771d242d993	true	id.token.claim
974d7d50-d3c9-4ba4-867b-a771d242d993	true	access.token.claim
974d7d50-d3c9-4ba4-867b-a771d242d993	client_id	claim.name
974d7d50-d3c9-4ba4-867b-a771d242d993	String	jsonType.label
bcebe724-d138-4f69-b255-1f2ec4ccf2fb	true	introspection.token.claim
bcebe724-d138-4f69-b255-1f2ec4ccf2fb	true	multivalued
bcebe724-d138-4f69-b255-1f2ec4ccf2fb	true	id.token.claim
bcebe724-d138-4f69-b255-1f2ec4ccf2fb	true	access.token.claim
bcebe724-d138-4f69-b255-1f2ec4ccf2fb	organization	claim.name
bcebe724-d138-4f69-b255-1f2ec4ccf2fb	String	jsonType.label
0a5cb653-e929-42fd-85e5-b94efb579cbd	true	introspection.token.claim
0a5cb653-e929-42fd-85e5-b94efb579cbd	true	userinfo.token.claim
0a5cb653-e929-42fd-85e5-b94efb579cbd	lastName	user.attribute
0a5cb653-e929-42fd-85e5-b94efb579cbd	true	id.token.claim
0a5cb653-e929-42fd-85e5-b94efb579cbd	true	access.token.claim
0a5cb653-e929-42fd-85e5-b94efb579cbd	family_name	claim.name
0a5cb653-e929-42fd-85e5-b94efb579cbd	String	jsonType.label
0bf42d4c-5251-4c20-b76d-99437eb7b709	true	introspection.token.claim
0bf42d4c-5251-4c20-b76d-99437eb7b709	true	userinfo.token.claim
0bf42d4c-5251-4c20-b76d-99437eb7b709	zoneinfo	user.attribute
0bf42d4c-5251-4c20-b76d-99437eb7b709	true	id.token.claim
0bf42d4c-5251-4c20-b76d-99437eb7b709	true	access.token.claim
0bf42d4c-5251-4c20-b76d-99437eb7b709	zoneinfo	claim.name
0bf42d4c-5251-4c20-b76d-99437eb7b709	String	jsonType.label
1649e17b-1e7b-4d0b-876f-1f170baead37	true	introspection.token.claim
1649e17b-1e7b-4d0b-876f-1f170baead37	true	userinfo.token.claim
1649e17b-1e7b-4d0b-876f-1f170baead37	website	user.attribute
1649e17b-1e7b-4d0b-876f-1f170baead37	true	id.token.claim
1649e17b-1e7b-4d0b-876f-1f170baead37	true	access.token.claim
1649e17b-1e7b-4d0b-876f-1f170baead37	website	claim.name
1649e17b-1e7b-4d0b-876f-1f170baead37	String	jsonType.label
3757c25d-2790-47b1-9af6-4ac9060173f3	true	introspection.token.claim
3757c25d-2790-47b1-9af6-4ac9060173f3	true	userinfo.token.claim
3757c25d-2790-47b1-9af6-4ac9060173f3	gender	user.attribute
3757c25d-2790-47b1-9af6-4ac9060173f3	true	id.token.claim
3757c25d-2790-47b1-9af6-4ac9060173f3	true	access.token.claim
3757c25d-2790-47b1-9af6-4ac9060173f3	gender	claim.name
3757c25d-2790-47b1-9af6-4ac9060173f3	String	jsonType.label
3c57da44-17dc-44dc-9efb-6ec0637bbbe8	true	introspection.token.claim
3c57da44-17dc-44dc-9efb-6ec0637bbbe8	true	userinfo.token.claim
3c57da44-17dc-44dc-9efb-6ec0637bbbe8	firstName	user.attribute
3c57da44-17dc-44dc-9efb-6ec0637bbbe8	true	id.token.claim
3c57da44-17dc-44dc-9efb-6ec0637bbbe8	true	access.token.claim
3c57da44-17dc-44dc-9efb-6ec0637bbbe8	given_name	claim.name
3c57da44-17dc-44dc-9efb-6ec0637bbbe8	String	jsonType.label
41fce873-8dab-499f-bd8f-c56d2e192b68	true	introspection.token.claim
41fce873-8dab-499f-bd8f-c56d2e192b68	true	userinfo.token.claim
41fce873-8dab-499f-bd8f-c56d2e192b68	nickname	user.attribute
41fce873-8dab-499f-bd8f-c56d2e192b68	true	id.token.claim
41fce873-8dab-499f-bd8f-c56d2e192b68	true	access.token.claim
41fce873-8dab-499f-bd8f-c56d2e192b68	nickname	claim.name
41fce873-8dab-499f-bd8f-c56d2e192b68	String	jsonType.label
7a832b13-8b1b-4533-8d64-3c3b23bb58b2	true	introspection.token.claim
7a832b13-8b1b-4533-8d64-3c3b23bb58b2	true	userinfo.token.claim
7a832b13-8b1b-4533-8d64-3c3b23bb58b2	picture	user.attribute
7a832b13-8b1b-4533-8d64-3c3b23bb58b2	true	id.token.claim
7a832b13-8b1b-4533-8d64-3c3b23bb58b2	true	access.token.claim
7a832b13-8b1b-4533-8d64-3c3b23bb58b2	picture	claim.name
7a832b13-8b1b-4533-8d64-3c3b23bb58b2	String	jsonType.label
848ffd33-4ca5-4cd4-ae8a-99a44d3ffe76	true	introspection.token.claim
848ffd33-4ca5-4cd4-ae8a-99a44d3ffe76	true	userinfo.token.claim
848ffd33-4ca5-4cd4-ae8a-99a44d3ffe76	locale	user.attribute
848ffd33-4ca5-4cd4-ae8a-99a44d3ffe76	true	id.token.claim
848ffd33-4ca5-4cd4-ae8a-99a44d3ffe76	true	access.token.claim
848ffd33-4ca5-4cd4-ae8a-99a44d3ffe76	locale	claim.name
848ffd33-4ca5-4cd4-ae8a-99a44d3ffe76	String	jsonType.label
999f4b98-9ff5-4cd8-8e3f-568c62095db0	true	id.token.claim
999f4b98-9ff5-4cd8-8e3f-568c62095db0	true	introspection.token.claim
999f4b98-9ff5-4cd8-8e3f-568c62095db0	true	access.token.claim
999f4b98-9ff5-4cd8-8e3f-568c62095db0	true	userinfo.token.claim
b7f62e90-df6c-429e-889c-27c7b38c0475	true	introspection.token.claim
b7f62e90-df6c-429e-889c-27c7b38c0475	true	userinfo.token.claim
b7f62e90-df6c-429e-889c-27c7b38c0475	middleName	user.attribute
b7f62e90-df6c-429e-889c-27c7b38c0475	true	id.token.claim
b7f62e90-df6c-429e-889c-27c7b38c0475	true	access.token.claim
b7f62e90-df6c-429e-889c-27c7b38c0475	middle_name	claim.name
b7f62e90-df6c-429e-889c-27c7b38c0475	String	jsonType.label
beec59d8-aab9-469f-8e72-612efca0d5da	true	introspection.token.claim
beec59d8-aab9-469f-8e72-612efca0d5da	true	userinfo.token.claim
beec59d8-aab9-469f-8e72-612efca0d5da	username	user.attribute
beec59d8-aab9-469f-8e72-612efca0d5da	true	id.token.claim
beec59d8-aab9-469f-8e72-612efca0d5da	true	access.token.claim
beec59d8-aab9-469f-8e72-612efca0d5da	preferred_username	claim.name
beec59d8-aab9-469f-8e72-612efca0d5da	String	jsonType.label
cef0d884-c9f2-4536-bbca-e8da3f8e74bb	true	introspection.token.claim
cef0d884-c9f2-4536-bbca-e8da3f8e74bb	true	userinfo.token.claim
cef0d884-c9f2-4536-bbca-e8da3f8e74bb	birthdate	user.attribute
cef0d884-c9f2-4536-bbca-e8da3f8e74bb	true	id.token.claim
cef0d884-c9f2-4536-bbca-e8da3f8e74bb	true	access.token.claim
cef0d884-c9f2-4536-bbca-e8da3f8e74bb	birthdate	claim.name
cef0d884-c9f2-4536-bbca-e8da3f8e74bb	String	jsonType.label
e5e61a35-1cea-45c8-871f-5b9d8ada39e3	true	introspection.token.claim
e5e61a35-1cea-45c8-871f-5b9d8ada39e3	true	userinfo.token.claim
e5e61a35-1cea-45c8-871f-5b9d8ada39e3	updatedAt	user.attribute
e5e61a35-1cea-45c8-871f-5b9d8ada39e3	true	id.token.claim
e5e61a35-1cea-45c8-871f-5b9d8ada39e3	true	access.token.claim
e5e61a35-1cea-45c8-871f-5b9d8ada39e3	updated_at	claim.name
e5e61a35-1cea-45c8-871f-5b9d8ada39e3	long	jsonType.label
fd95fe70-8a73-4817-80f0-614ded92193a	true	introspection.token.claim
fd95fe70-8a73-4817-80f0-614ded92193a	true	userinfo.token.claim
fd95fe70-8a73-4817-80f0-614ded92193a	profile	user.attribute
fd95fe70-8a73-4817-80f0-614ded92193a	true	id.token.claim
fd95fe70-8a73-4817-80f0-614ded92193a	true	access.token.claim
fd95fe70-8a73-4817-80f0-614ded92193a	profile	claim.name
fd95fe70-8a73-4817-80f0-614ded92193a	String	jsonType.label
78708d3b-8dd0-410b-83cf-869a216d63e2	foo	user.attribute
78708d3b-8dd0-410b-83cf-869a216d63e2	true	introspection.token.claim
78708d3b-8dd0-410b-83cf-869a216d63e2	true	access.token.claim
78708d3b-8dd0-410b-83cf-869a216d63e2	resource_access.${client_id}.roles	claim.name
78708d3b-8dd0-410b-83cf-869a216d63e2	String	jsonType.label
78708d3b-8dd0-410b-83cf-869a216d63e2	true	multivalued
d5ce86ac-9194-4243-a109-5504dbe5384a	foo	user.attribute
d5ce86ac-9194-4243-a109-5504dbe5384a	true	introspection.token.claim
d5ce86ac-9194-4243-a109-5504dbe5384a	true	access.token.claim
d5ce86ac-9194-4243-a109-5504dbe5384a	realm_access.roles	claim.name
d5ce86ac-9194-4243-a109-5504dbe5384a	String	jsonType.label
d5ce86ac-9194-4243-a109-5504dbe5384a	true	multivalued
dfa81b93-8424-4d5c-8d0a-091bab765b6a	true	introspection.token.claim
dfa81b93-8424-4d5c-8d0a-091bab765b6a	true	access.token.claim
359fad8c-0453-421a-ad56-b4e810fc3ebf	true	introspection.token.claim
359fad8c-0453-421a-ad56-b4e810fc3ebf	true	access.token.claim
61d9b714-ed19-4750-bb78-af3045541ef8	AUTH_TIME	user.session.note
61d9b714-ed19-4750-bb78-af3045541ef8	true	introspection.token.claim
61d9b714-ed19-4750-bb78-af3045541ef8	true	userinfo.token.claim
61d9b714-ed19-4750-bb78-af3045541ef8	true	id.token.claim
61d9b714-ed19-4750-bb78-af3045541ef8	true	access.token.claim
61d9b714-ed19-4750-bb78-af3045541ef8	auth_time	claim.name
61d9b714-ed19-4750-bb78-af3045541ef8	long	jsonType.label
f013e795-bd3e-4e07-a78b-0464b2c3ee6e	true	id.token.claim
f013e795-bd3e-4e07-a78b-0464b2c3ee6e	true	introspection.token.claim
f013e795-bd3e-4e07-a78b-0464b2c3ee6e	true	access.token.claim
f013e795-bd3e-4e07-a78b-0464b2c3ee6e	true	userinfo.token.claim
bc38d752-459a-46b1-8370-3b4b19982e1d	true	introspection.token.claim
bc38d752-459a-46b1-8370-3b4b19982e1d	true	userinfo.token.claim
bc38d752-459a-46b1-8370-3b4b19982e1d	username	user.attribute
bc38d752-459a-46b1-8370-3b4b19982e1d	true	id.token.claim
bc38d752-459a-46b1-8370-3b4b19982e1d	true	access.token.claim
bc38d752-459a-46b1-8370-3b4b19982e1d	upn	claim.name
bc38d752-459a-46b1-8370-3b4b19982e1d	String	jsonType.label
ed3f1501-822b-4cf3-85bb-2e8105a41e03	true	introspection.token.claim
ed3f1501-822b-4cf3-85bb-2e8105a41e03	true	multivalued
ed3f1501-822b-4cf3-85bb-2e8105a41e03	true	userinfo.token.claim
ed3f1501-822b-4cf3-85bb-2e8105a41e03	foo	user.attribute
ed3f1501-822b-4cf3-85bb-2e8105a41e03	true	id.token.claim
ed3f1501-822b-4cf3-85bb-2e8105a41e03	true	access.token.claim
ed3f1501-822b-4cf3-85bb-2e8105a41e03	groups	claim.name
ed3f1501-822b-4cf3-85bb-2e8105a41e03	String	jsonType.label
ae3930b5-4c26-445f-87a6-003e659ff384	formatted	user.attribute.formatted
ae3930b5-4c26-445f-87a6-003e659ff384	country	user.attribute.country
ae3930b5-4c26-445f-87a6-003e659ff384	true	introspection.token.claim
ae3930b5-4c26-445f-87a6-003e659ff384	postal_code	user.attribute.postal_code
ae3930b5-4c26-445f-87a6-003e659ff384	true	userinfo.token.claim
ae3930b5-4c26-445f-87a6-003e659ff384	street	user.attribute.street
ae3930b5-4c26-445f-87a6-003e659ff384	true	id.token.claim
ae3930b5-4c26-445f-87a6-003e659ff384	region	user.attribute.region
ae3930b5-4c26-445f-87a6-003e659ff384	true	access.token.claim
ae3930b5-4c26-445f-87a6-003e659ff384	locality	user.attribute.locality
30cb07ec-7542-45e6-beec-2c7892687abc	true	introspection.token.claim
30cb07ec-7542-45e6-beec-2c7892687abc	true	access.token.claim
28aa9826-b8cc-4cd1-820b-9a15d91b1f98	true	introspection.token.claim
28aa9826-b8cc-4cd1-820b-9a15d91b1f98	true	userinfo.token.claim
28aa9826-b8cc-4cd1-820b-9a15d91b1f98	email	user.attribute
28aa9826-b8cc-4cd1-820b-9a15d91b1f98	true	id.token.claim
28aa9826-b8cc-4cd1-820b-9a15d91b1f98	true	access.token.claim
28aa9826-b8cc-4cd1-820b-9a15d91b1f98	email	claim.name
28aa9826-b8cc-4cd1-820b-9a15d91b1f98	String	jsonType.label
68eaa05a-b55f-45b0-9019-2257f2992ea2	true	introspection.token.claim
68eaa05a-b55f-45b0-9019-2257f2992ea2	true	userinfo.token.claim
68eaa05a-b55f-45b0-9019-2257f2992ea2	emailVerified	user.attribute
68eaa05a-b55f-45b0-9019-2257f2992ea2	true	id.token.claim
68eaa05a-b55f-45b0-9019-2257f2992ea2	true	access.token.claim
68eaa05a-b55f-45b0-9019-2257f2992ea2	email_verified	claim.name
68eaa05a-b55f-45b0-9019-2257f2992ea2	boolean	jsonType.label
252642e6-6d1a-4da0-a7da-5326d92dca1f	true	introspection.token.claim
252642e6-6d1a-4da0-a7da-5326d92dca1f	true	userinfo.token.claim
252642e6-6d1a-4da0-a7da-5326d92dca1f	phoneNumber	user.attribute
252642e6-6d1a-4da0-a7da-5326d92dca1f	true	id.token.claim
252642e6-6d1a-4da0-a7da-5326d92dca1f	true	access.token.claim
252642e6-6d1a-4da0-a7da-5326d92dca1f	phone_number	claim.name
252642e6-6d1a-4da0-a7da-5326d92dca1f	String	jsonType.label
70d625af-faae-41fb-b79c-98d6970463d3	true	introspection.token.claim
70d625af-faae-41fb-b79c-98d6970463d3	true	userinfo.token.claim
70d625af-faae-41fb-b79c-98d6970463d3	phoneNumberVerified	user.attribute
70d625af-faae-41fb-b79c-98d6970463d3	true	id.token.claim
70d625af-faae-41fb-b79c-98d6970463d3	true	access.token.claim
70d625af-faae-41fb-b79c-98d6970463d3	phone_number_verified	claim.name
70d625af-faae-41fb-b79c-98d6970463d3	boolean	jsonType.label
6f353f19-a35c-4862-8dd5-d93b53e96441	clientHost	user.session.note
6f353f19-a35c-4862-8dd5-d93b53e96441	true	id.token.claim
6f353f19-a35c-4862-8dd5-d93b53e96441	true	introspection.token.claim
6f353f19-a35c-4862-8dd5-d93b53e96441	true	access.token.claim
6f353f19-a35c-4862-8dd5-d93b53e96441	clientHost	claim.name
6f353f19-a35c-4862-8dd5-d93b53e96441	String	jsonType.label
8dc0cba5-2c7f-47bc-afcc-9192d60cb77e	clientAddress	user.session.note
8dc0cba5-2c7f-47bc-afcc-9192d60cb77e	true	id.token.claim
8dc0cba5-2c7f-47bc-afcc-9192d60cb77e	true	introspection.token.claim
8dc0cba5-2c7f-47bc-afcc-9192d60cb77e	true	access.token.claim
8dc0cba5-2c7f-47bc-afcc-9192d60cb77e	clientAddress	claim.name
8dc0cba5-2c7f-47bc-afcc-9192d60cb77e	String	jsonType.label
9473f3a7-0b98-42f1-9ae4-e737f0d107b2	client_id	user.session.note
9473f3a7-0b98-42f1-9ae4-e737f0d107b2	true	introspection.token.claim
9473f3a7-0b98-42f1-9ae4-e737f0d107b2	true	userinfo.token.claim
9473f3a7-0b98-42f1-9ae4-e737f0d107b2	true	id.token.claim
9473f3a7-0b98-42f1-9ae4-e737f0d107b2	true	access.token.claim
9473f3a7-0b98-42f1-9ae4-e737f0d107b2	client_id	claim.name
9473f3a7-0b98-42f1-9ae4-e737f0d107b2	String	jsonType.label
6f353f19-a35c-4862-8dd5-d93b53e96441	true	userinfo.token.claim
8dc0cba5-2c7f-47bc-afcc-9192d60cb77e	true	userinfo.token.claim
62f0dd79-696f-41db-83a2-5648ebb2ce48	true	introspection.token.claim
62f0dd79-696f-41db-83a2-5648ebb2ce48	true	multivalued
62f0dd79-696f-41db-83a2-5648ebb2ce48	true	userinfo.token.claim
62f0dd79-696f-41db-83a2-5648ebb2ce48	true	id.token.claim
62f0dd79-696f-41db-83a2-5648ebb2ce48	true	access.token.claim
62f0dd79-696f-41db-83a2-5648ebb2ce48	organization	claim.name
62f0dd79-696f-41db-83a2-5648ebb2ce48	String	jsonType.label
27da002d-9967-4f41-bb3d-5dd400d183e0	false	single
27da002d-9967-4f41-bb3d-5dd400d183e0	Basic	attribute.nameformat
27da002d-9967-4f41-bb3d-5dd400d183e0	Role	attribute.name
fc778a7b-0ed2-4b9b-8893-c8265dd4281f	true	introspection.token.claim
fc778a7b-0ed2-4b9b-8893-c8265dd4281f	true	userinfo.token.claim
fc778a7b-0ed2-4b9b-8893-c8265dd4281f	locale	user.attribute
fc778a7b-0ed2-4b9b-8893-c8265dd4281f	true	id.token.claim
fc778a7b-0ed2-4b9b-8893-c8265dd4281f	true	access.token.claim
fc778a7b-0ed2-4b9b-8893-c8265dd4281f	locale	claim.name
fc778a7b-0ed2-4b9b-8893-c8265dd4281f	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
266e0ee5-a56b-4faf-89f4-02c5567093d1	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	fe1a2e3c-5060-4662-a935-5d5655e3ac08	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	d65beb10-107b-415c-85ef-b5a82d2540b6	b7a15dff-5f73-4474-9900-03e33462f84f	3f6f1be5-5c51-43d4-ade2-48b8bf6984b3	27d60081-3500-4b2d-b2c1-0a75b6e36760	99dd71be-c3ff-4e53-95fd-5bcce02ba06f	2592000	f	900	t	f	5969e406-4dae-4fff-af95-fc584ebdfcf5	0	f	0	0	29fe7f1f-24bc-4ffc-a3b7-8f7899d8638a
14468de3-0b67-44ab-a988-6565b42d2e10	60	300	300	\N	\N	\N	t	f	0	\N	TP2	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	b1017ee6-dea2-4077-8adb-69e681cd685c	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	07953e34-acfa-43f1-80cf-9bf2c72ed41e	47e4dffc-18f7-4591-bf0d-8efdd635d018	2ca688cb-2627-471e-a30e-17f0bd92b22e	be01d7ca-fc5e-4923-b44b-4040b1e33be8	2304534f-e682-412f-a2ab-cb544996e9a0	2592000	f	900	t	f	54ffd8de-6ad1-4601-a44b-2eeae54ff937	0	f	0	0	8a3b9be4-a634-4772-aef7-e5947104a3e1
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	266e0ee5-a56b-4faf-89f4-02c5567093d1	
_browser_header.xContentTypeOptions	266e0ee5-a56b-4faf-89f4-02c5567093d1	nosniff
_browser_header.referrerPolicy	266e0ee5-a56b-4faf-89f4-02c5567093d1	no-referrer
_browser_header.xRobotsTag	266e0ee5-a56b-4faf-89f4-02c5567093d1	none
_browser_header.xFrameOptions	266e0ee5-a56b-4faf-89f4-02c5567093d1	SAMEORIGIN
_browser_header.contentSecurityPolicy	266e0ee5-a56b-4faf-89f4-02c5567093d1	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.strictTransportSecurity	266e0ee5-a56b-4faf-89f4-02c5567093d1	max-age=31536000; includeSubDomains
bruteForceProtected	266e0ee5-a56b-4faf-89f4-02c5567093d1	false
permanentLockout	266e0ee5-a56b-4faf-89f4-02c5567093d1	false
maxTemporaryLockouts	266e0ee5-a56b-4faf-89f4-02c5567093d1	0
bruteForceStrategy	266e0ee5-a56b-4faf-89f4-02c5567093d1	MULTIPLE
maxFailureWaitSeconds	266e0ee5-a56b-4faf-89f4-02c5567093d1	900
minimumQuickLoginWaitSeconds	266e0ee5-a56b-4faf-89f4-02c5567093d1	60
waitIncrementSeconds	266e0ee5-a56b-4faf-89f4-02c5567093d1	60
quickLoginCheckMilliSeconds	266e0ee5-a56b-4faf-89f4-02c5567093d1	1000
maxDeltaTimeSeconds	266e0ee5-a56b-4faf-89f4-02c5567093d1	43200
failureFactor	266e0ee5-a56b-4faf-89f4-02c5567093d1	30
maxSecondaryAuthFailures	266e0ee5-a56b-4faf-89f4-02c5567093d1	0
realmReusableOtpCode	266e0ee5-a56b-4faf-89f4-02c5567093d1	false
firstBrokerLoginFlowId	266e0ee5-a56b-4faf-89f4-02c5567093d1	61bd23d5-9007-4154-a13d-33364c1d06eb
displayName	266e0ee5-a56b-4faf-89f4-02c5567093d1	Keycloak
displayNameHtml	266e0ee5-a56b-4faf-89f4-02c5567093d1	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	266e0ee5-a56b-4faf-89f4-02c5567093d1	RS256
offlineSessionMaxLifespanEnabled	266e0ee5-a56b-4faf-89f4-02c5567093d1	false
offlineSessionMaxLifespan	266e0ee5-a56b-4faf-89f4-02c5567093d1	5184000
_browser_header.contentSecurityPolicyReportOnly	14468de3-0b67-44ab-a988-6565b42d2e10	
_browser_header.xContentTypeOptions	14468de3-0b67-44ab-a988-6565b42d2e10	nosniff
_browser_header.referrerPolicy	14468de3-0b67-44ab-a988-6565b42d2e10	no-referrer
_browser_header.xRobotsTag	14468de3-0b67-44ab-a988-6565b42d2e10	none
_browser_header.xFrameOptions	14468de3-0b67-44ab-a988-6565b42d2e10	SAMEORIGIN
_browser_header.contentSecurityPolicy	14468de3-0b67-44ab-a988-6565b42d2e10	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.strictTransportSecurity	14468de3-0b67-44ab-a988-6565b42d2e10	max-age=31536000; includeSubDomains
bruteForceProtected	14468de3-0b67-44ab-a988-6565b42d2e10	false
permanentLockout	14468de3-0b67-44ab-a988-6565b42d2e10	false
maxTemporaryLockouts	14468de3-0b67-44ab-a988-6565b42d2e10	0
bruteForceStrategy	14468de3-0b67-44ab-a988-6565b42d2e10	MULTIPLE
maxFailureWaitSeconds	14468de3-0b67-44ab-a988-6565b42d2e10	900
minimumQuickLoginWaitSeconds	14468de3-0b67-44ab-a988-6565b42d2e10	60
waitIncrementSeconds	14468de3-0b67-44ab-a988-6565b42d2e10	60
quickLoginCheckMilliSeconds	14468de3-0b67-44ab-a988-6565b42d2e10	1000
maxDeltaTimeSeconds	14468de3-0b67-44ab-a988-6565b42d2e10	43200
failureFactor	14468de3-0b67-44ab-a988-6565b42d2e10	30
maxSecondaryAuthFailures	14468de3-0b67-44ab-a988-6565b42d2e10	0
realmReusableOtpCode	14468de3-0b67-44ab-a988-6565b42d2e10	false
displayName	14468de3-0b67-44ab-a988-6565b42d2e10	
displayNameHtml	14468de3-0b67-44ab-a988-6565b42d2e10	
defaultSignatureAlgorithm	14468de3-0b67-44ab-a988-6565b42d2e10	RS256
offlineSessionMaxLifespanEnabled	14468de3-0b67-44ab-a988-6565b42d2e10	false
offlineSessionMaxLifespan	14468de3-0b67-44ab-a988-6565b42d2e10	5184000
clientSessionIdleTimeout	14468de3-0b67-44ab-a988-6565b42d2e10	0
clientSessionMaxLifespan	14468de3-0b67-44ab-a988-6565b42d2e10	0
clientOfflineSessionIdleTimeout	14468de3-0b67-44ab-a988-6565b42d2e10	0
clientOfflineSessionMaxLifespan	14468de3-0b67-44ab-a988-6565b42d2e10	0
actionTokenGeneratedByAdminLifespan	14468de3-0b67-44ab-a988-6565b42d2e10	43200
actionTokenGeneratedByUserLifespan	14468de3-0b67-44ab-a988-6565b42d2e10	300
oauth2DeviceCodeLifespan	14468de3-0b67-44ab-a988-6565b42d2e10	1200
oauth2DevicePollingInterval	14468de3-0b67-44ab-a988-6565b42d2e10	5
organizationsEnabled	14468de3-0b67-44ab-a988-6565b42d2e10	false
scimApiEnabled	14468de3-0b67-44ab-a988-6565b42d2e10	false
adminPermissionsEnabled	14468de3-0b67-44ab-a988-6565b42d2e10	false
webAuthnPolicyRpEntityName	14468de3-0b67-44ab-a988-6565b42d2e10	keycloak
webAuthnPolicySignatureAlgorithms	14468de3-0b67-44ab-a988-6565b42d2e10	ES256,RS256
webAuthnPolicyRpId	14468de3-0b67-44ab-a988-6565b42d2e10	
webAuthnPolicyAttestationConveyancePreference	14468de3-0b67-44ab-a988-6565b42d2e10	not specified
webAuthnPolicyAuthenticatorAttachment	14468de3-0b67-44ab-a988-6565b42d2e10	not specified
webAuthnPolicyRequireResidentKey	14468de3-0b67-44ab-a988-6565b42d2e10	not specified
webAuthnPolicyUserVerificationRequirement	14468de3-0b67-44ab-a988-6565b42d2e10	not specified
webAuthnPolicyCreateTimeout	14468de3-0b67-44ab-a988-6565b42d2e10	0
webAuthnPolicyAvoidSameAuthenticatorRegister	14468de3-0b67-44ab-a988-6565b42d2e10	false
webAuthnPolicyRpEntityNamePasswordless	14468de3-0b67-44ab-a988-6565b42d2e10	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	14468de3-0b67-44ab-a988-6565b42d2e10	ES256,RS256
webAuthnPolicyRpIdPasswordless	14468de3-0b67-44ab-a988-6565b42d2e10	
webAuthnPolicyAttestationConveyancePreferencePasswordless	14468de3-0b67-44ab-a988-6565b42d2e10	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	14468de3-0b67-44ab-a988-6565b42d2e10	not specified
webAuthnPolicyRequireResidentKeyPasswordless	14468de3-0b67-44ab-a988-6565b42d2e10	Yes
webAuthnPolicyUserVerificationRequirementPasswordless	14468de3-0b67-44ab-a988-6565b42d2e10	required
webAuthnPolicyCreateTimeoutPasswordless	14468de3-0b67-44ab-a988-6565b42d2e10	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	14468de3-0b67-44ab-a988-6565b42d2e10	false
cibaBackchannelTokenDeliveryMode	14468de3-0b67-44ab-a988-6565b42d2e10	poll
cibaExpiresIn	14468de3-0b67-44ab-a988-6565b42d2e10	120
cibaInterval	14468de3-0b67-44ab-a988-6565b42d2e10	5
cibaAuthRequestedUserHint	14468de3-0b67-44ab-a988-6565b42d2e10	login_hint
parRequestUriLifespan	14468de3-0b67-44ab-a988-6565b42d2e10	60
firstBrokerLoginFlowId	14468de3-0b67-44ab-a988-6565b42d2e10	262dbae7-e276-4e0e-bd97-cebdd80169cd
actionTokenGeneratedByUserLifespan.verify-email	14468de3-0b67-44ab-a988-6565b42d2e10	
actionTokenGeneratedByUserLifespan.idp-verify-account-via-email	14468de3-0b67-44ab-a988-6565b42d2e10	
actionTokenGeneratedByUserLifespan.execute-actions	14468de3-0b67-44ab-a988-6565b42d2e10	
saml.signature.algorithm	14468de3-0b67-44ab-a988-6565b42d2e10	
frontendUrl	14468de3-0b67-44ab-a988-6565b42d2e10	
acr.loa.map	14468de3-0b67-44ab-a988-6565b42d2e10	{}
shortVerificationUri	14468de3-0b67-44ab-a988-6565b42d2e10	
actionTokenGeneratedByUserLifespan.reset-credentials	14468de3-0b67-44ab-a988-6565b42d2e10	
verifiableCredentialsEnabled	14468de3-0b67-44ab-a988-6565b42d2e10	false
client-policies.profiles	14468de3-0b67-44ab-a988-6565b42d2e10	{"profiles":[]}
client-policies.policies	14468de3-0b67-44ab-a988-6565b42d2e10	{"policies":[]}
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
266e0ee5-a56b-4faf-89f4-02c5567093d1	jboss-logging
14468de3-0b67-44ab-a988-6565b42d2e10	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	266e0ee5-a56b-4faf-89f4-02c5567093d1
password	password	t	t	14468de3-0b67-44ab-a988-6565b42d2e10
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.redirect_uris (client_id, value) FROM stdin;
d0a046e1-427e-4a16-9bf1-8e6da31572bd	/realms/master/account/*
139e3b65-55d2-41c8-95be-45bb7b554d46	/realms/master/account/*
c5424ef9-8012-4f99-b4ad-e8456f980f8c	/admin/master/console/*
75061a78-e9fa-4f5e-b792-aa249d94d9b2	/realms/TP2/account/*
7f184a64-7758-4108-9017-05ec9db69fc2	/realms/TP2/account/*
c0474998-cebc-48b9-b387-d72b0cc776db	http://localhost:8081/*
c0474998-cebc-48b9-b387-d72b0cc776db	http://localhost:4200/*
6c422063-458c-4c28-a3e7-0c7febd3489d	/admin/TP2/console/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
2899e2de-79c4-4139-96ed-a82d4cc1d6b1	VERIFY_EMAIL	Verify Email	266e0ee5-a56b-4faf-89f4-02c5567093d1	t	f	VERIFY_EMAIL	50
35c75043-a4f1-487b-8f67-07a31b761699	UPDATE_PROFILE	Update Profile	266e0ee5-a56b-4faf-89f4-02c5567093d1	t	f	UPDATE_PROFILE	40
4f31a487-2413-4e2d-8659-52bd43e926bc	CONFIGURE_TOTP	Configure OTP	266e0ee5-a56b-4faf-89f4-02c5567093d1	t	f	CONFIGURE_TOTP	10
33c78095-c2b1-4db4-bca7-fca882f21da4	UPDATE_PASSWORD	Update Password	266e0ee5-a56b-4faf-89f4-02c5567093d1	t	f	UPDATE_PASSWORD	30
84746a3e-2341-4a35-9a8e-efbae4571071	TERMS_AND_CONDITIONS	Terms and Conditions	266e0ee5-a56b-4faf-89f4-02c5567093d1	f	f	TERMS_AND_CONDITIONS	20
ffc7c079-610e-4aec-b9fa-68f21261a0b7	delete_account	Delete Account	266e0ee5-a56b-4faf-89f4-02c5567093d1	f	f	delete_account	60
6c085799-1a09-4eb3-9c41-4b5245cec3ea	delete_credential	Delete Credential	266e0ee5-a56b-4faf-89f4-02c5567093d1	t	f	delete_credential	110
9f56e2e9-ec06-4314-90bc-bd7439ccf632	update_user_locale	Update User Locale	266e0ee5-a56b-4faf-89f4-02c5567093d1	t	f	update_user_locale	1000
7612a6e0-4868-45dd-8201-fc5a19061d8f	UPDATE_EMAIL	Update Email	266e0ee5-a56b-4faf-89f4-02c5567093d1	f	f	UPDATE_EMAIL	70
622782c6-c24e-4777-a386-28172a6acfca	CONFIGURE_RECOVERY_AUTHN_CODES	Recovery Authentication Codes	266e0ee5-a56b-4faf-89f4-02c5567093d1	t	f	CONFIGURE_RECOVERY_AUTHN_CODES	130
ec14ff33-dc21-4078-a7b7-f10e2939d5e3	webauthn-register	Webauthn Register	266e0ee5-a56b-4faf-89f4-02c5567093d1	t	f	webauthn-register	80
63ad366e-c449-41e6-86fc-aa90c231c94b	webauthn-register-passwordless	Webauthn Register Passwordless	266e0ee5-a56b-4faf-89f4-02c5567093d1	t	f	webauthn-register-passwordless	90
f2d75863-6609-47e9-b9e4-7e8deb19090a	VERIFY_PROFILE	Verify Profile	266e0ee5-a56b-4faf-89f4-02c5567093d1	t	f	VERIFY_PROFILE	100
b1de94c8-386e-4d40-92ad-67d562c0c8f8	idp_link	Linking Identity Provider	266e0ee5-a56b-4faf-89f4-02c5567093d1	t	f	idp_link	120
96b8c125-6db0-4cec-bc5d-d25b6fcbc500	CONFIGURE_TOTP	Configure OTP	14468de3-0b67-44ab-a988-6565b42d2e10	t	f	CONFIGURE_TOTP	10
a4aabf93-c60f-4947-820d-090d9b84623d	TERMS_AND_CONDITIONS	Terms and Conditions	14468de3-0b67-44ab-a988-6565b42d2e10	f	f	TERMS_AND_CONDITIONS	20
66751b3c-4a6b-49a5-b860-d00281207aeb	UPDATE_PASSWORD	Update Password	14468de3-0b67-44ab-a988-6565b42d2e10	t	f	UPDATE_PASSWORD	30
cea8d8ee-9906-4e9f-8b50-90026dccd482	UPDATE_PROFILE	Update Profile	14468de3-0b67-44ab-a988-6565b42d2e10	t	f	UPDATE_PROFILE	40
9a88f29a-b2a0-4238-8bd7-678f13528da4	VERIFY_EMAIL	Verify Email	14468de3-0b67-44ab-a988-6565b42d2e10	t	f	VERIFY_EMAIL	50
0e6414e0-5363-4f65-b3b4-f36166758b9d	delete_account	Delete Account	14468de3-0b67-44ab-a988-6565b42d2e10	f	f	delete_account	60
2079ee28-c0c7-4af1-b8e9-7a78a9c975dd	UPDATE_EMAIL	Update Email	14468de3-0b67-44ab-a988-6565b42d2e10	f	f	UPDATE_EMAIL	70
6d774f0a-c204-4e5b-9164-dedbc6a97933	webauthn-register	Webauthn Register	14468de3-0b67-44ab-a988-6565b42d2e10	t	f	webauthn-register	80
f9667ee2-3d73-460f-b5ad-df1b07d32e1f	webauthn-register-passwordless	Webauthn Register Passwordless	14468de3-0b67-44ab-a988-6565b42d2e10	t	f	webauthn-register-passwordless	90
64ada55c-fcf1-48d1-9c26-fa4d5771bf1d	VERIFY_PROFILE	Verify Profile	14468de3-0b67-44ab-a988-6565b42d2e10	t	f	VERIFY_PROFILE	100
f5bce7da-35e6-475a-9be1-1358d2c49231	delete_credential	Delete Credential	14468de3-0b67-44ab-a988-6565b42d2e10	t	f	delete_credential	110
d4fe06e0-3e45-459e-9bab-2db09c2de7d9	idp_link	Linking Identity Provider	14468de3-0b67-44ab-a988-6565b42d2e10	t	f	idp_link	120
b4125da1-f3c6-4591-8665-74046fd00b1f	CONFIGURE_RECOVERY_AUTHN_CODES	Recovery Authentication Codes	14468de3-0b67-44ab-a988-6565b42d2e10	t	f	CONFIGURE_RECOVERY_AUTHN_CODES	130
8559cf61-14a0-4cfc-bf4f-bfcfcc96cbcc	update_user_locale	Update User Locale	14468de3-0b67-44ab-a988-6565b42d2e10	t	f	update_user_locale	1000
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: revoked_token; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.revoked_token (id, expire) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
139e3b65-55d2-41c8-95be-45bb7b554d46	59e9a4f2-be59-471c-a717-c7cad87561ce
139e3b65-55d2-41c8-95be-45bb7b554d46	eb3e37ca-1e15-4c26-8d34-90336fd1205e
7f184a64-7758-4108-9017-05ec9db69fc2	2d24a11f-8222-4fb4-9d07-e545737768b9
7f184a64-7758-4108-9017-05ec9db69fc2	c47cf8f5-55fd-4f03-b4d7-bcc140328e14
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: server_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.server_config (server_config_key, value, version) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_attribute (name, value, user_id, id, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
is_temporary_admin	true	160dd65c-a471-4d1f-84bd-2881486cec39	073a4b79-bb63-4467-9b77-e67d5e9f8f5d	\N	\N	\N
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before, last_modified_timestamp) FROM stdin;
160dd65c-a471-4d1f-84bd-2881486cec39	\N	7ba8db07-b55a-4d99-8313-71ec2194f656	f	t	\N	\N	\N	266e0ee5-a56b-4faf-89f4-02c5567093d1	admin	1778935220268	\N	0	1778935220268
e6633081-cf68-408c-ba9f-4b756d4c1a93	biel@gmail.com	biel@gmail.com	f	t	\N	Gabriel	\N	14468de3-0b67-44ab-a988-6565b42d2e10	biel	1778964640801	\N	0	1778964640801
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_group_membership (group_id, user_id, membership_type) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
29fe7f1f-24bc-4ffc-a3b7-8f7899d8638a	160dd65c-a471-4d1f-84bd-2881486cec39
7b40d8d5-434b-4884-ae83-4afd3a15d34d	160dd65c-a471-4d1f-84bd-2881486cec39
8a3b9be4-a634-4772-aef7-e5947104a3e1	e6633081-cf68-408c-ba9f-4b756d4c1a93
8da79ecc-01f0-4f83-baa0-9ec0faa3cbf7	e6633081-cf68-408c-ba9f-4b756d4c1a93
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.web_origins (client_id, value) FROM stdin;
c5424ef9-8012-4f99-b4ad-e8456f980f8c	+
c0474998-cebc-48b9-b387-d72b0cc776db	http://localhost:8081
c0474998-cebc-48b9-b387-d72b0cc776db	http://localhost:4200
6c422063-458c-4c28-a3e7-0c7febd3489d	+
\.


--
-- Data for Name: workflow_state; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.workflow_state (execution_id, resource_id, workflow_id, resource_type, scheduled_step_id, scheduled_step_timestamp) FROM stdin;
\.


--
-- Name: org_domain ORG_DOMAIN_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT "ORG_DOMAIN_pkey" PRIMARY KEY (id, name);


--
-- Name: org ORG_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT "ORG_pkey" PRIMARY KEY (id);


--
-- Name: server_config SERVER_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.server_config
    ADD CONSTRAINT "SERVER_CONFIG_pkey" PRIMARY KEY (server_config_key);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: jgroups_ping constraint_jgroups_ping; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.jgroups_ping
    ADD CONSTRAINT constraint_jgroups_ping PRIMARY KEY (address);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: org_invitation constraint_org_invitation; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org_invitation
    ADD CONSTRAINT constraint_org_invitation PRIMARY KEY (id);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: revoked_token constraint_rt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.revoked_token
    ADD CONSTRAINT constraint_rt PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: workflow_state pk_workflow_state; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.workflow_state
    ADD CONSTRAINT pk_workflow_state PRIMARY KEY (execution_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: user_consent uk_external_consent; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_external_consent UNIQUE (client_storage_provider, external_client_id, user_id);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_local_consent; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_local_consent UNIQUE (client_id, user_id);


--
-- Name: migration_model uk_migration_update_time; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT uk_migration_update_time UNIQUE (update_time);


--
-- Name: migration_model uk_migration_version; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT uk_migration_version UNIQUE (version);


--
-- Name: org uk_org_alias; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_alias UNIQUE (realm_id, alias);


--
-- Name: org uk_org_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_group UNIQUE (group_id);


--
-- Name: org_invitation uk_org_invitation_email; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org_invitation
    ADD CONSTRAINT uk_org_invitation_email UNIQUE (organization_id, email);


--
-- Name: org uk_org_name; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_name UNIQUE (realm_id, name);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: workflow_state uq_workflow_resource; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.workflow_state
    ADD CONSTRAINT uq_workflow_resource UNIQUE (workflow_id, resource_id);


--
-- Name: fed_user_attr_long_values; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX fed_user_attr_long_values ON public.fed_user_attribute USING btree (long_value_hash, name);


--
-- Name: fed_user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX fed_user_attr_long_values_lower_case ON public.fed_user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_broker_link_identity_provider; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_broker_link_identity_provider ON public.broker_link USING btree (realm_id, identity_provider, broker_user_id);


--
-- Name: idx_broker_link_user_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_broker_link_user_id ON public.broker_link USING btree (user_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, substr(value, 1, 255));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_entity_user_id_type; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_event_entity_user_id_type ON public.event_entity USING btree (user_id, type, event_time);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_org_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_org_id ON public.keycloak_group USING btree (org_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_idp_for_login; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_idp_for_login ON public.identity_provider USING btree (realm_id, enabled, link_only, hide_on_login, organization_id);


--
-- Name: idx_idp_realm_org; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_idp_realm_org ON public.identity_provider USING btree (realm_id, organization_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_css_by_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_css_by_client ON public.offline_client_session USING btree (client_id, offline_flag) WHERE ((client_id)::text <> 'external'::text);


--
-- Name: idx_offline_css_by_client_and_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_css_by_client_and_realm ON public.offline_client_session USING btree (realm_id, offline_flag, client_id, client_storage_provider, external_client_id);


--
-- Name: idx_offline_css_by_client_storage_provider; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_css_by_client_storage_provider ON public.offline_client_session USING btree (client_storage_provider, external_client_id, offline_flag) WHERE ((client_storage_provider)::text <> 'internal'::text);


--
-- Name: idx_offline_css_by_user_session_and_offline; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_css_by_user_session_and_offline ON public.offline_client_session USING btree (offline_flag, user_session_id);


--
-- Name: idx_offline_uss_by_broker_session_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_broker_session_id ON public.offline_user_session USING btree (broker_session_id, realm_id);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_org_domain_org_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_org_domain_org_id ON public.org_domain USING btree (org_id);


--
-- Name: idx_org_invitation_email; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_org_invitation_email ON public.org_invitation USING btree (email);


--
-- Name: idx_org_invitation_expires; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_org_invitation_expires ON public.org_invitation USING btree (expires_at);


--
-- Name: idx_org_invitation_org_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_org_invitation_org_id ON public.org_invitation USING btree (organization_id);


--
-- Name: idx_perm_ticket_owner; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_perm_ticket_owner ON public.resource_server_perm_ticket USING btree (owner);


--
-- Name: idx_perm_ticket_requester; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_perm_ticket_requester ON public.resource_server_perm_ticket USING btree (requester);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_rev_token_on_expire; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_rev_token_on_expire ON public.revoked_token USING btree (expire);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_usconsent_scope_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usconsent_scope_id ON public.user_consent_client_scope USING btree (scope_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_created_timestamp; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_created_timestamp ON public.user_entity USING btree (realm_id, created_timestamp);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_user_session_expiration_created; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_session_expiration_created ON public.offline_user_session USING btree (realm_id, offline_flag, remember_me, created_on, user_session_id, user_id);


--
-- Name: idx_user_session_expiration_last_refresh; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_session_expiration_last_refresh ON public.offline_user_session USING btree (realm_id, offline_flag, remember_me, last_session_refresh, user_session_id, user_id);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: idx_workflow_state_provider; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_workflow_state_provider ON public.workflow_state USING btree (resource_id);


--
-- Name: idx_workflow_state_step; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_workflow_state_step ON public.workflow_state USING btree (workflow_id, scheduled_step_id);


--
-- Name: user_attr_long_values; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX user_attr_long_values ON public.user_attribute USING btree (long_value_hash, name);


--
-- Name: user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX user_attr_long_values_lower_case ON public.user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: keycloak_group fk_group_organization; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT fk_group_organization FOREIGN KEY (org_id) REFERENCES public.org(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: org_invitation fk_org_invitation_org; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org_invitation
    ADD CONSTRAINT fk_org_invitation_org FOREIGN KEY (organization_id) REFERENCES public.org(id) ON DELETE CASCADE;


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

\unrestrict 2p47VeoTHc06xZKbYyrQp3LCgtpbBnCos52fPBAMfLk0GfC6gwjbYPRMko0Dia4

