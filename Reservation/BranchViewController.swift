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
    
    var managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var branches       = [Branch]()
    var branchHeights  = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest    = NSFetchRequest<NSManagedObject>(entityName: "Branch")
        let branchSort      = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [branchSort]
        
        do {
            branches = try self.managedContext.fetch(fetchRequest) as! [Branch]
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // reset heights
        branchHeights = [CGFloat](repeating: UITableViewAutomaticDimension, count: branches.count)
        return branches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BranchCell", for: indexPath) as! BranchTableViewCell

        cell.nameLabel?.text = branches[indexPath.row].name
        if let address = branches[indexPath.row].address, let phone = branches[indexPath.row].phone {
            cell.addressLabel?.text = "\(address)\n☎︎ \(phone)"
        }
        cell.addressLabel?.lineBreakMode = .byWordWrapping
        cell.addressLabel?.numberOfLines = 0
        if let photoName = branches[indexPath.row].photo {
            let photoURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(photoName)
            cell.photoView?.image = UIImage(contentsOfFile: photoURL.path)
        }
        if let reservations = branches[indexPath.row].reservations {
            cell.numberOfReservationsLabel.text = String(reservations.count)
        } else {
            cell.numberOfReservationsLabel.text = "0"
        }
        
        // Calculate a height of cell
        if let nameLabel = cell.nameLabel, let textString = cell.nameLabel?.text, let addressString = cell.addressLabel?.text {
            // height with virtical space (4)
            let height = textString.heightWithConstrainedWidth(width: nameLabel.frame.width, font: UIFont.systemFont(ofSize: 18)) + addressString.heightWithConstrainedWidth(width: nameLabel.frame.width, font: UIFont.systemFont(ofSize: 10)) + 4
            if height > 44 {
                self.branchHeights[indexPath.row] = height
            }
        }
        
        // multi-lines
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    // TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return self.branchHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: {
            (action, indexPath) in
            do {
                let branch = self.branches[indexPath.row]
                if let photoName = branch.photo {
                    let photoURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(photoName)
                    do {
                        try FileManager.default.removeItem(at: photoURL)
                    } catch let error {
                        print("Cannot remove file: \(error)")
                    }
                }
                self.branches.remove(at: indexPath.row)
                self.managedContext.delete(branch)
                try self.managedContext.save()
                self.tableView.reloadData()
            } catch let error {
                print("Cannot remove object. \(error)")
            }
        })
        return [deleteAction]
    }
    
    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
