//
//  RegisterViewController.swift
//  Projeto
//
//  Created by Diogo Pinto on 23/11/2021.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
  
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var smartBoxIDField: UITextField!
    @IBOutlet weak var boxNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        usernameField.delegate = self
        smartBoxIDField.delegate = self
        boxNameField.delegate = self
        
        usernameField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        smartBoxIDField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
               
        
        if usernameField.text == "" && smartBoxIDField.text == "" {
            createButton.isEnabled = false
        }
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    //Disables the "Create" button if username or SmartBoxID not filled
    @objc func textChanged(_ textField: UITextField) {
        createButton.isEnabled = usernameField.text != "" && smartBoxIDField.text != ""
            
        }
   
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    //Function to close keyboard on "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when   'return' key pressed. return NO to ignore.
    {
          textField.resignFirstResponder()
          return true;
    }
    

    @IBAction func CreateButton(_ sender: Any) {
        
    }
    
}
