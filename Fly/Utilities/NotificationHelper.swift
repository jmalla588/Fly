//
//  NotificationHelper.swift
//  Fly
//
//  Created by Janak Malla on 3/5/20.
//  Copyright © 2020 Janak Malla. All rights reserved.
//

import UIKit

class NotificationHelper {
    
    static let notificationCenter = UNUserNotificationCenter.current()
    
    static func createFlyNotificationAuto(minutes: Int, seconds: Int) {
        
        // Configure the recurring date.
        let date = Date()
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.minute = dateComponents.calendar?.component(.minute, from: date)
        dateComponents.minute! += minutes    // when to remind the user
        dateComponents.second = dateComponents.calendar?.component(.second, from: date)
        dateComponents.second! += seconds
        notificationHelper(dateComponents, repeats: false)
    }
    
    static func createFlyNotificationManual(hour: Int, minute: Int, amPeriod: Bool, repeatSchedule: String) {
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        if hour == 12 {
            let hour = hour - 12
            dateComponents.hour = amPeriod ? hour : hour + 12
        }
        dateComponents.minute = minute
        if repeatSchedule == "Every Day" {
            for i in 1...7 {
                dateComponents.weekday = i
                notificationHelper(dateComponents, repeats: true, "manual")
            }
        } else if repeatSchedule == "Weekdays" {
            for i in 2...6 {
                dateComponents.weekday = i
                notificationHelper(dateComponents, repeats: true, "manual")
            }
        } else if repeatSchedule == "Weekends" {
            for i in [1, 7] {
                dateComponents.weekday = i
                notificationHelper(dateComponents, repeats: true, "manual")
            }
        }
    }
    
    static func removePendingNotification(notificationId: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
        print("remove notifs called")
    }
    
    private static func notificationHelper(_ dateComponents: DateComponents, repeats: Bool, _ unique: String = "") {
        // when to remind the user
        
        let content = UNMutableNotificationContent()
        content.title = "Bruh"
        content.body = "Check your fly!"
        
        // Create the trigger.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: repeats)
        
        // Create the request
        let uuidString = UUID().uuidString + "checkthatzipper" + unique
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)
        
        // Schedule the request with the system.
        notificationCenter.add(request) { (error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
        }
        print(request)
    }
}

