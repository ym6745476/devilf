package dev.ym101.devilf;

import android.os.Bundle;
import android.util.Log;

import org.json.JSONStringer;

import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;

/**
 *  如果从其他页面进入Flutter页面可以像下面这样写：
 *  Intent intent = new Intent(activity, MainActivity.class);
 *  intent.putExtra("route","/hello");
 *  startActivity(intent);
 */
public class MainActivity extends FlutterActivity {

    private static final String FLUTTER_CHANNEL = "sample.flutter.io/flutter";
    private static final String NATIVE_CHANNEL = "sample.flutter.io/native";
    private static final String NATIVE_METHOD = "callFlutter";
    private static final String FLUTTER_METHOD = "callNative";

    FlutterEngine flutterEngine;

    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);

        //从Intent里获取route 路径
        String route = getIntent().getStringExtra("route");
        if(route == null || route == ""){
            route = "/";
        }

        //InitialRoute
        flutterEngine = getFlutterEngine();
        flutterEngine.getNavigationChannel().setInitialRoute(route);
        flutterEngine.getDartExecutor().executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault());

        //监听Flutter调用Native
        MethodChannel methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), FLUTTER_CHANNEL);
        methodChannel.setMethodCallHandler((call, result) -> {
            if (call.method.equals(FLUTTER_METHOD)) {
                doCallNative((HashMap)call.arguments,result);
                result.success("Native接到消息：" + call.arguments);
            } else {
                result.notImplemented();
            }
        });

        //向Flutter传递数据
        callFlutter();
    }

    /**
     * 调用Flutter
     */
    public void callFlutter(){
        Log.e("MainActivity","调用Flutter start");

        String arguments = "{\"test\":false,\"token\":\"ASDFGHJKL\",\"userId\":1}";

        MethodChannel methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), NATIVE_CHANNEL);
        methodChannel.invokeMethod(NATIVE_METHOD, arguments, new MethodChannel.Result() {

            @Override
            public void success(Object o) {
                Log.e("MainActivity","调用Flutter success");
            }

            @Override
            public void error(String s, String s1, Object o) {
                Log.e("MainActivity","调用Flutter error");
            }

            @Override
            public void notImplemented() {

            }
        });
    }

    /**
     * 你的代码写处理逻辑
     * @param messageMap
     * @param result
     */
    public void doCallNative(HashMap messageMap,MethodChannel.Result result){
        String message = (String)messageMap.get("message");
        //你的代码
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (flutterEngine!=null){
            flutterEngine.getLifecycleChannel().appIsResumed();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (flutterEngine!=null){
            flutterEngine.getLifecycleChannel().appIsInactive();
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (flutterEngine!=null){
            flutterEngine.getLifecycleChannel().appIsPaused();
        }
    }
}
