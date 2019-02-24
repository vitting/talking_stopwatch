package com.example.talkingstopwatch;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

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
    private static final String NOTIFICATIONCHANNELID = "talking.stopwatch.dk/notification";
    public static EventSink mEventSink;
    private NotificationManagerCompat mNotificationManager;

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

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "showNotification":
                NotificationCompat.Builder builder;
                String title = call.argument("title");
                String body = call.argument("body");
                String actionButtonToShow = call.argument("actionButtonToShow");
                String buttonText = call.argument("buttonText");

                try {
                    boolean showPlay = actionButtonToShow != null && actionButtonToShow.equals("play");
                    builder = buildNotification(title, body, buttonText, showPlay);
                    mNotificationManager.notify(0, builder.build());
                } catch (NullPointerException e) {
                    result.error("Parameter error", null, e);
                }

                result.success(true);
                break;
            case "cancelNotification":
                mNotificationManager.cancel(0);
                result.success(true);
                break;
            case "initializeNotification":
                createNotificationChannel();
                if (mNotificationManager == null) {
                    mNotificationManager = NotificationManagerCompat.from(this);
                }

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

    // TODO: Set this on init
    private void createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = getString(R.string.channel_name);
            String description = getString(R.string.channel_description);
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel channel = new NotificationChannel(NOTIFICATIONCHANNELID, name, importance);
            channel.setDescription(description);
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    private NotificationCompat.Builder buildNotification(String title, String body, String buttonText, boolean showPlayButton) {
        // On Tap show activity
        Intent intent = new Intent(this, this.getClass());
        intent.setFlags(Intent.FLAG_ACTIVITY_PREVIOUS_IS_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_CANCEL_CURRENT);

        // Action button click
        Intent buttonPressIntent = new Intent(this, NotificationActionBroardcastReceiver.class);
        buttonPressIntent
                .setAction("buttonPress")
                .putExtra("BUTTONSTATUS", showPlayButton ? "action_play" : "action_pause");

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            buttonPressIntent.putExtra(EXTRA_NOTIFICATION_ID, 0);
        }

        PendingIntent buttonPressPendingIntent =
                PendingIntent.getBroadcast(this, 0, buttonPressIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        return new NotificationCompat.Builder(this, NOTIFICATIONCHANNELID)
                .setOngoing(true)
                .setSmallIcon(R.mipmap.notification_icon)
                .setContentTitle(title)
                .setContentText(body)
                .setSound(null)
                .setVibrate(null)
                .setShowWhen(false)
                .setOnlyAlertOnce(true)
                .setContentIntent(pendingIntent)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .addAction(showPlayButton ? R.drawable.ic_play : R.drawable.ic_pause, buttonText, buttonPressPendingIntent);
    }
}
