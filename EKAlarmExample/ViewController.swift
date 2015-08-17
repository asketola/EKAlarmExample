//
//  ViewController.swift
//  EKAlarmExample
//
//  Created by Annemarie Ketola on 8/16/15.
//  Copyright (c) 2015 Annemarie Ketola. All rights reserved.
//

import UIKit
import EventKit

var calendarDatabase = EKEventStore()

class ViewController: UIViewController {

    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var reminderTItle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarDatabase.requestAccessToEntityType(EKEntityTypeReminder, completion: { (granted: Bool, error:NSError!) -> Void in
            if !granted {
                println("Access to store not granted")
            } else {
                println("We have alarm permission")
            }
        })
    }
    
    // changed the location of this function to above
//    func eventStoreAccessReminders() {
//        calendarDatabase.requestAccessToEntityType(EKEntityTypeReminder, completion: { (granted: Bool, error:NSError!) -> Void in
//            if !granted {
//                println("Access to store not granted")
//            }
//        })
//    }
    
    func accessCalendarInTheDatabase() {
        var calendars = calendarDatabase.calendarsForEntityType(EKEntityTypeReminder)
        
        for calendar in calendars as! [EKCalendar] {
            println("Calendar = \(calendar.title)")
        }
    }
    
    func createReminder(reminderTitle: String, reminderDate: NSDate) {
        let reminder = EKReminder(eventStore: calendarDatabase)
        
        reminder.title = reminderTItle.text
        let date = reminderDate
        let alarm = EKAlarm(absoluteDate: date)
        
        reminder.addAlarm(alarm)
        
        reminder.calendar = calendarDatabase.defaultCalendarForNewReminders()
        
        var error = NSError?()
        
        if error != nil {
            println("errors: \(error?.localizedDescription)")
        }
        
        calendarDatabase.saveReminder(reminder, commit: true, error: &error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func setReminder(sender: AnyObject) {
        
        calendarDatabase.requestAccessToEntityType(EKEntityTypeReminder, completion: { (granted, error) -> Void in
            if !granted {
                println("Access to store not granted")
                println("\(error.localizedDescription)")
            } else {
                println("Reminder entered: \(self.reminderTItle.text), \(self.reminderDatePicker.date)")
            }
            
        })
        createReminder(reminderTItle.text, reminderDate: reminderDatePicker.date)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        reminderTItle.endEditing(true)
    }

}