package com.example.chaneltst

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private var isBlocked = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "screen_record_channel").setMethodCallHandler {
            call, result ->
            when (call.method) {
                "toggleScreenRecording" -> {
                    isBlocked = !isBlocked
                    if (isBlocked) {
                        window.setFlags(
                            WindowManager.LayoutParams.FLAG_SECURE,
                            WindowManager.LayoutParams.FLAG_SECURE
                        )
                    } else {
                        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    }
                    result.success(isBlocked)
                }
                "isScreenRecordingAllowed" -> {
                    result.success(!isBlocked)
                }
                else -> result.notImplemented()
            }
        }
    }
}
