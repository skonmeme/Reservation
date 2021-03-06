//
//  NewReservationViewController.swift
//  Reservation
//
//  Created by Sung Gon Yi on 23/12/2016.
//  Copyright © 2016 skon. All rights reserved.
//

import UIKit
import CoreData

class NewReservationViewController: UITableViewController, UITextFieldDelegate {
    
    var branch: Branch?
    
    let rowsOfDate = ["From": 3, "To": 5]
    var rowOfDatePicker = -1
    var reserver = String()
    var phone    = String()
    var fromDate = Date()
    var toDate   = Date(timeInterval: 3600, since: Date())
    
    var contentViewResizeRequired = true
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        headerView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.tableHeaderView = headerView
        
        // Footer
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        footerView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.tableFooterView = footerView
        self.contentViewResizeRequired = true
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
    
    func openDatePicker(_ id: Int) {
        self.rowOfDatePicker = id
        UIView.animate(withDuration: 0.5) {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(row: id + 1, section: 0)], with: .top)
            self.tableView.deselectRow(at: IndexPath(row: id, section: 0), animated: true)
            self.tableView.endUpdates()
        }
    }
    
    func closeDatePicker(_ id: Int) {
        self.rowOfDatePicker = -1
        UIView.animate(withDuration: 0.5) {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(row: id + 1, section: 0)], with: .top)
            self.tableView.deselectRow(at: IndexPath(row: id, section: 0), animated: true)
            self.tableView.endUpdates()
        }
    }
    
    @IBAction func cancelReservation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addReservation(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity         = NSEntityDescription.entity(forEntityName: "Reservation", in: managedContext)
        let reservation    = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        reservation.setValue(self.reserver, forKey: "reserver")
        reservation.setValue(self.phone,    forKey: "phone")
        reservation.setValue(self.fromDate, forKey: "from")
        reservation.setValue(self.toDate,   forKey: "to")
        reservation.setValue(self.branch,   forKey: "branch")

        do {
            try managedContext.save()
            self.dismiss(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            let alertController = UIAlertController(title: "Could not save.", message: "\(error), \(error.userInfo)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }
    }

    
    @IBAction func datePicked(_ sender: UIDatePicker) {
        if rowOfDatePicker == 3 {
            if self.toDate.compare(Date(timeInterval: 600, since: sender.date)) == .orderedAscending {
                sender.date = Date(timeInterval: -600, since: self.toDate)
            }
            self.fromDate = sender.date
        } else if rowOfDatePicker == 5 {
            if self.fromDate.compare(Date(timeInterval:-600, since: sender.date)) == .orderedDescending {
                sender.date = Date(timeInterval: 600, since: fromDate)
            }
            self.toDate = sender.date
        }
        self.tableView.reloadData()
    }
    
    // TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) {
            if cell.reuseIdentifier! == "DateCell" {
                if self.rowOfDatePicker == indexPath.row {
                    self.closeDatePicker(self.rowOfDatePicker)
                } else {
                    let dateCell = cell as! ReservationDateTableViewCell
                    self.openDatePicker(self.rowsOfDate[dateCell.titleLabel.text!]!)
                }
            } else {
                if self.rowOfDatePicker > 0 {
                    self.closeDatePicker(self.rowOfDatePicker)
                }
            }
        }
    }
        
    // TableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        switch indexPath.row {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! ReservationTextTableViewCell
            cell.title.text        = self.reserver
            cell.title.placeholder = "Name"
            cell.title.tag         = 1001
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! ReservationTextTableViewCell
            cell.title.text        = self.phone
            cell.title.placeholder = "Phone"
            cell.title.tag         = 1002
            return cell
        case 3:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! ReservationDateTableViewCell
            cell.titleLabel.text = "From"
            cell.dateLabel.text  = formatter.string(from: self.fromDate)
            return cell
        case 4:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as! ReservationDatePickerTableViewCell
            return cell
        case 5:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! ReservationDateTableViewCell
            cell.titleLabel.text = "To"
            cell.dateLabel.text  = formatter.string(from: self.toDate)
            return cell
        case 6:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as! ReservationDatePickerTableViewCell
            return cell
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "BlankCell", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 4, 6:
            if (indexPath.row - 1) == self.rowOfDatePicker {
                return 217
            } else {
                return 0
            }
        default: break
        }
        return 44
    }
    
    // TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.rowOfDatePicker > 0 {
            self.closeDatePicker(self.rowOfDatePicker)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }

        if textField.tag == 1001 {
            self.reserver = text
        } else if textField.tag == 1002 {
            self.phone = text
        }
        
        if self.reserver != "" && self.phone != "" {
            self.addButton.isEnabled = true
        } else {
            self.addButton.isEnabled = false
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = textField.text else { return false }
        
        if let range = text.range(from: range) {
            text = text.replacingCharacters(in: range, with: string)
            textField.text = text
        }

        if textField.tag == 1001 {
            self.reserver = text
        } else if textField.tag == 1002 {
            self.phone = text
        }
        
        if self.reserver != "" && self.phone != "" {
            self.addButton.isEnabled = true
        } else {
            self.addButton.isEnabled = false
        }

        return false
    }
    
    override func viewDidLayoutSubviews() {
        let baseHeight: CGFloat = 44
        let navigationHeight    = self.tableView.contentInset.top
        
        if let footerView = self.tableView.tableFooterView {
            // View size - (Content Size - Footer View Size)
            let requiredHeight = self.view.frame.height - (self.tableView.contentSize.height - footerView.frame.height)
            var frame = footerView.frame
            if requiredHeight > baseHeight + navigationHeight {
                frame.size.height = requiredHeight - navigationHeight
            } else {
                frame.size.height = baseHeight
            }
            self.tableView.tableFooterView?.frame = frame

            // readjust ContentView frame (tricky)
            if self.contentViewResizeRequired {
                self.tableView.tableFooterView = self.tableView.tableFooterView
                self.contentViewResizeRequired = false
            } else {
                self.contentViewResizeRequired = true
            }
        }
    }
    
}
