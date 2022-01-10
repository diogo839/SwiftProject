//
//  BoxDetailsViewController.swift
//  Projeto
//
//  Created by Eduarda Ramos on 13/12/2021.
//

import UIKit


class BoxDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case trueValuesTableView:
            return 4
        case optimalValuesTableView:
            return 4
        case settingsTableView:
            return 2
        default:
            return 4
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case trueValuesTableView:
            let cell = trueValuesTableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
            
            
            if(indexPath.row == 0){
                cell.mainLabel.text = "Air Humidity"
                cell.valueLabel.text = String(selectedBox.Humidade) + "%"
                
            }
            if(indexPath.row == 1){
                cell.mainLabel.text = "Soil Humidity"
                cell.valueLabel.text = String(selectedBox.HumidadeSolo) + "%"
            }
            if(indexPath.row == 2){
                cell.mainLabel.text = "Temperature"
                cell.valueLabel.text = String(selectedBox.Temperatura) + "ºC"
            }
            if(indexPath.row == 3){
                cell.mainLabel.text = "Luminosity"
                cell.valueLabel.text = String(selectedBox.Luminosidade)
            }
            
            return cell
            
        case optimalValuesTableView:
            let cell = optimalValuesTableView.dequeueReusableCell(withIdentifier: "optimalValuesCell", for: indexPath) as! OptimalValuesTableViewCell
            
            
            if(indexPath.row == 0){
                cell.mainLabel.text = "Optimal Air Humidity"
                cell.valueLabel.text = String(selectedBox.HumidadeIdeal) + "%"
                
            }
            if(indexPath.row == 1){
                cell.mainLabel.text = "Optimal Soil Moisture"
                cell.valueLabel.text = String(selectedBox.HumidadeSoloIdeal) + "%"
            }
            if(indexPath.row == 2){
                cell.mainLabel.text = "Optimal Temperature"
                cell.valueLabel.text = String(selectedBox.TemperaturaIdeal) + "ºC"
            }
            if(indexPath.row == 3){
                cell.mainLabel.text = "Optimal Luminosity"
                cell.valueLabel.text = String(selectedBox.LuminosidadeIdeal)
            }
            
            return cell
            
        case settingsTableView:
            let cell = optimalValuesTableView.dequeueReusableCell(withIdentifier: "optimalValuesCell", for: indexPath) as! OptimalValuesTableViewCell
            
            if(indexPath.row == 0){
                cell.mainLabel.text = "Change boxname"
                cell.valueLabel.text = ""
            }
            if(indexPath.row == 1){
                cell.mainLabel.text = "History"
                cell.valueLabel.text = ""
            }

            return cell
        default:
            let cell = optimalValuesTableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
            return cell
        }
    }
  
    
    @IBAction func waterButton(_ sender: Any) {
        guard let ConUrl = URL(string: url + "/api/changeWaterValve") else { return}
        
        var request=URLRequest(url: ConUrl )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.string(forKey: "token")
        request.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
        
        let body: [String: AnyHashable]=[
            "id":selectedBox.Id
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data,_,error in guard let data = data , error == nil else {
                return
            }
        
            do{
                let responsePostRequest = try JSONDecoder().decode(responseWater.self, from: data)
                
                print(responsePostRequest.status)
                if responsePostRequest.status == "success"{
                   
                    DispatchQueue.main.async {
                        
                        if(self.selectedBox.Rega == true){
                            self.selectedBox.Rega = false
                            let refreshAlert = UIAlertController(title: "Water Closed", message: "Water flow closed successfully.", preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PeformAfterPresenting"), object: nil)

                                        self.dismiss(animated: true, completion: nil)
                                                  }))

                            self.present(refreshAlert, animated: true, completion: nil)
                        }else{
                            self.selectedBox.Rega = true
                            let refreshAlert = UIAlertController(title: "Water Opened", message: "Water flow opened successfully.", preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PeformAfterPresenting"), object: nil)

                                        self.dismiss(animated: true, completion: nil)
                                                  }))

                            self.present(refreshAlert, animated: true, completion: nil)
                        }
                        self.changeWaterButtonLabel()
                    }
                    
                }else{
                    
                    DispatchQueue.main.async {
                        //self.errorLabel.text=responsePostRequest.status
                        //self.errorLabel.isHidden = false
                    }
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
        case optimalValuesTableView:
            if indexPath.row == 0 {
                selectedRow = "H"
                selectedRowLabel = "Optimal Air Humidity"
                selectedRowValue = String(selectedBox.HumidadeIdeal)
                type = "Humidade"
                infoText = "This action changes the optimal value for air humidity. Changing this value will affect the operation of the box. There must be chosen a value between 0 and 100."
                performSegue(withIdentifier: "editValuesSegue", sender: self)
            }
            if indexPath.row == 1 {
                selectedRow = "S"
                selectedRowLabel = "Optimal Soil Moisture"
                selectedRowValue = String(selectedBox.HumidadeSoloIdeal)
                type = "HumidadeSolo"
                infoText = "This action changes the optimal value for soil moisture. Changing this value will affect the operation of the box. There must be chosen a value between 0 and 100."
                performSegue(withIdentifier: "editValuesSegue", sender: self)
            }
            if indexPath.row == 2 {
                selectedRow = "T"
                selectedRowLabel = "Optimal Temperature"
                selectedRowValue = String(selectedBox.TemperaturaIdeal)
                type = "Temperatura"
                infoText = "This action changes the optimal value for temperature. Changing this value will affect the operation of the box. There must be chosen a value between 0 and 50."
                performSegue(withIdentifier: "editValuesSegue", sender: self)
            }
            if indexPath.row == 3 {
                selectedRow = "L"
                selectedRowLabel = "Optimal Luminosity"
                selectedRowValue = String(selectedBox.LuminosidadeIdeal)
                type = "Luminosidade"
                infoText = "This action changes the optimal value for luminosity. Changing this value will affect the operation of the box. There must be chosen a value between 0 and 1000."
                performSegue(withIdentifier: "editValuesSegue", sender: self)
            }
            id = selectedBox.Id
            print(id)
            tableView.deselectRow(at: indexPath, animated: false)
            break
        case settingsTableView:
            if indexPath.row == 0 {
                selectedRow = "N"
                selectedRowLabel = "Boxname"
                selectedRowValue = String(selectedBox.Nome)
                type = "Nome"
                infoText = "This action changes the name given to your SmartBox. Changing the name of the box will not affect any other functionality. Select a name of your preference to easily distinguish your boxes."
                performSegue(withIdentifier: "editValuesSegue", sender: self)
            }
            break
            
        default:
            print("you tapped me!")

        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let changeValuesVC = segue.destination as? ChangeValuesViewController else {return}
        if(selectedRow == "N"){
            changeValuesVC.isNumeric = false
        }else{
            changeValuesVC.isNumeric = true

        }
        changeValuesVC.topLabelText = "Changing " + selectedRowLabel
        changeValuesVC.textfieldText = selectedRowValue
        changeValuesVC.valueLabel = type
        changeValuesVC.idBox = selectedBox.Id
        changeValuesVC.infoText = infoText
        
       
    }
    
    var selectedBox:Box = Box.init(Nome: "", Id: "1", Humidade: 0, HumidadeSolo: 0, Luminosidade: 0, Temperatura: 0, HumidadeIdeal: 0, HumidadeSoloIdeal: 0, LuminosidadeIdeal: 0, TemperaturaIdeal: 0, Rega: (0 != 0))
    
    var selectedRowValue = ""
    var selectedRowLabel = ""
    var selectedRow = ""
    var type = ""
    var id = ""
    var infoText = ""
    
    @IBOutlet weak var BoxnameLable: UILabel!
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var trueValuesTableView: UITableView!
    @IBOutlet weak var optimalValuesTableView: UITableView!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var ListButton: UIBarButtonItem!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeWaterButtonLabel()
        BoxnameLable.text = selectedBox.Nome        
        trueValuesTableView.delegate = self
        trueValuesTableView.dataSource = self
        optimalValuesTableView.delegate = self
        optimalValuesTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.backBarButtonItem = ListButton
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           mainScrollView.addSubview(refreshControl) // not required when using UITableViewController
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue:  "RefreshBoxDetails"), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.navigationController?.navigationBar.isHidden = false

    }
    
    @objc func refresh(_ sender: AnyObject) {
        GetBoxData()
        NavigationBar.title = selectedBox.Nome
        BoxnameLable.text = selectedBox.Nome
        refreshControl.endRefreshing()
    }
    
    private func GetBoxData(){
        guard let ConUrl = URL(string: url + "/api/GetBox/box/singleId/" + selectedBox.Id) else { return}
        
        
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
            
                self.selectedBox = try JSONDecoder().decode(Box.self, from: data)
                
                DispatchQueue.main.async {
                    self.trueValuesTableView.reloadData()
                    self.optimalValuesTableView.reloadData()
                }
             } catch let error {
               print(error.localizedDescription)
             }
          })

          task.resume()
        
    }
    
    func changeWaterButtonLabel() {
        if(selectedBox.Rega == true){
            navigationItem.rightBarButtonItem?.title = "Close Water"
        }else{
            navigationItem.rightBarButtonItem?.title = "Open Water"
        }
        
    }
    struct responseCreateUser:Codable {
        let status:String
        let list:String??;
        let message:String??;
    }
    struct responseWater:Codable {
        let status:String
        let rega:Bool
    }

}


