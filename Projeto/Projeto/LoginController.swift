//
//  LoginController.swift
//  Projeto
//
//  Created by Diogo Pinto on 21/11/2021.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var errorLable: UILabel!
    @IBOutlet weak var usernameTextBox: UITextField!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextBox.delegate = self
        loading.isHidden = true;
        if usernameTextBox.text == "" {
            loginButton.isEnabled = false;
        }
        
        
    }
    // Functions needed to hide the keyboard when pressing "return" or
    // Touching anywhere in the screen
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool // called when   'return' key pressed. return NO to ignore.
    {
          textField.resignFirstResponder()
          return true;
    }

    override func touchesBegan(_: Set<UITouch>, with: UIEvent?) {
         usernameTextBox.resignFirstResponder()
         self.view.endEditing(true)
    }
    //
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (usernameTextBox.text! as NSString).replacingCharacters(in: range, with: string)
        if text.isEmpty {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
        } else {
            loginButton.isEnabled = true
            loginButton.alpha = 1.0
        }
         return true
    }
    
    
    @IBAction func SignUpButton(_ sender: UIButton) {
        //Place login code here
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        self.present(controller, animated: true, completion: nil)

    }
    
    
    @IBAction func LoginButton(_ sender: UIButton) {
        //Place login code here
        loading.isHidden = false
        loading.startAnimating()
        errorLable.isHidden = true
        let username:String = usernameTextBox	.text!
        Post(TextBoxName: username)

    }
    
    
    private func Post(TextBoxName:String){
        guard let ConUrl = URL(string: url + "/api/loginUser") else { return}
        
        
        var request=URLRequest(url: ConUrl )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable]=[
            "name":TextBoxName
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data,_,error in guard let data = data , error == nil else {
                return
            }
        
            do{
                let responsePostRequest = try JSONDecoder().decode(response.self, from: data)
                NSLog(responsePostRequest.status)
                if responsePostRequest.status == "sucess"{
                   
                    DispatchQueue.main.async {
                        self.loading.stopAnimating()
                        self.loading.isHidden = true
                        let defaults = UserDefaults.standard
                        defaults.register(defaults: ["token":""])
                        defaults.register(defaults: ["username":""])
                        defaults.set(responsePostRequest.token ?? nil, forKey:"token" )
                        defaults.set(TextBoxName, forKey:"username" )
                        
                    }
                    
                }else{
                    
                    DispatchQueue.main.async {
                        self.loading.stopAnimating()
                        self.loading.isHidden = true
                        self.errorLable.isHidden = false
                        self.errorLable.textColor = UIColor .red
                        self.errorLable.text = responsePostRequest.message ?? "Utilizador não encontrado"
                    }
                }
            }catch{
                print(error)
            }
        }
        task.resume()
        
    }
    
    
    
    struct response:Codable {
        let status:String
        let token:String??;
        let message:String??;
        
    }
}

