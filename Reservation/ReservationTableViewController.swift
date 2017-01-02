//
//  ReservationTableViewController.swift
//  Reservation
//
//  Created by Sung Gon Yi on 26/12/2016.
//  Copyright © 2016 skon. All rights reserved.
//

import UIKit
import CoreData

class ReservationTableViewController: UITableViewController {

    var mangedContext   = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var branch: Branch?
    var reservations    = [Reservation]()
    var oldReservations = [Reservation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "Reservation")
        let sortByFromDescriptor = NSSortDescriptor(key: "from", ascending: true)
        let sortByToDescriptor   = NSSortDescriptor(key: "to",   ascending: true)
        fetchRequest.sortDescriptors = [sortByFromDescriptor, sortByToDescriptor]
        
        // reservations
        if let branch = self.branch {
            let now = Date()
            let predicate    = NSPredicate(format: "%K == %@ && %K > %@",  argumentArray: ["branch", branch, "to", now])
            let oldPredicate = NSPredicate(format: "%K == %@ && %K <= %@", argumentArray: ["branch", branch, "to", now])
            
            do {
                fetchRequest.predicate = predicate
                reservations = try self.mangedContext.fetch(fetchRequest) as! [Reservation]
                fetchRequest.predicate = oldPredicate
                oldReservations = try self.mangedContext.fetch(fetchRequest) as! [Reservation]
            } catch let error as NSError {
                print("Cannot fetch CoreData: \(error), \(error.userInfo)")
            }
            
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return reservations.count
        }
        return oldReservations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath)
        let reservation: Reservation
        
        if indexPath.section == 0 {
            reservation = reservations[indexPath.row]
        } else {
            reservation = oldReservations[indexPath.row]
        }
        
        cell.textLabel?.text       = "\(reservation.from) - \(reservation.to)"
        cell.detailTextLabel?.text = "\(reservation.reserver) (\(reservation.phone))"
        
        return cell
    }

}
