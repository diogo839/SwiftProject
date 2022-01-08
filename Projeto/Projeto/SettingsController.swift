//
//  SettingsController.swift
//  Projeto
//
//  Created by Eduarda Joana Ferreira Ramos on 02/12/2021.
//

import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "optimalValuesCell", for: indexPath) as! OptimalValuesTableViewCell
        
        
        if(indexPath.row == 0){
            cell.mainLabel.text = "Go Premium"
            cell.valueLabel.text = ""
        }
        if(indexPath.row == 1){
            cell.mainLabel.text = "Notifications"
            cell.valueLabel.text = ""
        }
        if(indexPath.row == 2){
            cell.mainLabel.text = "Logout"
            cell.valueLabel.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            let refreshAlert = UIAlertController(title: "Coming Soon", message: "This functionality is coming soon.", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                                    tableView.deselectRow(at: indexPath, animated: false)              }))

            present(refreshAlert, animated: true, completion: nil)
            
        }
        if(indexPath.row == 2){
            let refreshAlert = UIAlertController(title: "Logout", message: "Your session will be closed.", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [self] (action: UIAlertAction!) in
                Logout(self)
              }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                                                    tableView.deselectRow(at: indexPath, animated: false)              }))

            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
    

   
    @IBOutlet weak var settingsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self


        // Do any additional setup after loading the view.
    }
    
    @IBAction func Logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "username")
        
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
