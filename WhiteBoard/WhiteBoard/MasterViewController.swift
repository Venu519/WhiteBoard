//
//  MasterViewController.swift
//  WhiteBoard
//
//  Created by Venugopal Reddy Devarapally on 06/04/17.
//  Copyright © 2017 venu. All rights reserved.
//

import UIKit
import os.log

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var subjects = [Subject]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        //let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        if let savedSubjects = loadSubjects() {
            subjects += savedSubjects
        }
        else {
            // Load the sample data.
            loadSampleSubjects()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }*/

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell

        let object = subjects[indexPath.row] 
        cell.titleLabel!.text = object.title
        cell.subTitleLabel!.text = object.subTitle
        cell.cellImageView.image = object.photo
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            subjects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    private func loadSampleSubjects() {
        
        let photo1 = UIImage(named: "maths")
        let photo2 = UIImage(named: "physics")
        let photo3 = UIImage(named: "chemistry")
        
        guard let sub1 = Subject(title:"Maths", subTitle:"Learn Mathematics as you like", photo: photo1) else {
            fatalError("Unable to instantiate sub1")
        }
        
        guard let sub2 = Subject(title:"Physics", subTitle:"Learn Physics as you like", photo: photo2) else {
            fatalError("Unable to instantiate sub2")
        }
        
        guard let sub3 = Subject(title:"Chemistry", subTitle:"Learn Chemistry as you like", photo: photo3) else {
            fatalError("Unable to instantiate sub3")
        }
        
        subjects += [sub1, sub2, sub3]
    }
    
    private func saveSubjects() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(subjects, toFile: Subject.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Subjects successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Subjects...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadSubjects() -> [Subject]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Subject.ArchiveURL.path) as? [Subject]
    }
    
    @IBAction func unwindToMsaterViewController(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? AddCourseViewController, let subject = sourceViewController.subject {
                let newIndexPath = IndexPath(row: subjects.count, section: 0)
                
                subjects.append(subject)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the Subjects.
            saveSubjects()
    }

}

