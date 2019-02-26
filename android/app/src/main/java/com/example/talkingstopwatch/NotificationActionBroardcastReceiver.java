package com.example.talkingstopwatch;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class NotificationActionBroardcastReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        switch (intent.getAction()) {
            case "playPausePress":
                if (MainActivity.mEventSink != null) {
                    String currentButtonAction = intent.getStringExtra("PLAYPAUSEBUTTONSTATUS");

                    MainActivity.mEventSink.success(currentButtonAction);
                }
                break;
            case "resetPress":
                if (MainActivity.mEventSink != null) {
                    String currentButtonAction = intent.getStringExtra("RESETBUTTONSTATUS");

                    MainActivity.mEventSink.success(currentButtonAction);
                }
                break;
            case "exitPress":
                if (MainActivity.mEventSink != null) {
                    String currentButtonAction = intent.getStringExtra("EXITBUTTONSTATUS");

                    MainActivity.mEventSink.success(currentButtonAction);
                }
                break;
        }
    }
}
