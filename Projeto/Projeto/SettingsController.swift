//
//  SettingsController.swift
//  Projeto
//
//  Created by Eduarda Joana Ferreira Ramos on 02/12/2021.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var tokenLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        usernameLable.text = UserDefaults.standard.string(forKey: "username")
        tokenLable.text = UserDefaults.standard.string(forKey: "token")


        // Do any additional setup after loading the view.
    }
    
    @IBAction func Logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "username")
        usernameLable.text = UserDefaults.standard.string(forKey: "username")
        tokenLable.text = UserDefaults.standard.string(forKey: "token")
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "LoginController") as! LoginController
        self.present(controller, animated: true, completion: nil)


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
