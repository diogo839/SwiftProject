//
//  ViewController.swift
//  Projeto
//
//  Created by Diogo Pinto on 21/11/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
         let stringOne = defaults.string(forKey: "token")
            print(stringOne)
        
        performSegue(withIdentifier: "LoginView", sender: nil)
        // Do any additional setup after loading the view.
    }
    



}

