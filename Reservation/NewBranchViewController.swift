//
//  NewBranchViewController.swift
//  Reservation
//
//  Created by Sung Gon Yi on 26/12/2016.
//  Copyright © 2016 skon. All rights reserved.
//

import UIKit
import CoreData

protocol AddressViewControllerDelegate {
    func addressSearched(_ addressViewController: AddressViewController, address: String)
}

class NewBranchViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AddressViewControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var searchAddressButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
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

    @IBAction func searchAddress(_ sender: Any) {
    }
    
    @IBAction func photoTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addBranch(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity         = NSEntityDescription.entity(forEntityName: "Branch", in: managedContext)
        let branch         = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        branch.setValue(self.nameTextField.text,    forKey: "name")
        branch.setValue(self.phoneTextField.text,   forKey: "phone")
        branch.setValue(self.addressTextField.text, forKey: "address")
        
        if let image = self.photoView.image, let imageData = UIImagePNGRepresentation(image) {
            let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.nameTextField.text!.replacingOccurrences(of: " ", with: "_") + ".png")
            try? imageData.write(to: filename, options: .atomic)
            branch.setValue(filename, forKey: "photo")
        }
        
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
    
    // ImagePicker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.photoView.image = info["UIImagePickerControllerOriginalImage"] as! UIImage?
        self.dismiss(animated: true)
    }
    
    // TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.tag)
        if textField.tag == 2000 {
            self.searchAddressButton.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 2000 {
            self.searchAddressButton.isHidden = true
        }

        guard let name = self.nameTextField.text, let phone = self.phoneTextField.text, let address = self.addressTextField.text else {
            self.saveButton.isEnabled = false
            return
        }
        
        if name != "" && phone != "" && address != "" {
            self.saveButton.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let naviagationController = segue.destination as! UINavigationController
        let destinationViewController = naviagationController.viewControllers.first as! AddressViewController
        if let address = self.addressTextField.text {
            destinationViewController.address  = address
            destinationViewController.delegate = self
        }
    }
    
    func addressSearched(_ addressViewController: AddressViewController, address: String) {
        
    }
}
