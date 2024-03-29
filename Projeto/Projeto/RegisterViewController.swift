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
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        usernameField.delegate = self
        smartBoxIDField.delegate = self
        boxNameField.delegate = self
        
        usernameField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        smartBoxIDField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
               
        createButton.layer.cornerRadius = 10
        if usernameField.text == "" && smartBoxIDField.text == "" {
            createButton.isEnabled = false
        }
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        errorMessage.isHidden = true
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
    

    @IBAction func CreateButton(_ sender: UIButton) {
        errorMessage.text=""
        Post(BoxName: boxNameField.text! , Username: usernameField.text!, BoxId: smartBoxIDField.text ?? "box")
        
    }
    
    private func Post(BoxName:String,Username:String,BoxId:String){
        guard let ConUrl = URL(string: url + "/api/addUser") else { return}
        
        var request=URLRequest(url: ConUrl )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable]=[
            "name":Username,
            "id":BoxId,
            "namebox":BoxName
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data,_,error in guard let data = data , error == nil else {
                return
            }
        
            do{
                let responsePostRequest = try JSONDecoder().decode(responseCreateUser.self, from: data)
                if responsePostRequest.status == "sucess"{
                   
                    DispatchQueue.main.async {
                        let refreshAlert = UIAlertController(title: "Success", message: "Your account was created successfully. You will now be redirected to homepage.", preferredStyle: UIAlertController.Style.alert)

                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                                                let defaults = UserDefaults.standard
                                                                defaults.register(defaults: ["token":""])
                                                                defaults.register(defaults: ["username":""])
                                                                defaults.set(responsePostRequest.token ?? nil, forKey:"token" )
                                                                defaults.set(BoxName, forKey:"username" )
                                                                self.redirectToHomepage()              }))

                        self.present(refreshAlert, animated: true, completion: nil)
                        
                    }
                }else{
                    DispatchQueue.main.async {
                        self.errorMessage.isHidden = false
                        self.errorMessage.text=responsePostRequest.message!
                    }
                }
            }catch{
                print(error)
            }
        }
        task.resume()
        
    }
    
    func redirectToHomepage() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "MainTabBarController") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }
    
    
    struct responseCreateUser:Codable {
        let status:String
        let token:String??;
        let message:String?;
        
    }
    
}
