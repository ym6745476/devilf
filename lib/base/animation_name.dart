
/// 动画类型
enum AnimationName {

    NONE,
    IDLE_LEFT,
    IDLE_UP_LEFT,
    IDLE_UP,
    IDLE_UP_RIGHT,
    IDLE_RIGHT,
    IDLE_DOWN_RIGHT,
    IDLE_DOWN,
    IDLE_DOWN_LEFT,

    RUN_LEFT,
    RUN_UP_LEFT,
    RUN_UP,
    RUN_UP_RIGHT,
    RUN_RIGHT,
    RUN_DOWN_RIGHT,
    RUN_DOWN,
    RUN_DOWN_LEFT

}

/// 用数字编号
class AnimationSequence{

    static final List<AnimationName> sequence = [

        AnimationName.NONE,  //0
        AnimationName.IDLE_LEFT, //1
        AnimationName.IDLE_UP_LEFT,
        AnimationName.IDLE_UP,
        AnimationName.IDLE_UP_RIGHT,
        AnimationName.IDLE_RIGHT,
        AnimationName.IDLE_DOWN_RIGHT,
        AnimationName.IDLE_DOWN,
        AnimationName.IDLE_DOWN_LEFT,  //8

        AnimationName.RUN_LEFT,  //9
        AnimationName.RUN_UP_LEFT,
        AnimationName.RUN_UP,
        AnimationName.RUN_UP_RIGHT,
        AnimationName.RUN_RIGHT,
        AnimationName.RUN_DOWN_RIGHT,
        AnimationName.RUN_DOWN,
        AnimationName.RUN_DOWN_LEFT  //18

    ];
}


