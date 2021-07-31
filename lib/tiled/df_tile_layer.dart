
import 'df_map_layer.dart';

class DFTileLayer extends DFMapLayer {
  List<int>? data;
  double? height;
  double? width;

  DFTileLayer({
    this.data,
    this.height,
    this.width,
  });

  DFTileLayer.fromJson(Map<String, dynamic> json) {
    data = json['data'].cast<int>();
    height = double.tryParse(json['height'].toString()) ?? 0.0;
    id = json['id'];
    name = json['name'];
    opacity = double.tryParse(json['opacity'].toString()) ?? 0.0;
    type = json['type'].toString();
    visible = json['visible'];
    width = double.tryParse(json['width'].toString()) ?? 0.0;
    x = double.tryParse(json['x'].toString()) ?? 0.0;
    y = double.tryParse(json['y'].toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['height'] = this.height;
    data['id'] = this.id;
    data['name'] = this.name;
    data['opacity'] = this.opacity;
    data['type'] = this.type;
    data['visible'] = this.visible;
    data['width'] = this.width;
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}
