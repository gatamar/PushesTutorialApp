//
//  AppDelegate.swift
//  PushesTutorialApp
//
//  Created by Olha Bachalo on 06.09.2021.
//

import UIKit
import UserNotifications
import Intents

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions:
                        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { granted, _ in
            guard granted else { return }

            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        if #available(iOS 15.0, *) {
            INFocusStatusCenter.default.requestAuthorization { focusAuthorizationStatus in
                print("focusAuthorizationStatus = \(focusAuthorizationStatus)")
                switch focusAuthorizationStatus {
                case .authorized:
                    let focusStatus = INFocusStatusCenter.default.focusStatus

                    print("focusStatus = \(focusStatus.isFocused)")
                    break
                default:
                    fatalError("why not authorized?")
                }
            }

        } else {
            // Fallback on earlier versions
        }
        

        return true
    }

    func application(_ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print(token)
    }

    func application(_ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
}
