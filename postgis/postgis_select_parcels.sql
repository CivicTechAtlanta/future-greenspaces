select count(*)
from geo_parcels;
-- We have 165,850 parcels within the City of Atlanta parcel file...

select *
from geo_parcels
limit 250;

-- Lets see if all 165,850 parcels fall within the City of Atlanta limits...
drop table if exists atl_parcels;
with city as
(
  select *
  from geo_cities
  where name = 'Atlanta'
)
select distinct b.objectid, b.address1, b.address2, b.geom
into atl_parcels
from city as a cross join geo_parcels as b
where st_contains(a.geom, b.geom);
-- So only 164,301 parcels are contained in the City of Atlanta...


-- So 1,549 are outside of the city...strange...
-- Lets pull and plot them...
drop table if exists not_atl_parcels;
with city as
(
  select *
  from geo_cities
  where name = 'Atlanta'
)
select distinct b.objectid, b.address1, b.address2, b.geom
into not_atl_parcels
from city as a cross join geo_parcels as b
where not st_contains(a.geom, b.geom);

------------------------------------------------------------------
-- So we plotting both ATL and NOT ATL parcels it looks like they
-- are all good. I'm going to include them all.
------------------------------------------------------------------
drop table if exists atl_parcels;

select distinct objectid, address1, address2, geom
into atl_parcels
from geo_parcels;
----------------------------------------------------------------
select count(*) from atl_parcels;
-- 165850
----------------------------------------------------------------
