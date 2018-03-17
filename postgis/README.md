### PostGIS

https://postgis.net


I'm on a Mac so I'm using Postgres.app (https://postgresapp.com) which is PostgreSQL and PostGIS. To move forward you will need both of them installed.

Now we need to create a database and issue this command "create extension postgis" which will enable postgis in this database.

Now we need to load the shapefiles into Postgres. Below are the commands I used to do this.

* /Applications/Postgres.app/Contents/Versions/10/bin/shp2pgsql -I -s 4269 Greenspace/Greenspace.shp public.geo_greenspace | psql -U postgres -d greenspace

* /Applications/Postgres.app/Contents/Versions/10/bin/shp2pgsql -I -s 4269 parcels/Parcels.shp public.geo_parcels | psql -U postgres -d greenspace 

* /Applications/Postgres.app/Contents/Versions/10/bin/shp2pgsql -I -s 4269 TotalPop/Total_Population_2016.shp public.geo_total_pop_2016 | psql -U postgres -d greenspace 

* /Applications/Postgres.app/Contents/Versions/10/bin/shp2pgsql -I -s 4269 Cities_Georgia/Cities_Georgia.shp public.geo_cities | psql -U postgres -d greenspace

Your commands should be similiar except for how you get to the command shp2pgsql.

Once you have the data sets loaded you can start playing around with postgis commands on the spatial data. The postgis_process.sql should get you started.

I'm learning my way through this so I'll continue to add things to the sql file as I go.
