//
//  dayTableViewController.swift
//  LIFE MARK
//
//  Created by TANG,QI-RONG on 2020/10/9.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import CoreData

class dayTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {

    var dayPageData: [DayPage] = []
    var fetchResultController: NSFetchedResultsController<DayPage>!
    var container: NSPersistentContainer!
    
    var cellDayDate = Date()
    var cellDayTitleText = String()
    var cellDayMainText = String()
    var cellDayOtherText = String()
    
    @IBOutlet var emptyDayPageView: UIView!
    
    @IBAction func backDayPage(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
//MARK: - dayContentTVC（更新資料）
    
    @IBAction func unwindDayPageTVC(_ unwindSegue: UIStoryboardSegue) {
        
        if let sourceViewController = unwindSegue.source as? dayContantTVC,let updateDayCoreData = sourceViewController.updateDayCoreData {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                dayPageData[indexPath.row] = updateDayCoreData
                
                let unwindIndexPath = IndexPath(row: 0, section: 0)
                tableView.reloadRows(at: [unwindIndexPath], with: .automatic)
                container.saveContext()
            }
        }
        tableView.reloadData()
    }
    
//MARK: - timeNotification
     
     func dayNotification() {
         let content = UNMutableNotificationContent()
             content.title       =  cellDayTitleText
             content.subtitle    =  cellDayMainText
             content.badge       = 1
             content.sound       = UNNotificationSound(named:UNNotificationSoundName(rawValue: "Gintama.aiff"))
               
             let date            = cellDayDate
             let components      = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
             let trigger         = UNCalendarNotificationTrigger(dateMatching: components,
                                                                   repeats: false)
             let request         = UNNotificationRequest(identifier: "notificationl",
                                                           content: content, trigger: trigger)
            
              UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
          }
     
     func removeDayNotification() {
         UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["notificationl"])
     }
    

//MARK: -  viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

       tableView.backgroundView = emptyDayPageView
       tableView.backgroundView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       tableView.backgroundView?.isHidden = true
        
//Coredata取資料
     // var fetchResultController: NSFetchedResultsController<LifeMarker>!
        let fetchRequest: NSFetchRequest<DayPage> = DayPage.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dayTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    dayPageData = fetchedObjects
                }
                
            }catch {
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        if dayPageData.count > 0 {
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
        return dayPageData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "dayPageCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)as? dayPageTableViewCell else { return UITableViewCell() }

        cellDayDate = dayPageData[indexPath.row].dayPicker!
        cellDayTitleText = dayPageData[indexPath.row].dayTitle!
        cellDayMainText = dayPageData[indexPath.row].dayMainTask!
       
        //設定formatter
        if dayPageData[indexPath.row].dayPicker != nil {
            let formatter = DateFormatter()
            formatter.locale        = Locale(identifier: "zh_TW")
            formatter.dateStyle     = .full
            formatter.timeStyle     = .short
            
            let formatterString     = formatter.string(from: cellDayDate)
            cell.showSetTimeLabel.text = formatterString
        }
        
        //標題資料
        if dayPageData[indexPath.row].dayTitle != nil {
            cell.dayTitleLabel.text = dayPageData[indexPath.row].dayTitle
            cellDayTitleText        = cell.dayTitleLabel.text!
        }
        //主題資料
        if dayPageData[indexPath.row].dayMainTask != nil {
            cell.dayMainTaskLabel.text  = dayPageData[indexPath.row].dayMainTask
            cellDayMainText         = cell.dayMainTaskLabel.text!
        }
        //其他事項資料
        if dayPageData[indexPath.row].dayOtherTask != nil {
            cellDayOtherText        = dayPageData[indexPath.row].dayOtherTask!
        }else {
            cellDayOtherText = "輸入事項"
        }
        
        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        default:
            tableView.reloadData()
        }
       
    //回給dayPageData？
        if let fetchedObjects = controller.fetchedObjects {
            dayPageData = fetchedObjects as! [DayPage]
        }
        
    }
     
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //MARK: - 往左滑動刪除列
   
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { (action, sourceView, completionHandler) in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let dayToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(dayToDelete)
                self.removeDayNotification()
                
                appDelegate.saveContext()
            }
            completionHandler(true)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.4934554561, blue: 0.5243053216, alpha: 1)
        deleteAction.image = UIImage(systemName: "trash")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
       
        return swipeConfiguration
    }
//MARK: - 傳送資料至dayContentTVC
    
    @IBSegueAction func updateDayData(_ coder: NSCoder) -> dayContantTVC? {
        let destinationController = dayContantTVC(coder: coder)
        
        if let row = tableView.indexPathForSelectedRow?.row {
            destinationController?.updateDayCoreData = dayPageData[row]
        }
        
        return destinationController
    }
    
}
