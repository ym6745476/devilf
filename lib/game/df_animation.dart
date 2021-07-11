
/// 动画常量
class DFAnimation{

  /// 动画类型
  static const String NONE = "NONE";
  static const String IDLE = "IDLE";
  static const String RUN = "RUN";
  static const String ATTACK = "ATTACK";
  static const String CASTING = "CASTING";
  static const String DIG = "DIG";

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

    IDLE + LEFT,       //0
    IDLE + UP_LEFT,    //1
    IDLE + UP,         //2
    IDLE + UP_RIGHT,   //3
    IDLE + RIGHT,      //4
    IDLE + DOWN_RIGHT, //5
    IDLE + DOWN,       //6
    IDLE + DOWN_LEFT,  //7

    RUN + LEFT,        //8
    RUN + UP_LEFT,     //9
    RUN + UP,          //10
    RUN + UP_RIGHT,    //11
    RUN + RIGHT,       //12
    RUN + DOWN_RIGHT,  //13
    RUN + DOWN,        //14
    RUN + DOWN_LEFT    //15

  ];


}
