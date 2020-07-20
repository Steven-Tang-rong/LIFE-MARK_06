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
    
    @IBOutlet var emptyTimePageView: UIView!
    
    @IBAction func backTime(segue: UIStoryboardSegue) {
            dismiss(animated: true, completion: nil)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9983078837, green: 0.9106715322, blue: 0.8389384151, alpha: 1)
        
        // Prepare the empty view
        tableView.backgroundView = emptyTimePageView
        tableView.backgroundView?.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tableView.backgroundView?.isHidden = true
        
        
        //Fetch data from Coredata
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cellIdentifier = "timerPageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! timerPageTableViewCell
        
        //DatePicker
        if timePageData[indexPath.row].datePicker != nil {
            cell.showSetTime.text = timePageData[indexPath.row].datePicker
            print("success")
        }else {
            cell.showSetTime.text = "Not Set"
            print("Fail")
        }

        //Labels
        if timePageData[indexPath.row].timerTitle != nil {
            cell.timerTitle.text = timePageData[indexPath.row].timerTitle
        }else {
            cell.timerTitle.text = "Not Set"
        }
        
        if timePageData[indexPath.row].timerMainTask != nil {
            cell.timerMainTask.text = timePageData[indexPath.row].timerMainTask
        }else {
            cell.timerMainTask.text = "Not Set"
        }
        
        
        // Configure the cell...

        return cell
    }
    
    
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
