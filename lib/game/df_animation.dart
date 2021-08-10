
/// 动作常量
class DFAction {
  /// 角色动作类型
  static const String NONE = "NONE";
  static const String IDLE = "IDLE";
  static const String RUN = "RUN";
  static const String ATTACK = "ATTACK";
  static const String CASTING = "CASTING";
  static const String DIG = "DIG";
  static const String DEATH = "DEATH";
  static const String TRACK = "TRACK";
  static const String EXPLODE = "EXPLODE";
  static const String SURROUND = "SURROUND";
}

/// 方向常量
class DFDirection {
  static const String NONE = "_NONE";
  static const String LEFT = "_LEFT";
  static const String UP_LEFT = "_UP_LEFT";
  static const String UP = "_UP";
  static const String UP_RIGHT = "_UP_RIGHT";
  static const String RIGHT = "_RIGHT";
  static const String DOWN_RIGHT = "_DOWN_RIGHT";
  static const String DOWN = "_DOWN";
  static const String DOWN_LEFT = "_DOWN_LEFT";
}

/// 动画常量
class DFAnimation {

  /// 将动画类型用数字编号
  static final List<String> sequence = [
    DFAction.IDLE + DFDirection.LEFT, //0
    DFAction.IDLE + DFDirection.UP_LEFT, //1
    DFAction.IDLE + DFDirection.UP, //2
    DFAction.IDLE + DFDirection.UP_RIGHT, //3
    DFAction.IDLE + DFDirection.RIGHT, //4
    DFAction.IDLE + DFDirection.DOWN_RIGHT, //5
    DFAction.IDLE + DFDirection.DOWN, //6
    DFAction.IDLE + DFDirection.DOWN_LEFT, //7

    DFAction.RUN + DFDirection.LEFT, //8
    DFAction.RUN + DFDirection.UP_LEFT, //9
    DFAction.RUN + DFDirection.UP, //10
    DFAction.RUN + DFDirection.UP_RIGHT, //11
    DFAction.RUN + DFDirection.RIGHT, //12
    DFAction.RUN + DFDirection.DOWN_RIGHT, //13
    DFAction.RUN + DFDirection.DOWN, //14
    DFAction.RUN + DFDirection.DOWN_LEFT, //15

    DFAction.ATTACK + DFDirection.LEFT, //16
    DFAction.ATTACK + DFDirection.UP_LEFT, //17
    DFAction.ATTACK + DFDirection.UP, //18
    DFAction.ATTACK + DFDirection.UP_RIGHT, //19
    DFAction.ATTACK + DFDirection.RIGHT, //20
    DFAction.ATTACK + DFDirection.DOWN_RIGHT, //21
    DFAction.ATTACK + DFDirection.DOWN, //22
    DFAction.ATTACK + DFDirection.DOWN_LEFT, //23

    DFAction.CASTING + DFDirection.LEFT, //24
    DFAction.CASTING + DFDirection.UP_LEFT, //25
    DFAction.CASTING + DFDirection.UP, //26
    DFAction.CASTING + DFDirection.UP_RIGHT, //27
    DFAction.CASTING + DFDirection.RIGHT, //28
    DFAction.CASTING + DFDirection.DOWN_RIGHT, //29
    DFAction.CASTING + DFDirection.DOWN, //30
    DFAction.CASTING + DFDirection.DOWN_LEFT, //31

    DFAction.DIG + DFDirection.LEFT, //32
    DFAction.DIG + DFDirection.UP_LEFT, //33
    DFAction.DIG + DFDirection.UP, //34
    DFAction.DIG + DFDirection.UP_RIGHT, //35
    DFAction.DIG + DFDirection.RIGHT, //36
    DFAction.DIG + DFDirection.DOWN_RIGHT, //37
    DFAction.DIG + DFDirection.DOWN, //38
    DFAction.DIG + DFDirection.DOWN_LEFT, //39

    DFAction.DEATH + DFDirection.LEFT, //40
    DFAction.DEATH + DFDirection.UP_LEFT, //41
    DFAction.DEATH + DFDirection.UP, //42
    DFAction.DEATH + DFDirection.UP_RIGHT, //43
    DFAction.DEATH + DFDirection.RIGHT, //44
    DFAction.DEATH + DFDirection.DOWN_RIGHT, //45
    DFAction.DEATH + DFDirection.DOWN, //46
    DFAction.DEATH + DFDirection.DOWN_LEFT, //47

    DFAction.TRACK + DFDirection.UP, //48
    DFAction.EXPLODE + DFDirection.UP, //49
    DFAction.SURROUND + DFDirection.UP, //50

  ];
}
