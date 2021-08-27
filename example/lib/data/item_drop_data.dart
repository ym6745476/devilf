import 'package:example/model/drop_item_info.dart';

/// 掉落数据
class ItemDropData {
  /// 数据
  static List<DropItemInfo> items = [

    DropItemInfo(10, template: "100", count: 1, probability: 0.5),
    DropItemInfo(11, template: "101", count: 1, probability: 0.5),
    DropItemInfo(12, template: "102", count: 1, probability: 0.5),
    DropItemInfo(13, template: "103", count: 1, probability: 0.5),
    DropItemInfo(14, template: "104", count: 1, probability: 0.5),
    DropItemInfo(15, template: "105", count: 1, probability: 0.5),
    DropItemInfo(16, template: "106", count: 1, probability: 0.5),
    DropItemInfo(17, template: "107", count: 1, probability: 0.5),
    DropItemInfo(18, template: "108", count: 1, probability: 0.5),
    DropItemInfo(19, template: "109", count: 1, probability: 0.5),
    DropItemInfo(20, template: "110", count: 1, probability: 0.5),

    DropItemInfo(100, template: "1000", count: 1, probability: 0.5),
    DropItemInfo(101, template: "1001", count: 1, probability: 0.5),
    DropItemInfo(102, template: "2001", count: 1, probability: 0.5),
    DropItemInfo(103, template: "3001", count: 1, probability: 0.5),
    DropItemInfo(104, template: "1100", count: 1, probability: 0.5),
    DropItemInfo(105, template: "1101", count: 1, probability: 0.5),
    DropItemInfo(106, template: "1102", count: 1, probability: 0.5),
    DropItemInfo(107, template: "1103", count: 1, probability: 0.5),
    DropItemInfo(108, template: "1104", count: 1, probability: 0.5),
    DropItemInfo(109, template: "2104", count: 1, probability: 0.5),
    DropItemInfo(110, template: "3104", count: 1, probability: 0.5),
    DropItemInfo(111, template: "1200", count: 1, probability: 0.5),
    DropItemInfo(112, template: "1201", count: 1, probability: 0.5),
    DropItemInfo(113, template: "1202", count: 1, probability: 0.5),
    DropItemInfo(114, template: "1203", count: 1, probability: 0.5),
    DropItemInfo(115, template: "1204", count: 1, probability: 0.5),
    DropItemInfo(116, template: "2204", count: 1, probability: 0.5),
    DropItemInfo(117, template: "3204", count: 1, probability: 0.5),

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
