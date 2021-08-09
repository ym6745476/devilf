import 'df_tile.dart';

class DFTileSet {
  int? id;
  int? columns;
  int? firsTgId;
  String? image;
  int? imageHeight;
  int? imageWidth;
  int? margin;
  String? name;
  int? spacing;
  int? tileCount;
  int? tileHeight;
  int? tileWidth;
  List<DFTile>? tiles;

  DFTileSet({this.firsTgId});

  DFTileSet.fromJson(Map<String, dynamic> json) {
    firsTgId = json['firstgid'];
    columns = json['columns'];
    image = json['image'];
    imageHeight = json['imageheight'];
    imageWidth = json['imagewidth'];
    margin = json['margin'];
    name = json['name'];
    spacing = json['spacing'];
    tileCount = json['tilecount'];
    tileHeight = json['tileheight'];
    tileWidth = json['tilewidth'];
    if(json['tiles']!=null){
      tiles = List.generate(json['tiles'].length, (index) => DFTile.fromJson(json['tiles'][index]));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firsTgId'] = this.firsTgId;
    data['columns'] = this.columns;
    data['image'] = this.image;
    data['imageHeight'] = this.imageHeight;
    data['imageWidth'] = this.imageWidth;
    data['margin'] = this.margin;
    data['name'] = this.name;
    data['spacing'] = this.spacing;
    data['tileCount'] = this.tileCount;
    data['tileHeight'] = this.tileHeight;
    data['tileWidth'] = this.tileWidth;
    data['tiles'] = this.tiles;
    return data;
  }
}
