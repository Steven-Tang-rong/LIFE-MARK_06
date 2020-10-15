//
//  dayContantTVC.swift
//  LIFE MARK
//
//  Created by TANG,QI-RONG on 2020/10/9.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import CoreData

class dayContantTVC: UITableViewController {

    var updateDayCoreData: DayPage!
    var container: NSPersistentContainer!
    
    var dayTitle = String()
    var dayMain = String()
    
    
    @IBOutlet weak var changeDayDatePicker: UIDatePicker!
    
    
    @IBOutlet weak var changeDayTitle: UITextField!
    
    @IBOutlet weak var changeDayMain: UITextField!
    
    @IBOutlet weak var changeDayOther: UITextView!
    
//TimeNotification
    
    func dayNotification() {
    let content = UNMutableNotificationContent()
        content.title       =  dayTitle
        content.subtitle    =  dayMain
        content.badge       = 1
        content.sound       = UNNotificationSound(named:UNNotificationSoundName(rawValue: "Gintama.aiff"))
          
        let date            = changeDayDatePicker.date
        let components      = Calendar.current.dateComponents([.day , .hour, .minute], from: date)
        let trigger         = UNCalendarNotificationTrigger(dateMatching: components,
                                                              repeats: false)
        let request         = UNNotificationRequest(identifier: "notificationl",
                                                      content: content, trigger: trigger)
       
         UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
     }
    
//MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let updateDayCoreData = updateDayCoreData{
            changeDayDatePicker.date = updateDayCoreData.dayPicker!
            changeDayTitle.text      = updateDayCoreData.dayTitle
            changeDayMain.text       = updateDayCoreData.dayMainTask
            changeDayOther.text      = updateDayCoreData.dayOtherTask
        }
    //傳遞資料給推播
        dayTitle = changeDayTitle.text!
        dayMain  = changeDayMain.text!
    }
    
//MARK: - updating
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        updateDayCoreData.dayPicker    = changeDayDatePicker.date
        updateDayCoreData.dayTitle     = changeDayTitle.text
        updateDayCoreData.dayMainTask  = changeDayMain.text
        updateDayCoreData.dayOtherTask = changeDayOther.text
        
        dayNotification()
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
