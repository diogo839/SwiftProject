//
//  HomepageController.swift
//  Projeto
//
//  Created by Eduarda Joana Ferreira Ramos on 02/12/2021.
//

import UIKit

class HomepageController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var arView: UIView!
    @IBOutlet weak var arImage: UIImageView!
    @IBOutlet weak var test: UILabel!
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        arView.layer.cornerRadius = 22;
        arView.layer.masksToBounds = true;
        
    
        
    }
       

}

