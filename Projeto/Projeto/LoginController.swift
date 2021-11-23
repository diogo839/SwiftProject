//
//  LoginController.swift
//  Projeto
//
//  Created by Diogo Pinto on 21/11/2021.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var usernameBox: UITextField!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        let bootomLine = CALayer()
       // bootomLine.frame = CGRect(x:1, y: usernameBox.frame.height - 1, width: usernameBox.frame.width, height: 1.0)
        bootomLine.backgroundColor = UIColor.gray.cgColor
        //usernameBox.borderStyle = UITextField.BorderStyle.none
        //usernameBox.layer.addSublayer(bootomLine)
    }
    

    
    @IBAction func LoginSubmit(_ sender: UIButton, forEvent event: UIEvent) {
        
        let value:String = textBox.text!
       Post(TextBoxName: value)
        
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
                let response1 = try JSONDecoder().decode(response.self, from: data)
                
                if response1.status == "sucess"{
                    DispatchQueue.main.async {
                        let defaults = UserDefaults.standard
                        defaults.register(defaults: ["token":""])
                        defaults.register(defaults: ["username":""])
                        defaults.set(response1.token ?? nil, forKey:"token" )
                        defaults.set(TextBoxName, forKey:"username" )
                        
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.ErrorLabel.textColor = UIColor .red
                        self.ErrorLabel.text = response1.message ?? "Utilizador não encontrado"
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

