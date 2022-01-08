//
//  AddNewBoxViewController.swift
//  Projeto
//
//  Created by Eduarda Ramos on 13/12/2021.
//

import UIKit

class AddNewBoxViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var smbIDField: UITextField!
    @IBOutlet weak var boxNameField: UITextField!
    @IBOutlet weak var addBoxButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        smbIDField.delegate = self
        boxNameField.delegate = self
        
        smbIDField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        boxNameField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        if smbIDField.text == "" && boxNameField.text == "" {
            addBoxButton.isEnabled = false
        }
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        view.addGestureRecognizer(tap)
    }
    
    //Disables the "Create" button if username or SmartBoxID not filled
    @objc func textChanged(_ textField: UITextField) {
        addBoxButton.isEnabled = smbIDField.text != "" && boxNameField.text != ""
        }
   
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func addBox(_ sender: Any) {
        Post(BoxName: boxNameField.text!, BoxId: smbIDField.text!)
    }
    
    private func Post(BoxName:String,BoxId:String){
        guard let ConUrl = URL(string: url + "/api/pushBox") else { return}
        
        var request=URLRequest(url: ConUrl )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.string(forKey: "token")
        request.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
        
        let body: [String: AnyHashable]=[
            "name":BoxName,
            "id":BoxId,
            "tipo":BoxName
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
                        self.errorLabel.text=responsePostRequest.status
                        self.errorLabel.isHidden = false
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

