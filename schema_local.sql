CREATE TABLE table_local
(
    event_date DateTime,
    counter_id UInt32,
    user_id UInt32,
    desc String,
    ver UInt16
) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/0-0/table_local', 'clickhouse-node2', ver)
PARTITION BY toYYYYMM(event_date)
ORDER BY (counter_id, event_date, intHash32(user_id))
SAMPLE BY intHash32(user_id)

CREATE TABLE events_local
(
    event_date DateTime,
    counter_id UInt32,
    details String,
    ver UInt16
) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/0-0/events_local', 'clickhouse-node2', ver)
PARTITION BY toYYYYMM(event_date)
ORDER BY (counter_id, event_date)


CREATE TABLE table_dist
(
    event_date DateTime,
    counter_id UInt32,
    user_id UInt32,
    desc String,
    ver UInt16
) ENGINE = Distributed(cluster1-replicas, default, table_local, counter_id)

CREATE TABLE events_dist
(
    event_date DateTime,
    counter_id UInt32,
    details String,
    ver UInt16
) ENGINE = Distributed(cluster1-replicas, default, events_local, counter_id)
