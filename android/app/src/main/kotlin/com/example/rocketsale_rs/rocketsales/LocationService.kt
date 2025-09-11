package com.example.rocketsale_rs.rocketsales

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.*
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
    private var lastLocation: Location? = null

    // ✅ background handler thread for sending location
    private val handlerThread = HandlerThread("LocationServiceThread").apply { start() }
    private val handler = Handler(handlerThread.looper)

    private val sendInterval = 10000L // 10 seconds
    private val sendRunnable = object : Runnable {
        override fun run() {
            lastLocation?.let { location ->
                sendLocationToServer(location)
            }
            handler.postDelayed(this, sendInterval)
        }
    }

    override fun onCreate() {
        super.onCreate()
        startForegroundNotification()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        username = intent?.getStringExtra("username") ?: "unknown"
        userId = intent?.getStringExtra("userId") ?: "0"

        initSocket()
        startLocationUpdates()

        // Start repeating sender in background thread
        handler.postDelayed(sendRunnable, sendInterval)

        return START_STICKY
    }

    private fun startForegroundNotification() {
        val channelId = "location_channel"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Location Service",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }

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
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setOngoing(true)
            .build()

        startForeground(1, notification)
    }

    private fun initSocket() {
        try {
            socket = IO.socket("https://salestrack.rocketsalestracker.com")
            socket?.connect()

            socket?.on(Socket.EVENT_CONNECT) {
                val data = JSONObject()
                data.put("username", username)
                socket?.emit("registerUser", data)
                Log.d("LocationService", "Socket connected")
            }
        } catch (e: Exception) {
            Log.e("LocationService", "Socket init error: ${e.message}")
        }
    }

    @SuppressLint("MissingPermission")
    private fun startLocationUpdates() {
        locationManager = getSystemService(LOCATION_SERVICE) as LocationManager

        // ✅ Send last known location immediately (if available)
        val lastKnownGps = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
        val lastKnownNet = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER)

        lastKnownGps?.let {
            lastLocation = it
            sendLocationToServer(it)
        } ?: lastKnownNet?.let {
            lastLocation = it
            sendLocationToServer(it)
        }

        // ✅ Request updates from both GPS & Network providers
        locationManager.requestLocationUpdates(
            LocationManager.GPS_PROVIDER,
            5000L,  // every 5 sec
            0f,
            this
        )

        locationManager.requestLocationUpdates(
            LocationManager.NETWORK_PROVIDER,
            5000L,  // every 5 sec
            0f,
            this
        )
    }


//    private fun startLocationUpdates() {
//        locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
//        try {
//            locationManager.requestLocationUpdates(
//                LocationManager.GPS_PROVIDER,
//                5000L, // request updates every 5 sec
//                0f,    // distance = 0 → report all changes
//                this
//            )
//        } catch (ex: SecurityException) {
//            Log.e("LocationService", "Permission not granted", ex)
//        }
//    }

    override fun onLocationChanged(location: Location) {
        lastLocation = location
        sendLocationToServer(location)
    }

    private fun sendLocationToServer(location: Location) {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val battery = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)

        val data = JSONObject()
        data.put("_id", userId)
        data.put("username", username)
        data.put("latitude", location.latitude)
        data.put("longitude", location.longitude)
        data.put("batteryLevel", battery)
        data.put("speed", location.speed.toDouble())
        data.put("timestamp", System.currentTimeMillis())

        socket?.emit("sendLocation", data)
        Log.d("LocationService", "Location sent: $data")
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        socket?.disconnect()
        locationManager.removeUpdates(this)
        handler.removeCallbacks(sendRunnable)
        handlerThread.quitSafely() // ✅ clean up background thread
        Log.d("LocationService", "Location service disconnected")
    }

    override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
    override fun onProviderEnabled(provider: String) {}
    override fun onProviderDisabled(provider: String) {}
}
