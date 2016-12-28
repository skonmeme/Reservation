//
//  BranchViewController.swift
//  Reservation
//
//  Created by Sung Gon Yi on 23/12/2016.
//  Copyright © 2016 skon. All rights reserved.
//

import UIKit
import CoreData

class BranchViewController: UITableViewController {

    var branches: [Branch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext  = appDelegate.persistentContainer.viewContext
        let fetchRequest    = NSFetchRequest<NSManagedObject>(entityName: "Branch")
        let branchSort      = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [branchSort]
        
        do {
            branches = try managedContext.fetch(fetchRequest) as! [Branch]
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // TableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return branches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BranchCell", for: indexPath)
        cell.textLabel?.text       = branches[indexPath.row].name
        cell.detailTextLabel?.text = "\(branches[indexPath.row].address) (\(branches[indexPath.row].phone))"
        if let photo = branches[indexPath.row].photo {
            cell.imageView?.image      = UIImage(contentsOfFile: photo)
        }
        return cell
    }
    
    // Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
