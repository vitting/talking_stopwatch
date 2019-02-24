package com.example.talkingstopwatch;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class NotificationActionBroardcastReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction() == "buttonPress") {
            if (MainActivity.mEventSink != null) {
                MainActivity.mEventSink.success("SHIT DET VIRKER");
            }

        }
    }
}
