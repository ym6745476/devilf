/// 动画常量
class DFAnimation {
  /// 动画类型
  static const String NONE = "NONE";
  static const String IDLE = "IDLE";
  static const String RUN = "RUN";
  static const String ATTACK = "ATTACK";
  static const String CASTING = "CASTING";
  static const String DIG = "DIG";
  static const String DEATH = "DEATH";

  static const String TRACK = "TRACK";
  static const String EXPLODE = "EXPLODE";

  static const String LEFT = "_LEFT";
  static const String UP_LEFT = "_UP_LEFT";
  static const String UP = "_UP";
  static const String UP_RIGHT = "_UP_RIGHT";
  static const String RIGHT = "_RIGHT";
  static const String DOWN_RIGHT = "_DOWN_RIGHT";
  static const String DOWN = "_DOWN";
  static const String DOWN_LEFT = "_DOWN_LEFT";

  /// 将动画类型用数字编号
  static final List<String> sequence = [
    IDLE + LEFT, //0
    IDLE + UP_LEFT, //1
    IDLE + UP, //2
    IDLE + UP_RIGHT, //3
    IDLE + RIGHT, //4
    IDLE + DOWN_RIGHT, //5
    IDLE + DOWN, //6
    IDLE + DOWN_LEFT, //7

    RUN + LEFT, //8
    RUN + UP_LEFT, //9
    RUN + UP, //10
    RUN + UP_RIGHT, //11
    RUN + RIGHT, //12
    RUN + DOWN_RIGHT, //13
    RUN + DOWN, //14
    RUN + DOWN_LEFT, //15

    ATTACK + LEFT, //16
    ATTACK + UP_LEFT, //17
    ATTACK + UP, //18
    ATTACK + UP_RIGHT, //19
    ATTACK + RIGHT, //20
    ATTACK + DOWN_RIGHT, //21
    ATTACK + DOWN, //22
    ATTACK + DOWN_LEFT, //23

    CASTING + LEFT, //24
    CASTING + UP_LEFT, //25
    CASTING + UP, //26
    CASTING + UP_RIGHT, //27
    CASTING + RIGHT, //28
    CASTING + DOWN_RIGHT, //29
    CASTING + DOWN, //30
    CASTING + DOWN_LEFT, //31

    DIG + LEFT, //32
    DIG + UP_LEFT, //33
    DIG + UP, //34
    DIG + UP_RIGHT, //35
    DIG + RIGHT, //36
    DIG + DOWN_RIGHT, //37
    DIG + DOWN, //38
    DIG + DOWN_LEFT, //39

    DEATH + LEFT, //40
    DEATH + UP_LEFT, //41
    DEATH + UP, //42
    DEATH + UP_RIGHT, //43
    DEATH + RIGHT, //44
    DEATH + DOWN_RIGHT, //45
    DEATH + DOWN, //46
    DEATH + DOWN_LEFT, //47

    TRACK + LEFT, //40
    TRACK + UP_LEFT, //41
    TRACK + UP, //42
    TRACK + UP_RIGHT, //43
    TRACK + RIGHT, //44
    TRACK + DOWN_RIGHT, //45
    TRACK + DOWN, //46
    TRACK + DOWN_LEFT, //47

    EXPLODE + LEFT, //40
    EXPLODE + UP_LEFT, //41
    EXPLODE + UP, //42
    EXPLODE + UP_RIGHT, //43
    EXPLODE + RIGHT, //44
    EXPLODE + DOWN_RIGHT, //45
    EXPLODE + DOWN, //46
    EXPLODE + DOWN_LEFT, //47

  ];
}
