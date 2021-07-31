import 'df_map_layer.dart';

class DFImageLayer extends DFMapLayer {
  String image;

  DFImageLayer({
    required this.image,
  });

  DFImageLayer.fromJson(Map<String, dynamic> json) : image = json['image'] {
    id = json['id'];
    name = json['name'];
    type = json['type'].toString();
    visible = json['visible'];
    opacity = double.tryParse(json['opacity'].toString()) ?? 0.0;
    x = double.tryParse(json['x'].toString()) ?? 0.0;
    y = double.tryParse(json['y'].toString()) ?? 0.0;
  }
}
