//
//  addDayTVC.swift
//  LIFE MARK
//
//  Created by TANG,QI-RONG on 2020/10/9.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import CoreData

class addDayTVC: UITableViewController, UITextFieldDelegate {

    var addDayCoreData: DayPage!
    var addDayCellTitleText = String()
    var addDayCellMainText = String()
    var addDayCellOtherText = String()
    
    @IBOutlet weak var addDayDatePicker: UIDatePicker!
    
    @IBOutlet weak var addDayTitleTextField: UITextField! {
        didSet{
            addDayTitleTextField.tag = 1
            addDayTitleTextField.delegate = self
        }
    }
    
    @IBOutlet weak var addDayMainTextField: UITextField! {
        didSet{
            addDayMainTextField.tag = 2
            addDayMainTextField.delegate = self
        }
    }
    
    @IBOutlet weak var addDayOtherTextView: UITextView! {
        didSet{
            addDayOtherTextView.tag = 3
        }
    }
    
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

        //點擊空白區收鍵盤
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
       }
        return true
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

extension addDayTVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
