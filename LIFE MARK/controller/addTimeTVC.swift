//
//  addTimeTVC.swift
//  LIFE MARK
//
//  Created by TANG,QI-RONG on 2020/7/6.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import CoreData

class addTimeTVC: UITableViewController, UITextFieldDelegate {

    var addTimeCoreData: LifeMarker!
    var addTimeCellTitleText = String()
    var addTimeCellMainText = String()
    var addTimeCellOtherText = String()
    
    @IBOutlet weak var addTimeDatePicker: UIDatePicker!

    @IBOutlet weak var addTimeTitleTextField: UITextField! {
        didSet{
            addTimeTitleTextField.tag = 1
            addTimeTitleTextField.delegate = self
        }
    }

    @IBOutlet weak var addTimeMainTextField: UITextField! {
        didSet{
            addTimeMainTextField.tag = 2
            addTimeMainTextField.delegate = self
        }
    }
    
    @IBOutlet weak var addTImeOtherTextView: UITextView! {
        didSet {
            addTImeOtherTextView.tag = 3
        }
    }
    
    @IBAction func addTimeDatePickerAction(_ sender: Any) {
        // 設置要顯示在 UILabel 的日期時間格式
        addTimeDatePicker.locale = Locale(identifier: "zh_TW")
        addTimeDatePicker.datePickerMode = .time
            
    }
    

    func timeNotification() {
    let content = UNMutableNotificationContent()
        content.title       =  addTimeTitleTextField.text!
        content.subtitle    =  addTimeMainTextField.text!
        content.badge       = 1
        content.sound       = UNNotificationSound(named:UNNotificationSoundName(rawValue: "Gintama.aiff"))
          
        let date            = addTimeDatePicker.date
        let components      = Calendar.current.dateComponents([ .hour, .minute], from: date)
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
    
   /* func textFieldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
            
        return true
    }*/
    
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        //取得AppDelegate內容
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            addTimeCoreData = LifeMarker(context: appDelegate.persistentContainer.viewContext)
            
            addTimeCoreData.datePicker = addTimeDatePicker.date
           
            //標題
            if addTimeTitleTextField.text != "" {
                addTimeCoreData.timerTitle = addTimeTitleTextField.text
            }else {
                addTimeTitleTextField.text = "沒有輸入標題"
                addTimeCoreData.timerTitle = addTimeTitleTextField.text
            }
            
            //主題
            if addTimeMainTextField.text != "" {
                addTimeCoreData.timerMainTask = addTimeMainTextField.text
            }else {
                addTimeMainTextField.text = "沒有輸入訊息"
                addTimeCoreData.timerMainTask = addTimeMainTextField.text
            }
            
            //次要
            addTimeCoreData.timerOtherTask = addTImeOtherTextView.text
            //Switch
            addTimeCoreData.timerSwitch = true
            
            timeNotification()
            print("Saving data to contect")
            appDelegate.saveContext()
        }
    
        dismiss(animated: true, completion: nil)

  }

}

extension addTimeTVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}


