-- Require > 7.4, else use createlang command
CREATE PROCEDURAL LANGUAGE plpgsql;

BEGIN;

CREATE FUNCTION SEC_TO_TIME(double precision)
RETURNS interval AS $$
    select date_trunc('second', $1 * interval '1 second');
$$ LANGUAGE SQL;


CREATE FUNCTION UNIX_TIMESTAMP(timestamp with time zone)
RETURNS double precision AS $$
    select date_part('epoch', $1);
$$ LANGUAGE SQL;

COMMIT;