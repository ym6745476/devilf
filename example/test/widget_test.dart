import 'package:devilf_engine/util/df_util.dart';

void main() {
  /// 一维数组转二维数组
  List<int> data = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0];
  List<List<int>> newData = DFUtil.to2dList(data, 5, 1);
  print("一维数组转二维数组:" + newData.toString());

}
