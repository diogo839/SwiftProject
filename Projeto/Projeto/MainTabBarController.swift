//
//  MainTabBarController.swift
//  Projeto
//
//  Created by Eduarda Ramos on 02/12/2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        
        if (UserDefaults.standard.string(forKey: "token") == nil) {
                showLoginScreen()
        }else{
            super.viewDidLoad()
        }
        

        // Do any additional setup after loading the view.
    }
    func showLoginScreen() {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        DispatchQueue.main.async {
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
    
}
