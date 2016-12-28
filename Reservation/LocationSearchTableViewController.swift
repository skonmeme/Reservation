//
//  LocationSearchTableViewController.swift
//  Reservation
//
//  Created by Sung Gon Yi on 27/12/2016.
//  Copyright © 2016 skon. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController, UISearchResultsUpdating {

    var delegate: LocationSearchTableViewControllerDelegate?
    var mapItems = [MKMapItem]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mapItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)

        let placemark = self.mapItems[indexPath.row].placemark
        cell.textLabel?.text       = placemark.name
        // cell.detailTextLabel?.text = (placemark.addressDictionary?[AnyHashable("FormattedAddressLines")] as? [String])?.joined(separator: ", ") ?? ""
        //cell.detailTextLabel?.text = placemark.title
        cell.detailTextLabel?.text = placemark.pseudoAddress
        
        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.locationSearchDidSelected(self, placemark: mapItems[indexPath.row].placemark
)
        self.dismiss(animated: true)
    }
    
    // Search Result Updating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = self.mapView, let searchText = searchController.searchBar.text else { return }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, _) in
            guard let response = response else { return }
            self.mapItems = response.mapItems
            self.tableView.reloadData()
        }
    }

}
