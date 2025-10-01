package com.xla.school

import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    companion object {
        const val CHANNEL_ID = "com.xla.school.upcoming_events"
        private const val WIDGETCHANNEL = "com.xla.school.widget"
        private const val UPDATEWIDGET = "updateWidget"
    }

    private var startargument: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        intent?.let { i ->
            i.extras?.let { extras ->
                startargument = extras.getString("startargument")
            }
        }
        MainActivityOldKt.loadPlannerData(this)
    }
}
