//
//  AddCourseViewController.swift
//  WhiteBoard
//
//  Created by Venugopal Reddy Devarapally on 07/04/17.
//  Copyright © 2017 venu. All rights reserved.
//

import UIKit
import os.log

class AddCourseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var nameTextFiled: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var subject: Subject?
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextFiled.delegate = self
        descriptionTextField.delegate = self
        
        nameTextFiled.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        descriptionTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddCourseViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidChange(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextFiled.text
        let photo = imageView.image
        let descriptionText = descriptionTextField.text
        
        subject = Subject(title:name!, subTitle:descriptionText!, photo: photo)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        dismissKeyboard()
        self.navigationController?.dismiss(animated: true, completion: { 
            //Nothing
        })
    }
    
    @IBAction func openPhotoLibraryButtonAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.navigationController?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func openCameraButtonAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.navigationController?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("fsadfsad")
        let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imageView.image = image
        self.dismiss(animated: true) { 
            //none
        }
    }
    
    func updateSaveButtonState(){
        let title = nameTextFiled.text ?? ""
        let subTitle = descriptionTextField.text ?? ""
        if title.isEmpty || subTitle.isEmpty {
            saveButton.isEnabled = false
        }else{
            saveButton.isEnabled = true
        }
        //saveButton.isEnabled = !text.isEmpty
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
