class DFMapLayer {
  int? id;
  String? name;
  bool? visible;
  double? x;
  double? y;
  String? type;
  double? opacity;

  DFMapLayer({this.id, this.name, this.type, this.visible, this.x, this.y, this.opacity});

  DFMapLayer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'].toString();
    visible = json['visible'];
    opacity = double.tryParse(json['opacity'].toString()) ?? 0.0;
    x = double.parse(json['x'].toString());
    y = double.parse(json['y'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['visible'] = this.visible;
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}
