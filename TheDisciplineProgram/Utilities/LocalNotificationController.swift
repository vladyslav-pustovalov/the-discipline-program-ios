//
//  PaymentNotificationController.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 22/08/2025.
//

import UserNotifications

class LocalNotificationController {
    var isPaymentNotificationSet = UserDefaults.standard.bool(forKey: Constants.Defaults.paymentNotificationStatus)
    
    func setUserNotification() {
        Log.info("Setting user notification")
        if isPaymentNotificationSet {
            Log.info("Payment notification is already set")
            return
        } else {
            
            isNotificationAllowed { allowed in
                if allowed {
                    self.addPaymentNotification()
                } else {
                    self.askNotificationPermission { granted in
                        if granted {
                            self.addPaymentNotification()
                        }
                    }
                }
            }
        }
    }
    
    private func isNotificationAllowed(completion: @escaping (Bool) -> Void) {
        Log.info("Checking if notificatoin is allowed")
        UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    switch settings.authorizationStatus {
                    case .authorized, .provisional, .ephemeral:
                        Log.info("Notificaton is allowed")
                        completion(true)
                    case .denied, .notDetermined:
                        Log.info("Notificaton is NOT allowed")
                        completion(false)
                    @unknown default:
                        Log.info("Notificaton status is unknown")
                        completion(false)
                    }
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
