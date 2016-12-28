//
//  AddressViewController.swift
//  Reservation
//
//  Created by Sung Gon Yi on 27/12/2016.
//  Copyright © 2016 skon. All rights reserved.
//

import UIKit
import MapKit
import Contacts

protocol LocationSearchTableViewControllerDelegate {
    func locationSearchDidSelected(_ locationSearchTableViewController: LocationSearchTableViewController, placemark: MKPlacemark)
}

extension MKPlacemark {
    var pseudoAddress: String? {
        get {
            return (self.addressDictionary?[AnyHashable("FormattedAddressLines")] as? [String])?.joined(separator: ", ") ?? ""
        }
    }
}

class AddressViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, LocationSearchTableViewControllerDelegate {

    var delegate: AddressViewControllerDelegate?
    
    var address = String()
    
    var locationManager  = CLLocationManager()
    var searchController = UISearchController()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
        
        // Cancel
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(AddressViewController.cancelSearch))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddressViewController.selectSearch))
        
        // Search bar
        if let storyboard = storyboard {
            let locationSearchTableViewController = storyboard.instantiateViewController(withIdentifier: "LocationSearchTableView") as! LocationSearchTableViewController
            locationSearchTableViewController.mapView  = self.mapView
            locationSearchTableViewController.delegate = self
            self.searchController = UISearchController(searchResultsController: locationSearchTableViewController)
            self.searchController.searchResultsUpdater = locationSearchTableViewController
        }
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.placeholder = "Search for places"
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.navigationItem.titleView = self.searchController.searchBar
        self.definesPresentationContext = true
        
        // LocationSearchTableViewDelegate
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
    
    @IBAction func cancelSearch(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func selectSearch(_ sender: Any) {
        if let address = self.searchController.searchBar.text {
            self.delegate?.addressSearched(self, address: address)
        }
        self.dismiss(animated: true)
    }
    
    // Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
    
    func locationSearchDidSelected(_ locationSearchTableViewController: LocationSearchTableViewController, placemark: MKPlacemark) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title      = placemark.name
        annotation.subtitle   = placemark.pseudoAddress
        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(MKCoordinateRegion(center: placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        
        self.searchController.searchBar.text = placemark.pseudoAddress
    }
    
}
