//
//  ChangeValuesViewController.swift
//  Projeto
//
//  Created by Eduarda Ramos on 06/01/2022.
//

import UIKit

class ChangeValuesViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var verticalStack: UIStackView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    @IBOutlet weak var inputview: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    var topLabelText = ""
    var textfieldText = ""
    var isNumeric = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.text = topLabelText
        textfield.text = textfieldText
        textfield.delegate = self
        textfield.layer.borderWidth = 0
        verticalStack.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
    
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if isNumeric {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        return true
    }
    
    // Functions needed to hide the keyboard when pressing "return" or
    // Touching anywhere in the screen
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when   'return' key pressed. return NO to ignore.
    {
          textField.resignFirstResponder()
          return true;
    }

    override func touchesBegan(_: Set<UITouch>, with: UIEvent?) {
         textfield.resignFirstResponder()
         self.view.endEditing(true)
    }
    //
    

}
