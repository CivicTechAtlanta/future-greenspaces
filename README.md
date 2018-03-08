# future-greenspaces

This project was started at the greenspaces hackaton. Below are the initial notes:

### First Goal: 100% of people w/n walking distance of public greenspace by 2022

- Safe walking distance for food <= 1 mile
- Current estimate = 42% of people near public greenspace
- Current idea: 500 acres of new green space
- Maybe sensitize to 90-95% if 100% requires a big acreage increase?

- Where should we put the green space?
- Is 500 acres enough or too much?

__Goal:__ Identify minimum amount of acres required to full coverage and their respective locations

__Deliverable:__ Map with proposed locations

__Constraints:__
- Minimum green space size: .5 acre
- Max size - 500 acre
- Not considering highways/train tracks
- No Parcel limitations
- Max walking distance - 0.5 from GS border
- No topography

__Data requirements:__
1. Current parks sizes + locations: 
    - http://opendata.atlantaregional.com/datasets/greenspace?geometry=-84.478%2C33.729%2C-84.333%2C33.754&selectedAttribute=ACRES

2. Population density/ distribution: 
    - Housing per zipcode: https://www.huduser.gov/portal/datasets/HUD_data_matrix.html
    - Census data at a block group level: http://opendata.atlantaregional.com/datasets/total-population-2016
    - Plot size data (from Atlanta GIS): https://dpcd-coaplangis.opendata.arcgis.com/datasets/parcels?geometry=-84.582%2C33.743%2C-84.256%2C33.793&selectedAttribute=ADDRESS2


### Second Goal: Optimize Tree Canopy on main thoroughfares with upcoming bike lanes
- Want to provide ideas of where to place new trees and where best trees currently are
- Maybe mock-up of way to mark dead trees in danger of falling

#### Geopandas Logic (added by August):
- To get population for each parcel:
1. For each block group: 
    1. use geopandas intersect function to find all parcels that fall into that group
2. For each parcel in the group: 
    1. calculate % of group area that parcel takes up
    2. Use area % to calculate population for that parcel based on group total population. (Assumes equal population density in a block group)
    3. Assign that population to each parcel

- To get parcel park distance:
1. Add 0.5 mile buffer (using geopandas buffer function) around all existing parks
2. Find all parcels that intersect with existing park buffer zones. Exclude from parcel list
3. Add 0.5 mile buffer around all remaining parcels
4. For each parcel’s buffer zone:
    a. Sum population of all parcels that intersect with the zone.
        -Include or exclude the parcel that is being tested??
5. Rank all parcels’ buffer zones by affected population
6. Declare parcel with highest affected population a “New Park”
7. Exclude “New Park” and all parcels intersecting with “New Park’s” buffer zone.
8. Start over at step #4 and loop until 80-90% of parcels are within a park’s buffer zone


Calculation Logic: Geopandas function to calculate distance between two points (dot distance)
- 3 inputs: location of green spaces, population density by block, parcels (all inputs have an x and y coordinate)
- Check distance of each parcel to each park until you find a park that is less than 0.5 miles away. If less than 0.5 miles, save that parcel into separate table of parcels near a park [TABLE A]. If there is no park within 0.5 mile of a park, save to another list (TABLE B).
- Looking at TABLE B, identify all adjacent parcels to each parcel on the list that are less than 0.5 miles away.
