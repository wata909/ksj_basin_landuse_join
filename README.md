# ksj_basin_landuse_join

国土数値情報の土地利用細分メッシュおよび流域メッシュをPostgreSQLにインポートし，結合した時の手順のまとめ．  
ただし，正しく動くかどうかは，ちょっと不明．  
ライセンスは CC0 1.0 Universal

##使用したデータ
国土数値情報JPGIS2.1形式の流域メッシュ http://nrb-www.mlit.go.jp/ksj/gml/datalist/KsjTmplt-W07.html および，土地利用細分メッシュデータH21年度版 http://nrb-www.mlit.go.jp/ksj/gml/datalist/KsjTmplt-L03-b.html ．
実質的には，ダウンロードしたデータに含まれるShapefile形式のデータを使用．

##手順
###前準備
動作環境はWin7 64bitです．  
まず，コマンドコンソールを立ち上げ，PostgreSQL\9.0(バージョン) の中のpg_env.bat を実行．これで，pathが通る．

###流域メッシュデータのImport
まず，流域メッシュデータをPostgreSQL+PostGISサーバーに格納．  
ただし元データは，日本全国結合したファイルがあるわけじゃない．よって，解凍してできたファイル一つ一つ読み込むことになる．

参考は， http://qiita.com/yellow_73/items/f2d8388e88d534066bc0

まず，

```
 shp2pgsql -p -S -W cp932 -D -I -s 4326 W07-09_5440-jgd_ValleyMesh.shp w07_09 > ..\table.sql
```

で，テーブルを作るためのsqlを作成．この後，テーブルの中身を読み込むためのsqlを作ればOK．たとえば，

```
 shp2pgsql -p -S -W cp932 -D -I -s 4326 W07-09_5440-jgd_ValleyMesh.shp w07_09 > ..\table.sql
```

で，こいつを

```
 psql -U postgres -h localhost -d river_mesh -f 5440.sql
```

見たいにして，全部流せばOK･･･のはずなんだけど，エラーが出てこけるメッシュがある．原因は，table.sqlのcreate文が

```
CREATE TABLE "w07_09" (gid serial,
"w07_001" varchar(10),
"w07_002" varchar(7),
"w07_003" varchar(10),
"w07_004" varchar(10),
"w07_005" varchar(16),
"w07_006" varchar(3));
```

となっているんだけど，ここでW07_004, 005が河川名とかが入るために，データ幅が足りなくなり，エラーが出るようである．なので，ここの部分を，

```
"w07_004" varchar(30),
"w07_005" varchar(30),
```

と，強引に書き換え．これで流すとOK．ちなみに，いちいち入力するのはめんどうなので，batファイルを作って自動化する．  import.batがそれ用のファイルです．

###流域メッシュデータと土地利用細分メッシュの結合
同様にして土地利用細分メッシュをインポートした後，細分メッシュコードをキーとして，結合する．SQL分は以下の通り．

```sql:selct_create_table_all.sql
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
```


