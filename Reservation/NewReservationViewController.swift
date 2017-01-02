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
    
    let rowsOfDate = ["From": 3, "To": 5]
    var rowOfDatePicker = -1
    var reserver = String()
    var phone    = String()
    var fromDate = Date()
    var toDate   = Date(timeInterval: 600, since: Date())
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        headerView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.tableHeaderView = headerView
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        footerView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.tableFooterView = footerView
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
            self.tableView.sectionFooterHeight = 216
            self.tableView.endUpdates()
        }
    }
    
    func footerSizeToFit() {
        let requiredHeight = self.view.frame.height - self.tableView.contentSize.height
        let footerView: UIView
        // footer with header and navigation bar
        if requiredHeight > 44 * 2 + 20 {
            footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: requiredHeight - (44 + 20)))
        } else {
            footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        }
        footerView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.tableFooterView = footerView
    }

    @IBAction func cancelReservation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addReservation(_ sender: Any) {
        self.dismiss(animated: true, completion: { print("merong") })
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
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("DidDeselect: " + String(indexPath.row))
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
    
    override func viewDidLayoutSubviews() {
        let baseHeight: CGFloat = 44
        
        if let footerView = self.tableView.tableFooterView {
            print("\(self.view.frame.height) - \(self.tableView.contentSize.height)")
            let requiredHeight = self.view.frame.height - self.tableView.contentSize.height
            var frame = footerView.frame
            // footer with header and navigation bar
            if requiredHeight > baseHeight * 2 + 20 {
                frame.size.height = requiredHeight - (baseHeight + 20)
            } else {
                frame.size.height = baseHeight
            }
            self.tableView.tableFooterView?.frame = frame
        }
    }
    
}
