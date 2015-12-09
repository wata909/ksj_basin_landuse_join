CREATE TABLE w07_09_select AS SELECT w07_001,w07_002,w07_003,w07_004,w07_005,w07_006, CAST (w07_002 as integer) * 1000 + CAST (w07_006 as integer) as w07_026, geom FROM w07_09 WHERE w07_002 <> 'unknown' ORDER BY w07_001;
ALTER TABLE w07_09_select ADD COLUMN gid serial primary key;
CREATE INDEX "w07_09_select_geom" ON w07_09_select USING gist (geom);

CREATE TABLE w07_l03_09_select_join AS SELECT c1.w07_001,c1.w07_002,c1.w07_003,c1.w07_004,c1.w07_005,c1.w07_006,c1.w07_026,c2."土地利用種" as lu, c1.geom 
  FROM w07_09_select c1,
       l03_09 c2
  WHERE c1.w07_001::text = c2."メッシュ"::text AND c1.w07_002::text <> 'unknown'::text
  ORDER BY c1.w07_001;
ALTER TABLE w07_l03_09_select_join ADD COLUMN gid serial primary key;
CREATE INDEX "w07_l03_09_select_join_geom" ON w07_l03_09_select_join USING gist (geom);