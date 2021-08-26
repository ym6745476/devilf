import 'package:example/model/drop_item_info.dart';

/// 掉落数据
class ItemDropData {
  /// 数据
  static List<DropItemInfo> items = [
    DropItemInfo(1, template: "1000", count: 1, probability: 0.5),
    DropItemInfo(2, template: "1001", count: 1, probability: 0.5),
    DropItemInfo(3, template: "2001", count: 1, probability: 0.5),
    DropItemInfo(4, template: "3001", count: 1, probability: 0.5),
    DropItemInfo(5, template: "1100", count: 1, probability: 0.5),
    DropItemInfo(6, template: "1101", count: 1, probability: 0.5),
    DropItemInfo(7, template: "1102", count: 1, probability: 0.5),
    DropItemInfo(8, template: "1103", count: 1, probability: 0.5),
    DropItemInfo(9, template: "1104", count: 1, probability: 0.5),
    DropItemInfo(10, template: "2104", count: 1, probability: 0.5),
    DropItemInfo(11, template: "3104", count: 1, probability: 0.5),
    DropItemInfo(12, template: "1200", count: 1, probability: 0.5),
    DropItemInfo(13, template: "1201", count: 1, probability: 0.5),
    DropItemInfo(14, template: "1202", count: 1, probability: 0.5),
    DropItemInfo(15, template: "1203", count: 1, probability: 0.5),
    DropItemInfo(16, template: "1204", count: 1, probability: 0.5),
    DropItemInfo(17, template: "2204", count: 1, probability: 0.5),
    DropItemInfo(18, template: "3204", count: 1, probability: 0.5),

  ];

  /// 获取掉落物品
  static DropItemInfo getDropItem(int id){
    DropItemInfo? dropItemInfo;
    for(DropItemInfo item in items){
      if(item.id == id){
        dropItemInfo = item;
      }
    }
    return dropItemInfo!;
  }
}
