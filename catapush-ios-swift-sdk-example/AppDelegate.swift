//
//  AppDelegate.swift
//  catapush-ios-swift-sdk-example
//
//  Created by Chiarotto Alessandro on 10/12/15.
//  Copyright © 2015 Catapush s.r.l. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CatapushDelegate, MessagesDispatchDelegate, UIAlertViewDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //ef2c1951f727d7d85c1bda1b05dbd418
        // Horsa:7dd2277e4de27e0f4456888c0a600f6b
        Catapush.setAppKey("7dd2277e4de27e0f4456888c0a600f6b")
        
        //cXM6MDVGMzMzQzItMjhDNS00N0YwLTlGMzItODUwNzZFQzNENDcx / 85023824de3f41
        // Horsa: test.horsa / test@horsa
        Catapush.setIdentifier("test.horsa", andPassword: "test@horsa")
        
        Catapush.setupCatapushStateDelegate(self, andMessagesDispatcherDelegate: self)
        
        Catapush.registerUserNotification(self)
        
        Catapush.enableLog(true)

        var error: NSError?
        Catapush.start(&error)

        if let error = error {
            // API KEY, USERNAME or PASSWORD not set
            print("Error: \(error.localizedDescription)")
        }
        
        application.applicationIconBadgeNumber = 0;
        UNUserNotificationCenter.current().delegate = self

        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Catapush.applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        var error: NSError?
        Catapush.applicationWillEnterForeground(application, withError: &error)
        
        if let error = error {
            // Handle error...
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Catapush.applicationDidBecomeActive(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Catapush.applicationWillTerminate(application)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Custom code (can be empty)
        print("---application didRegisterForRemoteNotificationsWithDeviceToken---")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Custom code (can be empty)
    }
    
    func catapushDidConnectSuccessfully(_ catapush: Catapush) {
        let alert = UIAlertController(title: "Connected", message: "Catapush Connected", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    public func catapush(_ catapush: Catapush, didFailOperation operationName: String?, withError error: Error?) {
        let errorMessage = "The operation " + (operationName ?? "") + " is failed with error " + (error?.localizedDescription ?? "")
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    func libraryDidReceive(_ messageIP: MessageIP?) {
        guard let messageIP else { return }
        messageIP.originalMessageId
        
        
        MessageIP.sendMessageReadNotification(messageIP)
        print("Single message: \(messageIP.body)")
        print("---All Messages---")
        for message in Catapush.allMessages() {
            print("Message: \((message as! MessageIP).body)")
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("---userNotificationCenter didReceive---")
        completionHandler();
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("---userNotificationCenter willPresent--")
        completionHandler([]);
    }
    
    
}
