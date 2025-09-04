package com.example.rocketsale_rs

import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.rocketsale_rs/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "startService") {
                    val username = call.argument<String>("username") ?: "unknown"
                    val userId = call.argument<String>("userId") ?: "0"

                    val serviceIntent = Intent(this, LocationService::class.java).apply {
                        putExtra("username", username)
                        putExtra("userId", userId)
                    }

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(serviceIntent)
                    } else {
                        startService(serviceIntent)
                    }

                    result.success(null)
                } else if (call.method == "stopService") {
                    val serviceIntent = Intent(this, LocationService::class.java)
                    stopService(serviceIntent)
                    result.success(null)
                } else if (call.method == "isSocketConnected") {
                    result.success(LocationService.isSocketConnected)
                } else {
                    result.notImplemented()
                }
            }
    }
}
