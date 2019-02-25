package com.example.talkingstopwatch;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity implements MethodCallHandler, StreamHandler {
    public static EventSink mEventSink;
    private NotificationAction mNotificationAction;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        // We use this because this class implements MethodCallHander
        MethodChannel channel = new MethodChannel(getFlutterView(), NotificationAction.CHANNEL);
        // We use this because this class implements StreamHandler;
        channel.setMethodCallHandler(this);

        EventChannel eventChannel = new EventChannel(getFlutterView(), NotificationAction.EVENTCHANNEL);
        eventChannel.setStreamHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "showNotification":
                try {
                    mNotificationAction.showNotification(
                            call.argument("title"),
                            call.argument("body"),
                            call.argument("actionButtonToShow"),
                            call.argument("buttonText"),
                            call.argument("button2Text")
                    );
                } catch (NullPointerException e) {
                    result.error("Parameter error", null, e);
                }

                result.success(true);
                break;
            case "cancelNotification":
                mNotificationAction.cancelNotification();
                result.success(true);
                break;
            case "initializeNotification":
                mNotificationAction = new NotificationAction(this);
                result.success(true);
                break;
            default:
                result.success(false);
        }
    }

    @Override
    public void onListen(Object o, EventSink eventSink) {
        if (mEventSink == null) {
            mEventSink = eventSink;
        }
    }

    @Override
    public void onCancel(Object o) {
        mEventSink = null;
    }
}
