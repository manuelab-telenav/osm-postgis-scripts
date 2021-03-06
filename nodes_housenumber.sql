-- #Version: 0.1
-- #Author: Florin Badita
-- #Date: 01.12.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: This is usefull when you want to produce statistics about the housenumbers, to see in a visual way in Qgis who added housenumbers in a city, etc */
-- #Start Code

/* #TODO #FIXME
This will only load the nodes, but housenumbers are made out of ways and nodes.
In this form, this script will only load the nodes, not the ways */

/* Abrevations list 

relation_members = rl_
relations = r_
ways = w_
nodes = n_
users = u_
*/

-- # This is created so you don`t have problems loading the file into QGIS, and also so that QGIS will recognize this Column as the column that have only unique values
SELECT ROW_NUMBER() over () as id,
 user_id, tstamp, changeset_id, version, nodes.id as node_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 nodes.geom as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'name' As n_name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 nodes.tags->'addr:housenumber' As n_addr_housenumber,
 nodes.tags->'addr:interpolation' As n_addr_interpolation,
 nodes.tags->'addr:housename' As n_addr_housename,
 nodes.tags->'addr:city' As n_addr_city,
 nodes.tags->'addr:postcode' As n_addr_postcode,

-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'source' As n_source,
nodes.tags->'attribution' As n_attribution,
nodes.tags->'comment' As n_comment,
nodes.tags->'fixme' As n_fixme,
nodes.tags->'created_by' As n_created_by
FROM nodes,users
WHERE ST_GeometryType(geom) = 'ST_Point' AND users.id=nodes.user_id AND ((tags->'addr:housenumber')) is not null
