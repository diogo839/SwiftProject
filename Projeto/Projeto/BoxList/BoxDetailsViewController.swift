//
//  BoxDetailsViewController.swift
//  Projeto
//
//  Created by Eduarda Ramos on 13/12/2021.
//

import UIKit

class BoxDetailsViewController: UIViewController {
    var selectedBox:Box = Box.init(Nome: "", Id: "1")
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var NavigationBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        label.text = selectedBox.Id
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          self.navigationController?.navigationBar.isHidden = false
      
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
