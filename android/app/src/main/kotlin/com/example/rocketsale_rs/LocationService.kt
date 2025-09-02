package com.example.rocketsale_rs

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import io.socket.client.IO
import io.socket.client.Socket
import org.json.JSONObject

class LocationService : Service(), LocationListener {
    private var socket: Socket? = null
    private lateinit var locationManager: LocationManager
    private var username: String = ""
    private var userId: String = ""

    override fun onCreate() {
        super.onCreate()
        startForegroundNotification()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        username = intent?.getStringExtra("username") ?: "unknown"
        userId = intent?.getStringExtra("userId") ?: "0"

        initSocket()
        startLocationUpdates()

        return START_STICKY
    }

    private fun startForegroundNotification() {
        val channelId = "location_channel"

        // Create Notification Channel for Android O+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Location Service",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }

        // Intent to launch MainActivity when user taps notification
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            notificationIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("RocketSale Tracking")
            .setContentText("Live location is being shared")
            .setSmallIcon(id.flutter.flutter_background_service.R.drawable.ic_bg_service_small)
            .setContentIntent(pendingIntent) // ✅ pass pendingIntent here
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setOngoing(true)
            .build()

        startForeground(1, notification)
    }


    private fun initSocket() {
        try {
            socket =
                IO.socket("https://salestrack.rocketsalestracker.com") // ⚡ change to your server
            socket?.connect()

            socket?.on(Socket.EVENT_CONNECT) {
                Log.d("LocationService", "Socket connected")
                val data = JSONObject()
                data.put("username", username)
                socket?.emit("registerUser", data)
            }
        } catch (e: Exception) {
            Log.e("LocationService", "Socket init error: ${e.message}")
        }
    }

    private fun startLocationUpdates() {
        locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        try {
            locationManager.requestLocationUpdates(
                LocationManager.GPS_PROVIDER,
                10000L, // every 10 sec
                10f,    // every 10 meters
                this
            )
        } catch (ex: SecurityException) {
            Log.e("LocationService", "Permission not granted", ex)
        }
    }

    override fun onLocationChanged(location: Location) {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val battery = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)

        val data = JSONObject()
        data.put("_id", userId)
        data.put("username", username)
        data.put("latitude", location.latitude)   // double ✅ OK
        data.put("longitude", location.longitude) // double ✅ OK
        data.put("batteryLevel", battery)         // int ✅ OK
        data.put("speed", location.speed.toDouble()) // 🔥 convert float → double
        data.put("timestamp", System.currentTimeMillis()) // long ✅ OK

        socket?.emit("sendLocation", data)
        Log.d("LocationService", "Location sent: $data")
    }


    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        socket?.disconnect()
        locationManager.removeUpdates(this)
    }

    override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
    override fun onProviderEnabled(provider: String) {}
    override fun onProviderDisabled(provider: String) {}
}
