/// 生物类
class Living {
  /// 名字
  String name = "";

  /// 生命值
  double hp = 100;

  /// 最大生命值
  double maxHp = 100;

  /// 移动速度
  double moveSpeed = 1;

  /// 是否死亡
  bool isDead = false;

  /// 创建生物
  Living(this.name);
}
