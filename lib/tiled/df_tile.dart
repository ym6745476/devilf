

class DFTile {
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

  DFTile({this.firsTgId});

  DFTile.fromJson(Map<String, dynamic> json) {
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
  }

}
