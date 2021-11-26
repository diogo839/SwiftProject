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
        
        if usernameField.text == "" && smartBoxIDField.text == "" {
            createButton.isEnabled = false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when   'return' key pressed. return NO to ignore.
    {
          textField.resignFirstResponder()
          return true;
    }

    override func touchesBegan(_: Set<UITouch>, with: UIEvent?) {
        usernameField.resignFirstResponder()
        smartBoxIDField.resignFirstResponder()
        boxNameField.resignFirstResponder()


         self.view.endEditing(true)
    }
    //
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textbox1 = (usernameField.text! as NSString).replacingCharacters(in: range, with: string)
        let textbox2 = (smartBoxIDField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textbox1.isEmpty || textbox2.isEmpty {
            createButton.isEnabled = false
            createButton.alpha = 0.5
        } else {
            createButton.isEnabled = true
            createButton.alpha = 1.0
        }
         return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
