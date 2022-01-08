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
    var value = ""
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.text = topLabelText
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
    
    @IBAction func changeValues(_ sender: Any) {
    }
    private func Post(BoxId:String){
        guard let ConUrl = URL(string: url + "/api/openWaterValve") else { return}
        
        var request=URLRequest(url: ConUrl )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.string(forKey: "token")
        request.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
        
        let body: [String: AnyHashable]=[
            "id":BoxId,
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
                        let refreshAlert = UIAlertController(title: "Success", message: "Box added successfully.", preferredStyle: UIAlertController.Style.alert)

                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PeformAfterPresenting"), object: nil)

                                    self.dismiss(animated: true, completion: nil)
                                              }))

                        self.present(refreshAlert, animated: true, completion: nil)
                    }
                    
                }else{
                    
                    DispatchQueue.main.async {
                        //self.errorLabel.text=responsePostRequest.status
                        //self.errorLabel.isHidden = false
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
