package com.example.talkingstopwatch;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import static android.app.Notification.EXTRA_NOTIFICATION_ID;

class NotificationAction {
    private NotificationManagerCompat mNotificationManager;
    static final String CHANNEL = "talking.stopwatch.dk/notification";
    static final String EVENTCHANNEL = "talking.stopwatch.dk/stream";
    private Context mContext;

    NotificationAction(Context context) {
        this.mContext = context;

        createNotificationChannel();
        if (mNotificationManager == null) {
            mNotificationManager = NotificationManagerCompat.from(context);
        }
    }

    void showNotification(String title, String body, String actionButtonToShow, String button1Text, String button2Text) {
        NotificationCompat.Builder builder;
        boolean showPlay = actionButtonToShow != null && actionButtonToShow.equals("play");
        builder = buildNotification(title, body, button1Text, button2Text, showPlay);
        mNotificationManager.notify(0, builder.build());
    }

    void cancelNotification() {
        mNotificationManager.cancel(0);
    }

    private void createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = mContext.getString(R.string.channel_name);
            String description = mContext.getString(R.string.channel_description);
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel channel = new NotificationChannel(CHANNEL, name, importance);
            channel.setDescription(description);
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            NotificationManager notificationManager = mContext.getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    private NotificationCompat.Builder buildNotification(String title, String body, String buttonText, String button2Text, boolean showPlayButton) {
        // On Tap show activity
        Intent intent = new Intent(mContext, mContext.getClass());
        intent.setFlags(Intent.FLAG_ACTIVITY_PREVIOUS_IS_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(mContext, 0, intent, PendingIntent.FLAG_CANCEL_CURRENT);

        // Action button play/pause
        Intent playPauseIntent = new Intent(mContext, NotificationActionBroardcastReceiver.class);
        playPauseIntent
                .setAction("playPausePress")
                .putExtra("PLAYPAUSEBUTTONSTATUS", showPlayButton ? "action_play" : "action_pause");

        PendingIntent playPausePendingIntent =
                PendingIntent.getBroadcast(mContext, 0, playPauseIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        // Action button play/pause
        Intent resetIntent = new Intent(mContext, NotificationActionBroardcastReceiver.class);
        resetIntent
                .setAction("resetPress")
                .putExtra("RESETBUTTONSTATUS", "action_reset");

        PendingIntent resetPendingIntent =
                PendingIntent.getBroadcast(mContext, 0, resetIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            playPauseIntent.putExtra(EXTRA_NOTIFICATION_ID, 0);
            resetIntent.putExtra(EXTRA_NOTIFICATION_ID, 0);
        }

        return new NotificationCompat.Builder(mContext, CHANNEL)
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
                .addAction(showPlayButton ? R.drawable.ic_play : R.drawable.ic_pause, buttonText, playPausePendingIntent)
                .addAction(R.drawable.ic_reset, button2Text, resetPendingIntent);
    }
}
