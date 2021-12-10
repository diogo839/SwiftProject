//
//  LoginController.swift
//  Projeto
//
//  Created by Diogo Pinto on 21/11/2021.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var UsernameBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        let bootomLine = CALayer()
        bootomLine.frame = CGRect(x:1, y: UsernameBox.frame.height - 1, width: UsernameBox.frame.width, height: 1.0)
        bootomLine.backgroundColor = UIColor.gray.cgColor
        UsernameBox.borderStyle = UITextField.BorderStyle.none
        UsernameBox.layer.addSublayer(bootomLine)
    }
    

    
    @IBAction func LoginSubmit(_ sender: UIButton, forEvent event: UIEvent) {
        let User = user(name: "", token: "")
    }
    
}
