//
//  PaymentNotificationController.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 22/08/2025.
//

import UIKit
import UserNotifications

@Observable
class LocalNotificationViewModel {
    private var isPaymentNotificationSet: Bool
    private var nextNotificationsPermissionsReminder: Date
    var isShowingAlert = false
    
    init() {
        self.isPaymentNotificationSet = UserDefaults.standard.bool(forKey: Constants.Defaults.paymentNotificationStatus)
        
        if let nextDate = UserDefaults.standard.object(forKey: Constants.Defaults.nextNotificationsPermissionsReminder) as? Date {
            self.nextNotificationsPermissionsReminder = nextDate
        } else {
            self.nextNotificationsPermissionsReminder = Date.now
        }
    }
    
    func setUserNotification() {
        Log.info("Setting user notification")
        if isPaymentNotificationSet {
            Log.info("Payment notification is already set")
            return
        } else {
            getUserNotificationPermission { status in
                switch status {
                case .authorized, .ephemeral, .provisional:
                    Log.info("Notificaton is allowed")
                    self.addPaymentNotification()
                case .denied:
                    Log.info("Notificaton is NOT allowed")
                    if Date.now < self.nextNotificationsPermissionsReminder {
                        Log.info("Did not reask for notification permission, next reasing will be: \(self.nextNotificationsPermissionsReminder.formatted())")
                        return
                    } else {
                        if let oneMonthLater = Calendar.current.date(byAdding: .month, value: 1, to: self.nextNotificationsPermissionsReminder) {
                            UserDefaults.standard.set(oneMonthLater, forKey: Constants.Defaults.nextNotificationsPermissionsReminder)
                        }
                        self.isShowingAlert = true
                    }
                case .notDetermined:
                    Log.info("Notificaton permission is NOT set")
                    self.askNotificationPermission { granted in
                        if granted {
                            self.addPaymentNotification()
                        }
                    }
                @unknown default:
                    Log.info("Notificaton status is unknown")
                }
            }
        }
    }
    
    func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings)
        }
    }
    
    private func getUserNotificationPermission(completion: @escaping (UNAuthorizationStatus) -> Void) {
        Log.info("Checking if notificatoin is allowed")
        UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    completion(settings.authorizationStatus)
                }
            }
    }
    
    private func askNotificationPermission(completion: @escaping (Bool) -> Void) {
        Log.info("Asking notification permission")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                switch granted {
                case true:
                    Log.info("Notification permission received")
                    completion(granted)
                case false:
                    Log.info("Notification permission NOT received")
                    completion(granted)
                }
            }
            
            if let error {
                Log.error("Notificaton permission error: \(error.localizedDescription)")
            }
        }
    }
    
    private func addPaymentNotification() {
        Log.info("Seting new payment notification")
        let content = UNMutableNotificationContent()
        content.title = "Monthly payment reminder"

        content.sound = UNNotificationSound.default
        
        var components = DateComponents()
        components.day = 1
        components.hour = 9
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        UserDefaults.standard.set(true, forKey: Constants.Defaults.paymentNotificationStatus)
        Log.info("Payment notification is set")
    }
}
