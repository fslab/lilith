--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    name character varying(255),
    eva_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL
);


--
-- Name: category_event_associations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE category_event_associations (
    category uuid,
    event uuid,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL,
    category_id uuid,
    event_id uuid
);


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE courses (
    name character varying(255),
    profile_url character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL,
    study_unit_id uuid
);


--
-- Name: event_group_associations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE event_group_associations (
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL,
    event_id uuid,
    group_id uuid
);


--
-- Name: event_lecturer_associations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE event_lecturer_associations (
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL,
    event_id uuid,
    lecturer_id uuid
);


--
-- Name: event_week_associations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE event_week_associations (
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL,
    event_id uuid,
    week_id uuid
);


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    first_start timestamp without time zone,
    first_end timestamp without time zone,
    until date,
    room character varying(255),
    recurrence character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL,
    course_id uuid,
    schedule_id uuid
);


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groups (
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL,
    course_id uuid
);


--
-- Name: people; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE people (
    title character varying(255),
    forename character varying(255),
    middlename character varying(255),
    surname character varying(255),
    eva_id character varying(255),
    profile_url character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL
);


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schedules (
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL,
    semester_id uuid
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: semesters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE semesters (
    start_year integer,
    season character varying(255),
    start_week character varying(255),
    end_week character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL
);


--
-- Name: study_units; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE study_units (
    program character varying(255),
    "position" integer,
    eva_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL,
    semester_id uuid
);


--
-- Name: weeks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE weeks (
    year integer,
    index integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL
);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: category_event_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY category_event_associations
    ADD CONSTRAINT category_event_associations_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: event_group_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_group_associations
    ADD CONSTRAINT event_group_associations_pkey PRIMARY KEY (id);


--
-- Name: event_lecturer_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_lecturer_associations
    ADD CONSTRAINT event_lecturer_associations_pkey PRIMARY KEY (id);


--
-- Name: event_week_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_week_associations
    ADD CONSTRAINT event_week_associations_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: people_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: semesters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY semesters
    ADD CONSTRAINT semesters_pkey PRIMARY KEY (id);


--
-- Name: study_units_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY study_units
    ADD CONSTRAINT study_units_pkey PRIMARY KEY (id);


--
-- Name: weeks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY weeks
    ADD CONSTRAINT weeks_pkey PRIMARY KEY (id);


--
-- Name: index_category_event_associations_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_category_event_associations_on_category_id ON category_event_associations USING btree (category_id);


--
-- Name: index_category_event_associations_on_event_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_category_event_associations_on_event_id ON category_event_associations USING btree (event_id);


--
-- Name: index_event_group_associations_on_event_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_group_associations_on_event_id ON event_group_associations USING btree (event_id);


--
-- Name: index_event_group_associations_on_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_group_associations_on_group_id ON event_group_associations USING btree (group_id);


--
-- Name: index_event_lecturer_associations_on_event_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_lecturer_associations_on_event_id ON event_lecturer_associations USING btree (event_id);


--
-- Name: index_event_lecturer_associations_on_lecturer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_lecturer_associations_on_lecturer_id ON event_lecturer_associations USING btree (lecturer_id);


--
-- Name: index_event_week_associations_on_event_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_week_associations_on_event_id ON event_week_associations USING btree (event_id);


--
-- Name: index_event_week_associations_on_week_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_week_associations_on_week_id ON event_week_associations USING btree (week_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20110414204139');