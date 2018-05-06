-- Good documentation on all of these commands:
-- http://suite.opengeo.org/docs/latest/dataadmin/pgBasics/geometries.html

select
  name, acres, sq_miles,
  st_area(st_transform(geom, 26986)) / 4046.85642 as cal_acres,
  st_ymax(geom), st_xmax(geom), st_ymin(geom), st_xmax(geom),
  st_y(st_centroid(geom)) as centroid_lat,
  st_x(st_centroid(geom)) as centroid_long,
  st_npoints((geom)),
  st_geometrytype(geom),
  st_astext(geom),
  st_srid((geom)),
  st_isvalid(geom) as isvalid
from geo_cities
where name in ('East Point', 'Atlanta');

select *
from geo_greenspace
where owner = 'City of Atlanta';

select *
from geo_greenspace;

-- drop table atl_greenspaces;

-- Finds the greenspaces within a specified city...
with city as
(
  select *
  from geo_cities
  where name = 'Atlanta'
)
select distinct b.objectid, b.name, b.owner, b.management, b.type, b.geom
--select count(*) as cnt
into atl_greenspaces
from city as a cross join geo_greenspace as b
where st_contains(a.geom, b.geom)
--  or b.owner = 'City of Atlanta';
-- 488

/*
Found that many greenspaces are far outside of the city of limits.
I'm going to exclude them.
*/

select count(*) as cnt
from atl_greenspaces
where owner = 'City of Atlanta';

with city as
(
  select *
  from geo_cities
  where name = 'Atlanta'
)
select b.name, b.owner
--select count(*) as cnt
from city as a cross join geo_greenspace as b
where st_covers(a.geom, b.geom);
-- 488

with city as
(
  select *
  from geo_cities
  where name = 'Atlanta'
)
select b.name, b.owner
--select count(*) as cnt
from city as a cross join geo_greenspace as b
where st_containsproperly(a.geom, b.geom);
-- 488

-- drop table atl_greenspaces

select count(*)
from stage_greenspace;


with city as
(
  select *
  from geo_cities
  where name = 'Atlanta'
)
select b.objectid, b.name, b.owner, b.management, b.type, b.geom
into atl_greenspaces
from city as a cross join geo_greenspace as b
where st_intersects(a.geom, b.geom);
-- 501



select name, geom
into atl_limits
from geo_cities
where name = 'Atlanta'

select st_asgeojson(geom)
from output;


-- Checking on distance between two parks...
;with piedmont_park AS
(
  select * from geo_greenspace where name = 'Piedmont Park'
),
brookdale_park AS
(
  select * from geo_greenspace where name = 'Brookdale Park'
)
select
  st_distance_sphere(piedmont_park.geom, brookdale_park.geom) * .00062137119223733 as distance
from brookdale_park, piedmont_park;

select
  name,
  st_buffer(geom, 500) as the_buffer
from geo_greenspace
limit 15;

-- Check table size...
SELECT *,
    pg_size_pretty(total_bytes) AS total,
    pg_size_pretty(index_bytes) AS INDEX,
    pg_size_pretty(toast_bytes) AS toast,
    pg_size_pretty(table_bytes) AS TABLE
  FROM (
  SELECT *, total_bytes-index_bytes-COALESCE(toast_bytes,0) AS table_bytes FROM (
      SELECT c.oid,nspname AS table_schema, relname AS TABLE_NAME
              , c.reltuples AS row_estimate
              , pg_total_relation_size(c.oid) AS total_bytes
              , pg_indexes_size(c.oid) AS index_bytes
              , pg_total_relation_size(reltoastrelid) AS toast_bytes
          FROM pg_class c
          LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
          WHERE relkind = 'r'
  ) a
where a.table_name like 'geo%'
) a;


select *
from geo_greenspace
where name = 'Piedmont Park';