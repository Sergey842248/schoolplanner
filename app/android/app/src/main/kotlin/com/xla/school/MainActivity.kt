package com.xla.school

import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant





class MainActivity : FlutterActivity() {
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

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGETCHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    UPDATEWIDGET -> {
                        MainActivityOldKt.updateWidgetDate(call, this)
                        result.success(true)
                    }
                    "getstartargument" -> {
                        result.success(startargument)
                    }
                    "hasplayservices" -> {
                        val googleApiAvailability = GoogleApiAvailability.getInstance()
                        val resultCode = googleApiAvailability.isGooglePlayServicesAvailable(this)
                        result.success(resultCode == ConnectionResult.SUCCESS)
                    }
                    else -> {
                        result.success(true)
                    }
                }
            }
    }
}
