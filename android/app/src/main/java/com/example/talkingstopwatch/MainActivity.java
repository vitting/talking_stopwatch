package com.example.talkingstopwatch;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import java.util.ArrayList;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static android.app.Notification.EXTRA_NOTIFICATION_ID;

public class MainActivity extends FlutterActivity implements MethodCallHandler, StreamHandler {
    private static final String CHANNEL = "talking.stopwatch.dk/notification";
    private static final String EVENTCHANNEL = "talking.stopwatch.dk/stream";
    private static  final String NOTIFICATIONCHANNELID = "talking.stopwatch.dk/notification";
    public static EventSink mEventSink;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        // We use this because this class implements MethodCallHander
        MethodChannel channel = new MethodChannel(getFlutterView(), CHANNEL);
        // We use this because this class implements StreamHandler;
        channel.setMethodCallHandler(this);

        EventChannel eventChannel = new EventChannel(getFlutterView(), EVENTCHANNEL);
        eventChannel.setStreamHandler(this);

    }

    @SuppressWarnings("unchecked")
    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("showNotification")) {
            NotificationCompat.Builder builder;
            ArrayList<String> list = (ArrayList<String>) call.arguments;

            if (list.get(2).equals("play")) {
                builder = buildNotification(list.get(0), list.get(1), true);
            } else {
                builder = buildNotification(list.get(0), list.get(1), false);
            }

            NotificationManagerCompat notificationManager = NotificationManagerCompat.from(this);
            notificationManager.notify(0, builder.build());

            result.success("OKAY");
            if (mEventSink != null) {
                mEventSink.success("TESTER EN STREAM");
            }
        }

        if (call.method.equals("cancelNotification")) {
            NotificationManagerCompat notificationManager = NotificationManagerCompat.from(this);
            notificationManager.cancel(0);
            result.success("CANCEL");
        }

        if (call.method.equals("initializeNotification")) {
            result.success("INITIALIZED");
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

    private void createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = getString(R.string.channel_name);
            String description = getString(R.string.channel_description);
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(NOTIFICATIONCHANNELID, name, importance);
            channel.setDescription(description);
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    private NotificationCompat.Builder buildNotification(String title, String text, boolean play) {
        // On Tap show activity
        Intent intent = new Intent(this, this.getClass());
        intent.setFlags(Intent.FLAG_ACTIVITY_PREVIOUS_IS_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_CANCEL_CURRENT);

        // Action button click
        Intent buttonPressIntent = new Intent(this, NotificationActionBroardcastReceiver.class);
        buttonPressIntent.setAction("buttonPress");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            buttonPressIntent.putExtra(EXTRA_NOTIFICATION_ID, 0);
        }
        PendingIntent buttonPressPendingIntent =
                PendingIntent.getBroadcast(this, 0, buttonPressIntent, 0);

        createNotificationChannel();

        return new NotificationCompat.Builder(this, NOTIFICATIONCHANNELID)
                .setOngoing(true)
                .setSmallIcon(R.mipmap.notification_icon)
                .setContentTitle(title)
                .setContentText(text)
                .setSound(null)
                .setVibrate(null)
                .setShowWhen(false)
                .setOnlyAlertOnce(true)
                .setContentIntent(pendingIntent)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .addAction(play ? R.drawable.ic_play : R.drawable.ic_pause, "Trykmig", buttonPressPendingIntent);
    }
}
