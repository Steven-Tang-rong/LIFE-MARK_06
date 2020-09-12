//
//  timerPageTVC.swift
//  LIFE MARK
//
//  Created by TANG,QI-RONG on 2020/7/16.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import CoreData

class timerPageTVC: UITableViewController, NSFetchedResultsControllerDelegate {

    var timePageData: [LifeMarker] = []
    var fetchResultController: NSFetchedResultsController<LifeMarker>!

    var cellTimeDate = Date()
    var cellTitleText = String()
    var cellMainText = String()
    var cellOtherText = String()
    var container: NSPersistentContainer!
    
    @IBOutlet var emptyTimePageView: UIView!
        
    @IBAction func backTime(segue: UIStoryboardSegue) {
            dismiss(animated: true, completion: nil)
        }
    
   
    
    //MARK: - unwindSegue（更新資料）
    
    @IBAction func unwindTotimePageTVC(_ unwindSegue: UIStoryboardSegue) {
        
       if let sourceViewController = unwindSegue.source as? timeContentTVC, let updateTimeCoreData = sourceViewController.updateTimeCoreData {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            timePageData[indexPath.row] = updateTimeCoreData
            
            let unwindIndexPath = IndexPath(row: 0, section: 0)
            tableView.reloadRows(at: [unwindIndexPath], with: .automatic)
            container.saveContext()
        }
      }
        tableView.reloadData()
    }
    

    func timeNotification() {
        let content = UNMutableNotificationContent()
            content.title       =  cellTitleText
            content.subtitle    =  cellMainText
            content.badge       = 1
            content.sound       = UNNotificationSound(named:UNNotificationSoundName(rawValue: "Gintama.aiff"))
              
            let date            = cellTimeDate
            let components      = Calendar.current.dateComponents([ .hour, .minute], from: date)
            let trigger         = UNCalendarNotificationTrigger(dateMatching: components,
                                                                  repeats: false)
            let request         = UNNotificationRequest(identifier: "notificationl",
                                                          content: content, trigger: trigger)
           
             UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
         }
    
    func removeTimeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["notificationl"])
    }
 
//Notification IBAction
    @IBAction func notificationSwitch(_ sender: UISwitch) {
            let point = sender.convert(CGPoint.zero, to: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                timePageData[indexPath.row].timerSwitch = sender.isOn
               print(point)
                                
                if sender.isOn == timePageData[indexPath.row].timerSwitch {
                   print("Switch true")
                   timeNotification()

                }else if sender.isOn == timePageData[indexPath.row].timerSwitch{
                    print("Switch false")
                    removeTimeNotification()

            }
            container.saveContext()
        }
    }
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare the empty view
        tableView.backgroundView = emptyTimePageView
        tableView.backgroundView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.backgroundView?.isHidden = true
        
        
        //Fetch data from CoreData
        let fetchRequest: NSFetchRequest<LifeMarker> = LifeMarker.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timerTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do{
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    timePageData = fetchedObjects
                }
            }catch {
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if timePageData.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        }else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timePageData.count
    }

//MARK: - 表格插入資料
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cellIdentifier = "timerPageCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? timerPageTableViewCell else { return UITableViewCell() }

        cellTimeDate = timePageData[indexPath.row].datePicker!
        cellTitleText = timePageData[indexPath.row].timerTitle!
        cellMainText = timePageData[indexPath.row].timerMainTask!
   
        cell.timerSwitchOutlet.isOn = timePageData[indexPath.row].timerSwitch
        
        if timePageData[indexPath.row].datePicker != nil {
            let formatter = DateFormatter()
                formatter.locale        = Locale(identifier: "zh_TW")
                formatter.timeStyle     = .short
            let formatterString     = formatter.string(from: cellTimeDate)
                cell.showSetTime.text   = formatterString
            }
        
        //標題資料
        if timePageData[indexPath.row].timerTitle != nil {
            cell.timerTitle.text    = timePageData[indexPath.row].timerTitle
            cellTitleText           = cell.timerTitle.text!
        }
        
        //主題資料
        if timePageData[indexPath.row].timerMainTask != nil {
            cell.timerMainTask.text = timePageData[indexPath.row].timerMainTask
            cellMainText            = cell.timerMainTask.text!
        }
        
        
        //其他事項資料
        if timePageData[indexPath.row].timerOtherTask != nil {
            cellOtherText       = timePageData[indexPath.row].timerOtherTask!
        }else {
            cellOtherText = "輸入事項"
        }
        
        return cell
    }
    
   /*   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellIdentifier = "timerPageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! timerPageTableViewCell
        
         cell.timerSwitchOutlet.isOn = timePageData[indexPath.row].timerSwitch
        
       if timePageData[indexPath.row].timerSwitch == true{
            cell.timerSwitchOutlet.isOn = true
        }else if timePageData[indexPath.row].timerSwitch == false{
            cell.timerSwitchOutlet.isOn = false
        }
        tableView.reloadData()
    }*/
    
    // MARK: - NSFetchedResultsControllerDelegate methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at:[newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            timePageData = fetchedObjects as! [LifeMarker]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //MARK: - 往左滑動刪除列
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") {
            (action, sourceView, completionHandler) in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let timeToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(timeToDelete)
                
                appDelegate.saveContext()
            }
            
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.4934554561, blue: 0.5243053216, alpha: 1)
        deleteAction.image = UIImage(systemName: "trash")
        
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration
        
        
        
    }
    
//MARK: - 傳送資料至timeContentTVC
    
    @IBSegueAction func updateTimeData(_ coder: NSCoder) -> timeContentTVC? {
        let destinationController = timeContentTVC(coder: coder)
        
        if let row = tableView.indexPathForSelectedRow?.row{
  
            destinationController?.updateTimeCoreData = timePageData[row]
        }

        return destinationController
    }
    

    
    
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

    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTimeUpdates" {
            if let indexPath = tableView.indexPathsForSelectedRows {
                
                let destinationController = segue.destination as! timeContentTVC
                
                
            }
        }
    }*/
   
 }
