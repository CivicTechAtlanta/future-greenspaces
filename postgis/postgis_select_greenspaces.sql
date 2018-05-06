drop table if exists atl_greenspaces;

-- Finds the greenspaces within the City of Atlanta shapefile...
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
-- 488

select *
from atl_greenspaces;





