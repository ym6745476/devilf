import 'df_image_layer.dart';
import 'df_layer_type.dart';
import 'df_map_layer.dart';
import 'df_object_group.dart';
import 'df_tile_layer.dart';

class DFGroupLayer extends DFMapLayer {
  List<DFMapLayer>? layers;

  DFGroupLayer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'].toString();
    visible = json['visible'];
    opacity = double.tryParse(json['opacity'].toString()) ?? 0.0;
    x = double.tryParse(json['x'].toString()) ?? 0.0;
    y = double.tryParse(json['y'].toString()) ?? 0.0;

    if (json['layers'] != null) {
      layers = <DFMapLayer>[];
      json['layers'].forEach((v) {
        if (v['type'] == DFLayerType.tileLayer) {
          layers?.add(DFTileLayer.fromJson(v));
        } else if (v['type'] == DFLayerType.objectGroup) {
          layers?.add(DFObjectGroup.fromJson(v));
        } else if (v['type'] == DFLayerType.imageLayer) {
          layers?.add(DFImageLayer.fromJson(v));
        } else if (v['type'] == DFLayerType.group) {
          layers?.add(DFGroupLayer.fromJson(v));
        } else {
          layers?.add(DFMapLayer.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.layers != null) {
      data['layers'] = this.layers?.map((v) => v.toJson()).toList();
    }
    data['opacity'] = this.opacity;
    data['type'] = this.type;
    data['visible'] = this.visible;
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}
