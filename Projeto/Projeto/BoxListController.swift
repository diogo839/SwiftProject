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
    let Humidade:Float
    let HumidadeSolo:Float
    let Luminosidade:Float
    let Temperatura:Float
    let HumidadeIdeal:Float
    let HumidadeSoloIdeal:Float
    let LuminosidadeIdeal:Float
    let TemperaturaIdeal:Float
}

class BoxListController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var programVar : Box?
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
 
        cell.setup(with: boxes[indexPath.row])
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(boxes[indexPath.row].Id)
        if(boxes[indexPath.row].Id == "0"){
        
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controller = story.instantiateViewController(identifier: "AddNewBoxViewController") as! AddNewBoxViewController
            self.present(controller, animated: true, completion: nil)

            
        }else{
            programVar = boxes[indexPath.row]
            performSegue(withIdentifier: "BoxDetails", sender: self)
  
        }

      }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let boxDetailsVC = segue.destination as? BoxDetailsViewController else {return}
        boxDetailsVC.selectedBox = programVar!
        segue.destination.navigationItem.title = programVar?.Nome
       
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
                
                boxes.insert(Box.init(Nome: "➕ Add New", Id: "0", Humidade:0, HumidadeSolo: 0, Luminosidade:0, Temperatura: 0, HumidadeIdeal: 0, HumidadeSoloIdeal: 0, LuminosidadeIdeal: 0, TemperaturaIdeal: 0), at: 0)
                numberBoxes = boxes.count
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
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          self.navigationController?.navigationBar.isHidden = true
      
    }

    struct response:Codable {
        let status:String
        let list:String??;
        let message:String??;
        
    }
    

}
