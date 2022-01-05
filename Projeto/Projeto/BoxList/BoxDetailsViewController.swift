//
//  BoxDetailsViewController.swift
//  Projeto
//
//  Created by Eduarda Ramos on 13/12/2021.
//

import UIKit

class BoxDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case trueValuesTableView:
            print("Entrou 1")
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
            print("Entrou aqui")
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
        default:
            let cell = optimalValuesTableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
        
            
            return cell
        }
    }
    
    func optimalValuesTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case trueValuesTableView:
            return 4
        case optimalValuesTableView:
            return 4
        default:
            return 4
        }
        
        
        
    }
    
    
    func optimalValuesTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
    
    var selectedBox:Box = Box.init(Nome: "", Id: "1", Humidade: 0, HumidadeSolo: 0, Luminosidade: 0, Temperatura: 0, HumidadeIdeal: 0, HumidadeSoloIdeal: 0, LuminosidadeIdeal: 0, TemperaturaIdeal: 0)
    @IBOutlet weak var BoxnameLable: UILabel!
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var trueValuesTableView: UITableView!
    @IBOutlet weak var optimalValuesTableView: UITableView!
    @IBOutlet weak var ListButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        print(selectedBox)
        super.viewDidLoad()
        BoxnameLable.text = selectedBox.Nome        
        trueValuesTableView.delegate = self
        trueValuesTableView.dataSource = self
        optimalValuesTableView.delegate = self
        optimalValuesTableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.backBarButtonItem = ListButton
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.navigationController?.navigationBar.isHidden = false

    }

}


