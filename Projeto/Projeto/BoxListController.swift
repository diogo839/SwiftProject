//
//  BoxListController.swift
//  Projeto
//
//  Created by Eduarda Joana Ferreira Ramos on 02/12/2021.
//
	

import UIKit
struct Box: Decodable{
    let Nome:String
    let Id:String
}

class BoxListController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberBoxes
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: 145, height: 145)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = boxList.dequeueReusableCell(withReuseIdentifier: "boxCell", for: indexPath) as! BoxListCell
       
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        //cell.contentView.layer.backgroundColor = CGColor(red: 188, green: 221, blue: 121, alpha: 1)
        cell.layer.backgroundColor = CGColor(red: 188, green: 221, blue: 121, alpha: 1)
        
        cell.layer.cornerRadius = 10
        
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
 
        /*
        if indexPath.row == 0 {
            // AR BUTTON
            cell.boxName.text = "Add new"
        }
        */
        cell.setup(with: boxes[indexPath.row])
        
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(boxes[indexPath.row].Id)

      }
    
    var boxes = [Box]()
    var numberBoxes = 0
    
    
        

    private func Post(){
        guard let ConUrl = URL(string: url + "/api/GetBox/box/all") else { return}
        
        
        var request=URLRequest(url: ConUrl )
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let token = UserDefaults.standard.string(forKey: "token")
        request.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
    
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { [self] data, response, error in

              guard error == nil else {
                  return
              }

              guard let data = data else {
                  return
              }

             do {
        
                self.boxes = try JSONDecoder().decode([Box].self, from: data)
                numberBoxes = boxes.count
                
                boxes.insert(Box.init(Nome: "➕ Add New", Id: "0"), at: 0)
                DispatchQueue.main.async {
                    self.boxList.reloadData()
                }
             } catch let error {
               print(error.localizedDescription)
             }
          })

          task.resume()
        
    }

    @IBOutlet weak var boxList: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Post()
        self.navigationController?.isNavigationBarHidden = true
        boxList.delegate = self;
        boxList.dataSource = self;

    }

    struct response:Codable {
        let status:String
        let list:String??;
        let message:String??;
        
    }
    

}
