//
//  HomepageController.swift
//  Projeto
//
//  Created by Eduarda Joana Ferreira Ramos on 02/12/2021.
//

import UIKit

class HomepageController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth  = UIScreen.main.fixedCoordinateSpace.bounds.width
        if(screenWidth >= 428){
            return CGSize(width: 329, height: 155)
        }else{
            return CGSize(width: screenWidth-65, height: 155)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "ARSegue", sender: self)
        }
        if indexPath.row == 1 {
            let refreshAlert = UIAlertController(title: "Coming Soon", message: "This functionality is coming soon.", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                                    collectionView.deselectItem(at: indexPath, animated: false)              }))

            present(refreshAlert, animated: true, completion: nil)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        
        let cell = headerCollectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath) as! ButtonCell
     
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        

        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        if indexPath.row == 0 {
            // AR BUTTON
            cell.buttonImage.image = UIImage(named: "soil_humidity.png")
            
            
            cell.buttonLabel.text = "AR"
        }
        if indexPath.row == 1 {
            // GUIDE BUTTON
            cell.buttonImage.image = UIImage(named: "pexels-cottonbro-6266098.png")
            cell.buttonLabel.text = "Planting guide"
            
        }        
        return cell
    }
     
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        headerCollectionView.delegate = self;
        headerCollectionView.dataSource = self;
        
    }
    
    func redirectToHomepage() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "ARViewController") as! UIViewController
        self.present(controller, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ARSegue"){
            
            self.navigationController?.isNavigationBarHidden = false

            guard let boxDetailsVC = segue.destination as? ARViewController else {return}
            
            segue.destination.navigationController?.isNavigationBarHidden = false

        }
       
    }
}



