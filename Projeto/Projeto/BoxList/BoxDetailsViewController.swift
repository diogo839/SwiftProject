//
//  BoxDetailsViewController.swift
//  Projeto
//
//  Created by Eduarda Ramos on 13/12/2021.
//

import UIKit
import Foundation


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
  
    
    func openWaterValve(_ sender: Any) {
        guard let ConUrl = URL(string: url + "/api/changeWaterValve") else { return}
        
        var request=URLRequest(url: ConUrl )
        request.httpMethod = "PUT"
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
                                
                                                  }))

                            self.present(refreshAlert, animated: true, completion: nil)
                        }else{
                            self.selectedBox.Rega = true
                            let refreshAlert = UIAlertController(title: "Water Opened", message: "Water flow opened successfully.", preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                
                                                  }))

                            self.present(refreshAlert, animated: true, completion: nil)
                        }
                        self.labelManualSwitch(isOn: self.selectedBox.Rega)
                        self.refresh(self)
                    }
                    
                }else{
                    
                    DispatchQueue.main.async {
                       
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
            if indexPath.row == 1 {
                performSegue(withIdentifier: "historySegue", sender: self)
            }
            tableView.deselectRow(at: indexPath, animated: false)
            break
            
        default:
            print("you tapped me!")

        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editValuesSegue" {
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
        if segue.identifier == "historySegue" {
            guard let changeValuesVC = segue.destination as? HistoryViewController else {return}
            changeValuesVC.selectedBox = selectedBox
        }
    }
    
    var selectedBox:Box = Box.init(Nome: "", Id: "1", Humidade: 0, HumidadeSolo: 0, Luminosidade: 0, Temperatura: 0, HumidadeIdeal: 0, HumidadeSoloIdeal: 0, LuminosidadeIdeal: 0, TemperaturaIdeal: 0, Rega: (0 != 0), updatedAt: "", manualMode: false)
    
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
    @IBOutlet weak var autoWateringSwitch: UISwitch!
    @IBOutlet weak var manualWateringSwitch: UISwitch!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var autoWateringLabel: UILabel!
    @IBOutlet weak var manualWateringLabel: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var viewOptions: UIView!
    @IBOutlet weak var viewOptimalValues: UIView!
    @IBOutlet weak var viewTrueValues: UIView!
    @IBOutlet weak var viewOtherOptions: UIView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelAutomaticSwitch(isOn: selectedBox.manualMode)
        labelManualSwitch(isOn: selectedBox.Rega)
        BoxnameLable.text = selectedBox.Nome
        updatedAtLabel.text = "Last update: " + convertDateFormat(inputDate: selectedBox.updatedAt)
        trueValuesTableView.delegate = self
        trueValuesTableView.dataSource = self
        optimalValuesTableView.delegate = self
        optimalValuesTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = false
        RoundCorners()

        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           mainScrollView.addSubview(refreshControl) // not required when using UITableViewController
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue:  "RefreshBoxDetails"), object: nil)
    }
    
    func RoundCorners(){
        viewOptions.layer.cornerRadius = 10
        viewTrueValues.layer.cornerRadius = 10
        trueValuesTableView.layer.cornerRadius = 10
        viewOtherOptions.layer.cornerRadius = 10
        optimalValuesTableView.layer.cornerRadius = 10
        viewOptimalValues.layer.cornerRadius = 10
        settingsTableView.layer.cornerRadius = 10
        settingsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
        optimalValuesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
        trueValuesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
    }
    
    @IBAction func WateringSwitch(_ sender: Any) {
        
        labelAutomaticSwitch(isOn: autoWateringSwitch.isOn)
        ChangeButtonMode( BoxId: selectedBox.Id)
        
    }
    @IBAction func IrrigationSwitch(_ sender: Any) {
        labelManualSwitch(isOn: manualWateringSwitch.isOn)
        openWaterValve(self)
    }
    
    func labelAutomaticSwitch(isOn: Bool) {
        if(isOn == true){
            autoWateringLabel.text = "Auto watering ON"
            autoWateringSwitch.isOn = true
        }else{
            autoWateringLabel.text = "Auto watering OFF"
            autoWateringSwitch.isOn = false

        }
    }
    func labelManualSwitch(isOn: Bool) {
        if(isOn == true){
            manualWateringLabel.text = "Stop box irrigation"
            manualWateringSwitch.isOn = true
        }else{
            manualWateringLabel.text = "Start box irrigation"
            manualWateringSwitch.isOn = false

        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.navigationController?.navigationBar.isHidden = false

    }

    func convertDateFormat(inputDate: String) -> String {
        let fullNameArr = inputDate.components(separatedBy: ".")
        let firstName: String = fullNameArr[0]
        
         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

         let oldDate = olDateFormatter.date(from: firstName)
         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "dd MMM yyyy h:mm a"
         return convertDateFormatter.string(from: oldDate!)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        GetBoxData()
        NavigationBar.title = selectedBox.Nome
        BoxnameLable.text = selectedBox.Nome
        updatedAtLabel.text = "Last update: " + convertDateFormat(inputDate: selectedBox.updatedAt)
        

        labelAutomaticSwitch(isOn: selectedBox.manualMode)
        
        		
        refreshControl.endRefreshing()
        
    }
    private func ChangeButtonMode(BoxId:String){
        guard let ConUrl = URL(string: url + "/api/changeMode") else { return}
        
        var request=URLRequest(url: ConUrl )
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.string(forKey: "token")
        request.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
        
        let body: [String: AnyHashable]=[
            "id":BoxId,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data,_,error in guard let data = data , error == nil else {
                return
            }
            do{
                let responsePostRequest = try JSONDecoder().decode(responseCreateUser.self, from: data)
                NSLog(responsePostRequest.status)
                print(responsePostRequest)
                if responsePostRequest.status == "success"{
                    DispatchQueue.main.async {
                        self.GetBoxData()
                    }
                }else{
                    DispatchQueue.main.async {
                        
                    }
                }
            }catch{
                print(error)
            }
        }
        task.resume()
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
                    labelAutomaticSwitch(isOn: selectedBox.manualMode)
                    labelManualSwitch(isOn: selectedBox.Rega)
                }
             } catch let error {
               print(error.localizedDescription)
             }
          })

          task.resume()
        
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


