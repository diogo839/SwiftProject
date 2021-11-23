//
//  RegisterViewController.swift
//  Projeto
//
//  Created by Diogo Pinto on 23/11/2021.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var NameBox: UITextField!
    @IBOutlet weak var SmartBoxBox: UITextField!
    @IBOutlet weak var UsernameBox: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bootomLine = CALayer()
        let bootomLine2 = CALayer()
        let bootomLine3 = CALayer()
        bootomLine3.frame = CGRect(x:1, y: NameBox.frame.height - 1, width: NameBox.frame.width, height: 1.0)
        bootomLine2.frame = CGRect(x:1, y: SmartBoxBox.frame.height - 1, width: SmartBoxBox.frame.width, height: 1.0)
        bootomLine.frame = CGRect(x:1, y: UsernameBox.frame.height - 1, width: UsernameBox.frame.width, height: 1.0)
        bootomLine.backgroundColor = UIColor.gray.cgColor
        bootomLine2.backgroundColor = UIColor.gray.cgColor
        bootomLine3.backgroundColor = UIColor.gray.cgColor
        
        UsernameBox.borderStyle = UITextField.BorderStyle.none
        UsernameBox.layer.addSublayer(bootomLine)
        SmartBoxBox.borderStyle = UITextField.BorderStyle.none
        SmartBoxBox.layer.addSublayer(bootomLine2)
        NameBox.borderStyle = UITextField.BorderStyle.none
        NameBox.layer.addSublayer(bootomLine3)
        
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
