# ksj_basin_landuse_join

国土数値情報の土地利用細分メッシュおよび流域メッシュをPostgreSQLにインポートし，結合するためのスクリプト．ライセンスは CC0 1.0 Universal

##使用したデータ
国土数値情報JPGIS2.1形式の流域メッシュ http://nrb-www.mlit.go.jp/ksj/gml/datalist/KsjTmplt-W07.html および，土地利用細分メッシュデータH21年度版 http://nrb-www.mlit.go.jp/ksj/gml/datalist/KsjTmplt-L03-b.html ．
実質的には，ダウンロードしたデータに含まれるShapefile形式のデータを使用．

まず，流域メッシュデータをPostgreSQL+PostGISサーバーに格納．  
ただし元データは，日本全国結合したファイルがあるわけじゃない．よって，解凍してできたファイル一つ一つ読み込むことになる．

参考は， http://qiita.com/yellow_73/items/f2d8388e88d534066bc0

まず，

```
 shp2pgsql -p -S -W cp932 -D -I -s 4326 W07-09_5440-jgd_ValleyMesh.shp w07_09 > ..\table.sql
```

で，テーブルを作るためのsqlを作成．

