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
    @IBOutlet weak var saveButton: UIButton!
    
    var topLabelText = ""
    var textfieldText = ""
    var isNumeric = false
    var value = ""
    var idBox = ""
    var valueLabel = ""
    var infoText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.text = topLabelText
        infoLabel.text = infoText
        textfield.text = textfieldText
        textfield.delegate = self
        textfield.layer.borderWidth = 0
        verticalStack.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
    
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        view.addGestureRecognizer(tap)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if isNumeric {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if string == numberFiltered {
                let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
              if newText.isEmpty {
                return true
              }
              else{
                if valueLabel == "Humidade" {
                    if let intValue = Int(newText), intValue <= 100 {
                      return true
                    }
                    return false
                }
                if valueLabel == "Luminosidade" {
                    if let intValue = Int(newText), intValue <= 1000 {
                      return true
                    }
                    return false
                }
                if valueLabel == "HumidadeSolo" {
                    if let intValue = Int(newText), intValue <= 100 {
                      return true
                    }
                    return false
                }
                if valueLabel == "Temperatura" {
                    if let intValue = Int(newText), intValue <= 50 {
                      return true
                    }
                    return false
                }
              }
                
            }else{
                return false
            }
            
        }
        return true
    }
    
    // Functions needed to hide the keyboard when pressing "return" or
    // Touching anywhere in the screen
   
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func touchesBegan(_: Set<UITouch>, with: UIEvent?) {
         textfield.resignFirstResponder()
         self.view.endEditing(true)
    }
    //
    
    @IBAction func changeValues(_ sender: Any) {
        Post(Value: textfield.text!, BoxId: idBox, Type: valueLabel)
    }
    
    private func Post(Value:String,BoxId:String,Type:String){
        guard let ConUrl = URL(string: url + "/api/alterIdeals") else { return}
        
        var request=URLRequest(url: ConUrl )
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.string(forKey: "token")
        request.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
        
        let body: [String: AnyHashable]=[
            "id":BoxId,
            "type":Type,
            "value":Value
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data,_,error in guard let data = data , error == nil else {
                return
            }
            do{
                let responsePostRequest = try JSONDecoder().decode(responseCreateUser.self, from: data)
                NSLog(responsePostRequest.status)
                print(responsePostRequest)
                if responsePostRequest.status == "success"{
                   
                    DispatchQueue.main.async {
                        let refreshAlert = UIAlertController(title: "Success", message: "Value updated successfully.", preferredStyle: UIAlertController.Style.alert)

                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshBoxDetails"), object: nil)

                                    self.dismiss(animated: true, completion: nil)
                                              }))

                        self.present(refreshAlert, animated: true, completion: nil)
                    }
                }else{
                    
                    DispatchQueue.main.async {
                        
                    }
                }
            }catch{
                print(error)
            }
        }
        task.resume()
        
    }
    
    struct responseCreateUser:Codable {
        let status:String
    }
}
