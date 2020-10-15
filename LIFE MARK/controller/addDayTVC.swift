//
//  addDayTVC.swift
//  LIFE MARK
//
//  Created by TANG,QI-RONG on 2020/10/9.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import CoreData

class addDayTVC: UITableViewController {

    var addDayCoreData: DayPage!
    var addDayCellTitleText = String()
    var addDayCellMainText = String()
    var addDayCellOtherText = String()
    
    @IBOutlet weak var addDayDatePicker: UIDatePicker!
    
    @IBOutlet weak var addDayTitleTextField: UITextField!
    
    @IBOutlet weak var addDayMainTextField: UITextField!
    
    @IBOutlet weak var addDayOtherTextView: UITextView!
    
    @IBAction func addDayDatePickerAction(_ sender: Any) {
        addDayDatePicker.locale = Locale(identifier: "zh_TW")
        addDayDatePicker.datePickerMode = .dateAndTime
    }
    
    func timeNotification() {
       let content = UNMutableNotificationContent()
           content.title       =  addDayTitleTextField.text!
           content.subtitle    =  addDayMainTextField.text!
           content.badge       = 1
           content.sound       = UNNotificationSound(named:UNNotificationSoundName(rawValue: "Gintama.aiff"))
             
           let date            = addDayDatePicker.date
           let components      = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
           let trigger         = UNCalendarNotificationTrigger(dateMatching: components,
                                                                 repeats: false)
           let request         = UNNotificationRequest(identifier: "notificationl",
                                                         content: content, trigger: trigger)
          
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    @IBAction func saveDayButtonTapped(_ sender: Any) {
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            addDayCoreData = DayPage(context: appDelegate.persistentContainer.viewContext)
            addDayCoreData.dayPicker = addDayDatePicker.date
           
            //標題
            if addDayTitleTextField.text != "" {
                addDayCoreData.dayTitle = addDayTitleTextField.text
            }else {
                addDayTitleTextField.text = "沒有輸入標題"
                addDayCoreData.dayTitle = addDayTitleTextField.text
            }
            
            //主題
            if addDayMainTextField.text != "" {
                addDayCoreData.dayMainTask = addDayMainTextField.text
            }else {
                addDayMainTextField.text = "沒有輸入標題"
                addDayCoreData.dayMainTask = addDayMainTextField.text
            }
            
            //次要
            addDayCoreData.dayOtherTask = addDayOtherTextView.text
            
            timeNotification()
            print("Saving data to contect")
            appDelegate.saveContext()
        }
        dismiss(animated: true, completion: nil)

    }
    
}
