//
//  NotificationHelper.swift
//  Fly
//
//  Created by Janak Malla on 3/5/20.
//  Copyright © 2020 Janak Malla. All rights reserved.
//

import UIKit

class NotificationHelper {
    
    static func createFlyNotification(minutes: Int, seconds: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Bruh"
        content.body = "Check your fly!"
        
        // Configure the recurring date.
        let date = Date()
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.minute = dateComponents.calendar?.component(.minute, from: date)
        dateComponents.minute! += minutes    // when to remind the user
        dateComponents.second = dateComponents.calendar?.component(.second, from: date)
        dateComponents.second! += seconds    // when to remind the user
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: false)
        
        // Create the request
        let uuidString = UUID().uuidString + "checkthatzipper"
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
            print(error?.localizedDescription ?? "")
           }
        }
    }
}

