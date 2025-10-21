//
//  NativeChannel.swift
//  Runner
//
//  Created by Dipanshu Kashyap on 21/10/25.
//

import Foundation
import Flutter
import CoreLocation
import SocketIO
import UIKit

class NativeChannel: NSObject, FlutterPlugin, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    private var username: String = ""
    private var userId: String = ""
    private var totalDistance: Double = 0.0
    private var lastLocation: CLLocation?
    private var timer: Timer?

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.tracker.rocketsale_rs/native", binaryMessenger: registrar.messenger())
        let instance = NativeChannel()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startService":
            if let args = call.arguments as? [String: Any] {
                username = args["username"] as? String ?? "unknown"
                userId = args["userId"] as? String ?? "0"
                startLocationService()
                result(nil)
            }
        case "stopService":
            stopLocationService()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Location Service

    private func startLocationService() {
        print("📍 Starting iOS Location Service for \(username)")

        UIDevice.current.isBatteryMonitoringEnabled = true

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()

        initSocket()

        // Send last location every 10s
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            if let loc = self?.lastLocation {
                self?.sendLocation(loc)
            }
        }

        RunLoop.main.add(timer!, forMode: .common)
    }

    private func stopLocationService() {
        print("🛑 Stopping iOS Location Service")
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
        socket?.disconnect()
        manager = nil
        socket = nil
        locationManager = nil
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }

        if let last = lastLocation {
            totalDistance += newLocation.distance(from: last)
        }
        lastLocation = newLocation
    }

    // MARK: - Socket Setup

    private func initSocket() {
        print("🔌 Connecting to Socket.IO server...")
        guard let url = URL(string: "https://salestrack.rocketsalestracker.com") else { return }

        manager = SocketManager(socketURL: url, config: [.log(true), .compress, .reconnects(true)])
        socket = manager?.defaultSocket

        socket?.on(clientEvent: .connect) { [weak self] _, _ in
            guard let self = self else { return }
            print("✅ Socket connected")

            let data: [String: Any] = ["salesmanId": self.userId]
            self.socket?.emit("registerUser", data)
            print("📨 registerUser emitted: \(data)")
        }

        socket?.on(clientEvent: .disconnect) { _, _ in
            print("⚠️ Socket disconnected")
        }

        socket?.connect()
    }

    private func sendLocation(_ location: CLLocation) {
        guard let socket = socket else { return }

        let battery = UIDevice.current.batteryLevel * 100
        let speedKmph = max(location.speed, 0) * 3.6 // convert m/s → km/h

        let data: [String: Any] = [
            "_id": userId,
            "username": username,
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "batteryLevel": battery,
            "speed": speedKmph,
            "distance": totalDistance
        ]

        socket.emit("sendLocation", data)
        print("📍 Location sent: \(data)")
    }
}
