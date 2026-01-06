-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "event_status" AS ENUM ('Active', 'Resolved');

-- CreateEnum
CREATE TYPE "status" AS ENUM ('up', 'down', 'unmonitored');

-- CreateTable
CREATE TABLE "alarm_catalogue" (
    "id" BIGSERIAL NOT NULL,
    "uid" VARCHAR NOT NULL,
    "description_template" VARCHAR NOT NULL,
    "log_message_template" VARCHAR NOT NULL,
    "severity" BIGINT,

    CONSTRAINT "alarm_catalogue_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alarms" (
    "alarm_id" BIGSERIAL NOT NULL,
    "ifservice_id" BIGINT NOT NULL,
    "created_event_id" BIGINT NOT NULL,
    "resolved_event_id" BIGINT,
    "alarm_created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "alarm_resolved_at" TIMESTAMPTZ(6),
    "alarm_catalogue_id" BIGINT,
    "log_message" VARCHAR,
    "alarm_description" VARCHAR,
    "status" "event_status" DEFAULT 'Active',

    CONSTRAINT "alarms_id" PRIMARY KEY ("alarm_id")
);

-- CreateTable
CREATE TABLE "device_type" (
    "device_id" BIGSERIAL NOT NULL,
    "device_label" VARCHAR NOT NULL,
    "monitoring_status" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "device_type_id" PRIMARY KEY ("device_id")
);

-- CreateTable
CREATE TABLE "event_catalogue" (
    "id" BIGSERIAL NOT NULL,
    "uid" VARCHAR NOT NULL,
    "description_template" VARCHAR NOT NULL,
    "log_message_template" VARCHAR NOT NULL,
    "severity" BIGINT,

    CONSTRAINT "event_catalogue_id" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "events" (
    "event_id" BIGSERIAL NOT NULL,
    "ifservice_id" BIGINT NOT NULL,
    "event_created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "status" BOOLEAN,
    "event_catalogue_id" BIGINT,
    "log_message" VARCHAR,
    "event_description" VARCHAR,
    "severity" BIGINT,

    CONSTRAINT "events_id" PRIMARY KEY ("event_id")
);

-- CreateTable
CREATE TABLE "ifservices" (
    "ifservice_id" BIGSERIAL NOT NULL,
    "interface_id" BIGINT NOT NULL,
    "service_id" BIGINT NOT NULL,
    "status" "status" DEFAULT 'unmonitored',
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ifservices_pk" PRIMARY KEY ("ifservice_id")
);

-- CreateTable
CREATE TABLE "interfaces" (
    "interface_id" BIGSERIAL NOT NULL,
    "ip_address" VARCHAR NOT NULL,
    "node_id" BIGINT NOT NULL,
    "status" "status" DEFAULT 'unmonitored',
    "monitoring_status" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "interfaces_pk" PRIMARY KEY ("interface_id")
);

-- CreateTable
CREATE TABLE "locations" (
    "location_id" BIGSERIAL NOT NULL,
    "location_name" VARCHAR NOT NULL,
    "x_coordinate" DECIMAL(10,4),
    "y_coordinate" DECIMAL(10,4),
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "locations_id" PRIMARY KEY ("location_id")
);

-- CreateTable
CREATE TABLE "model_type" (
    "model_id" BIGSERIAL NOT NULL,
    "model_label" VARCHAR NOT NULL,
    "device_id" BIGINT NOT NULL,
    "monitoring_status" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "model_type_id" PRIMARY KEY ("model_id")
);

-- CreateTable
CREATE TABLE "nodes" (
    "node_id" BIGSERIAL NOT NULL,
    "node_label" VARCHAR NOT NULL,
    "location_id" BIGINT,
    "device_type" BIGINT NOT NULL,
    "device_model" BIGINT,
    "status" "status" DEFAULT 'unmonitored',
    "monitoring_status" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "nodes_pk" PRIMARY KEY ("node_id")
);

-- CreateTable
CREATE TABLE "outages" (
    "outage_id" BIGSERIAL NOT NULL,
    "outage_event_id" BIGINT NOT NULL,
    "resolve_event_id" BIGINT,
    "ifservice_id" BIGINT NOT NULL,
    "outage_time" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolve_time" TIMESTAMPTZ(6),
    "status" "event_status" DEFAULT 'Active',

    CONSTRAINT "outage_id" PRIMARY KEY ("outage_id")
);

-- CreateTable
CREATE TABLE "services" (
    "service_id" BIGSERIAL NOT NULL,
    "service_label" VARCHAR NOT NULL,
    "port" INTEGER,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "services_id" PRIMARY KEY ("service_id")
);

-- CreateTable
CREATE TABLE "severity" (
    "severity_id" BIGSERIAL NOT NULL,
    "severity_level" INTEGER NOT NULL,
    "severity_label" VARCHAR NOT NULL,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "severity_id" PRIMARY KEY ("severity_id")
);

-- AddForeignKey
ALTER TABLE "alarm_catalogue" ADD CONSTRAINT "alarm_catalogue_severity_fk" FOREIGN KEY ("severity") REFERENCES "severity"("severity_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "alarms" ADD CONSTRAINT "alarms_alarm_catalogue_fk" FOREIGN KEY ("alarm_catalogue_id") REFERENCES "alarm_catalogue"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "alarms" ADD CONSTRAINT "alarms_created_event_fk" FOREIGN KEY ("created_event_id") REFERENCES "events"("event_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "alarms" ADD CONSTRAINT "alarms_ifservices_fk" FOREIGN KEY ("ifservice_id") REFERENCES "ifservices"("ifservice_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "alarms" ADD CONSTRAINT "alarms_resolved_event_fk" FOREIGN KEY ("resolved_event_id") REFERENCES "events"("event_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "event_catalogue" ADD CONSTRAINT "event_catalogue_severity_fk" FOREIGN KEY ("severity") REFERENCES "severity"("severity_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_event_catalogue_fk" FOREIGN KEY ("event_catalogue_id") REFERENCES "event_catalogue"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_ifservices_fk" FOREIGN KEY ("ifservice_id") REFERENCES "ifservices"("ifservice_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_severity_fk" FOREIGN KEY ("severity") REFERENCES "severity"("severity_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "ifservices" ADD CONSTRAINT "ifservices_interfaces_fk" FOREIGN KEY ("interface_id") REFERENCES "interfaces"("interface_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "ifservices" ADD CONSTRAINT "ifservices_services_fk" FOREIGN KEY ("service_id") REFERENCES "services"("service_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "interfaces" ADD CONSTRAINT "interfaces_nodes_fk" FOREIGN KEY ("node_id") REFERENCES "nodes"("node_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "model_type" ADD CONSTRAINT "model_type_device_type_fk" FOREIGN KEY ("device_id") REFERENCES "device_type"("device_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "nodes" ADD CONSTRAINT "nodes_device_type_fk" FOREIGN KEY ("device_type") REFERENCES "device_type"("device_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "nodes" ADD CONSTRAINT "nodes_locations_fk" FOREIGN KEY ("location_id") REFERENCES "locations"("location_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "nodes" ADD CONSTRAINT "nodes_model_type_fk" FOREIGN KEY ("device_model") REFERENCES "model_type"("model_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "outages" ADD CONSTRAINT "outages_created_event_fk" FOREIGN KEY ("outage_event_id") REFERENCES "events"("event_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "outages" ADD CONSTRAINT "outages_ifservices_fk" FOREIGN KEY ("ifservice_id") REFERENCES "ifservices"("ifservice_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "outages" ADD CONSTRAINT "outages_resolved_event_fk" FOREIGN KEY ("resolve_event_id") REFERENCES "events"("event_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

