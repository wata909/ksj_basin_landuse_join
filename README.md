# ksj_basin_landuse_join

国土数値情報の土地利用細分メッシュおよび流域メッシュをPostgreSQLにインポートし，結合するためのスクリプト．ライセンスは CC0 1.0 Universal

##使用したデータ
国土数値情報JPGIS2.1形式の流域メッシュ（http://nrb-www.mlit.go.jp/ksj/gml/datalist/KsjTmplt-W07.html）および，土地利用細分メッシュデータH21年度版（http://nrb-www.mlit.go.jp/ksj/gml/datalist/KsjTmplt-L03-b.html）．

実質的には，ダウンロードしたデータに含まれるShapefile形式のデータを使用．
