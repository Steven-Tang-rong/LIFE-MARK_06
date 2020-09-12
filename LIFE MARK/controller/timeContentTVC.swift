//
//  timeContentTVC.swift
//  LIFE MARK
//
//  Created by TANG,QI-RONG on 2020/8/1.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import CoreData

class timeContentTVC: UITableViewController {

    var updateTimeCoreData: LifeMarker!
   
    var dateLabel = Date()
    
    var someTitleLabel = String()
    var someMainLabel = String()
    var someOtherLabel = String()
  
    // prepare func
    var timerTitle = String()
    var timerMain = String()
    var timerOther = String()

    var container: NSPersistentContainer!
    
    @IBOutlet weak var changeDatePicker: UIDatePicker!
    
    @IBOutlet weak var changeTimeTitle: UITextField!
    
    @IBOutlet weak var changeTimeMain: UITextField!
    
    @IBOutlet weak var changeTimeOther: UITextView!
    
    func timeNotification() {
    let content = UNMutableNotificationContent()
        content.title       =  timerTitle
        content.subtitle    =  timerMain
        content.badge       = 1
        content.sound       = UNNotificationSound(named:UNNotificationSoundName(rawValue: "Gintama.aiff"))
          
        let date            = changeDatePicker.date
        let components      = Calendar.current.dateComponents([ .hour, .minute], from: date)
        let trigger         = UNCalendarNotificationTrigger(dateMatching: components,
                                                              repeats: false)
        let request         = UNNotificationRequest(identifier: "notificationl",
                                                      content: content, trigger: trigger)
       
         UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let updateTimeCoreData = updateTimeCoreData{
            changeDatePicker.date = updateTimeCoreData.datePicker!
            changeTimeTitle.text = updateTimeCoreData.timerTitle
            changeTimeMain.text = updateTimeCoreData.timerMainTask
            changeTimeOther.text = updateTimeCoreData.timerOtherTask
        }
        
        dateLabel   = changeDatePicker.date
        timerTitle  = changeTimeTitle.text!
        timerMain   = changeTimeMain.text!
        timerOther  = changeTimeOther.text!
    }
  
//MARK: - updating
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        updateTimeCoreData.datePicker = changeDatePicker.date
        updateTimeCoreData.timerTitle = changeTimeTitle.text
        updateTimeCoreData.timerMainTask = changeTimeMain.text
        updateTimeCoreData.timerOtherTask = changeTimeOther.text
        updateTimeCoreData.timerSwitch = true
        
        timeNotification()
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
