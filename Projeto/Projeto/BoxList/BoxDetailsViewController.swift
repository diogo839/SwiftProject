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
  
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
        case optimalValuesTableView:
            if indexPath.row == 0 {
                selectedRow = "H"
                selectedRowLabel = "Optimal Air Humidity"
                selectedRowValue = String(selectedBox.HumidadeIdeal)
                performSegue(withIdentifier: "editValuesSegue", sender: self)
            }
            if indexPath.row == 1 {
                selectedRow = "S"
                selectedRowLabel = "Optimal Soil Moisture"
                selectedRowValue = String(selectedBox.HumidadeSoloIdeal)
                performSegue(withIdentifier: "editValuesSegue", sender: self)
            }
            if indexPath.row == 2 {
                selectedRow = "T"
                selectedRowLabel = "Optimal Temperature"
                selectedRowValue = String(selectedBox.TemperaturaIdeal)
                performSegue(withIdentifier: "editValuesSegue", sender: self)
            }
            if indexPath.row == 3 {
                selectedRow = "L"
                selectedRowLabel = "Optimal Luminosity"
                selectedRowValue = String(selectedBox.LuminosidadeIdeal)
                performSegue(withIdentifier: "editValuesSegue", sender: self)
                
            }
            tableView.deselectRow(at: indexPath, animated: false) 
        default:
            print("you tapped me!")

        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let changeValuesVC = segue.destination as? ChangeValuesViewController else {return}
        if(selectedRow == "H"){
            changeValuesVC.isNumeric = true
        }
        changeValuesVC.topLabelText = "Changing " + selectedRowLabel
        changeValuesVC.textfieldText = selectedRowValue
        
       
    }
    
    var selectedBox:Box = Box.init(Nome: "", Id: "1", Humidade: 0, HumidadeSolo: 0, Luminosidade: 0, Temperatura: 0, HumidadeIdeal: 0, HumidadeSoloIdeal: 0, LuminosidadeIdeal: 0, TemperaturaIdeal: 0)
    
    var selectedRowValue = ""
    var selectedRowLabel = ""
    var selectedRow = ""
    
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
        print(selectedBox)
        super.viewDidLoad()
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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.navigationController?.navigationBar.isHidden = false

    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        print("Refresh")
        Post()
    }
    
    func atualizarDados(){
        
    }
    private func Post(){
        guard let ConUrl = URL(string: url + "/api/GetBox/details/" + selectedBox.Id) else { return}
        
        
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
                }
             } catch let error {
               print(error.localizedDescription)
             }
          })

          task.resume()
        
    }

}


