SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "w07_09_2" (gid serial,
"w07_001" varchar(10),
"w07_002" varchar(7),
"w07_003" varchar(10),
"w07_004" varchar(30),
"w07_005" varchar(30),
"w07_006" varchar(5));
ALTER TABLE "w07_09_2" ADD PRIMARY KEY (gid);
SELECT AddGeometryColumn('','w07_09_2','geom','4326','POLYGON',2);
CREATE INDEX "w07_09_2_geom_gist" ON "w07_09_2" USING GIST ("geom");
COMMIT;
