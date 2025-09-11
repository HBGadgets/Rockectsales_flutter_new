package com.example.rocketsale_rs.rocketsales

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.KeyData.CHANNEL
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.rocketsale_rs/native"
    private val LOCATION_PERMISSION_REQUEST = 1001

    private var pendingUsername: String? = null
    private var pendingUserId: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startService" -> {
                        val username = call.argument<String>("username") ?: "unknown"
                        val userId = call.argument<String>("userId") ?: "0"
                        Log.d("LocationService", "called before location check")
                        startLocationService(username, userId)

                        result.success(null)
                    }

                    "stopService" -> {
                        val serviceIntent = Intent(this, LocationService::class.java)
                        stopService(serviceIntent)
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    // --- Permission helpers ---
    private fun hasLocationPermission(): Boolean {
        return ActivityCompat.checkSelfPermission(
            this, Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(
                    this, Manifest.permission.ACCESS_COARSE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(
                    this, Manifest.permission.ACCESS_BACKGROUND_LOCATION
                ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestLocationPermission() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.ACCESS_BACKGROUND_LOCATION
            ),
            LOCATION_PERMISSION_REQUEST
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == LOCATION_PERMISSION_REQUEST) {
            if (grantResults.isNotEmpty() && grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
                // ✅ start service if username/userId were waiting
                pendingUsername?.let { u ->
                    pendingUserId?.let { id ->
                        startLocationService(u, id)
                    }
                }
            } else {
                Toast.makeText(this, "Location permission required!", Toast.LENGTH_SHORT).show()
            }
            // clear pending
            pendingUsername = null
            pendingUserId = null
        }
    }

    // --- Start the service ---
    private fun startLocationService(username: String, userId: String) {
        val serviceIntent = Intent(this, LocationService::class.java).apply {
            putExtra("username", username)
            putExtra("userId", userId)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }
    }
}


//class MainActivity : FlutterActivity() {
//    private val CHANNEL = "com.example.rocketsale_rs/native"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//            .setMethodCallHandler { call, result ->
//                if (call.method == "startService") {
//                    val username = call.argument<String>("username") ?: "unknown"
//                    val userId = call.argument<String>("userId") ?: "0"
//
//                    val serviceIntent = Intent(this, LocationService::class.java).apply {
//                        putExtra("username", username)
//                        putExtra("userId", userId)
//                    }
//
//                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                        startForegroundService(serviceIntent)
//                    } else {
//                        startService(serviceIntent)
//                    }
//
//                    result.success(null)
//                } else if (call.method == "stopService") {
//                    val serviceIntent = Intent(this, LocationService::class.java)
//                    stopService(serviceIntent)
//                    result.success(null)
//                } else {
//                    result.notImplemented()
//                }
//            }
//    }
//}