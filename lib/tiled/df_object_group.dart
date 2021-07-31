import 'df_map_layer.dart';
import 'df_objects.dart';

class DFObjectGroup extends DFMapLayer {
  String? drawOrder;
  List<DFObjects>? objects;

  DFObjectGroup({
    this.drawOrder,
    this.objects,
  });

  DFObjectGroup.fromJson(Map<String, dynamic> json) {
    drawOrder = json['draworder'];
    id = json['id'];
    name = json['name'];
    if (json['objects'] != null) {
      objects = <DFObjects>[];
      json['objects'].forEach((v) {
        objects?.add(new DFObjects.fromJson(v));
      });
    }
    opacity = double.parse(json['opacity'].toString());
    type = json['type'].toString();
    visible = json['visible'];
    x = double.tryParse(json['x'].toString()) ?? 0.0;
    y = double.tryParse(json['y'].toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['draworder'] = this.drawOrder;
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.objects != null) {
      data['objects'] = this.objects?.map((v) => v.toJson()).toList();
    }
    data['opacity'] = this.opacity;
    data['type'] = this.type;
    data['visible'] = this.visible;
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}
