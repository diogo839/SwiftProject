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
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
        
        
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
            cell.valueLabel.text = String(selectedBox.Luminosidade) + "C"
        }
        if(indexPath.row == 3){
            cell.mainLabel.text = "Luminosity"
            cell.valueLabel.text = String(selectedBox.Luminosidade)
        }
        
        return cell
    }
    
    func optimalValuesTableView(_ optimalValuesTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func optimalValuesTableView(_ optimalValuesTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optimalValuesTableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
        
        
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
            cell.valueLabel.text = String(selectedBox.Luminosidade) + "C"
        }
        if(indexPath.row == 3){
            cell.mainLabel.text = "Luminosity"
            cell.valueLabel.text = String(selectedBox.Luminosidade)
        }
        
        return cell
    }
    
    
    func optimalValuesTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
    
    var selectedBox:Box = Box.init(Nome: "", Id: "1", Humidade: 0, HumidadeSolo: 0, Luminosidade: 0)
    @IBOutlet weak var BoxnameLable: UILabel!
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var optimalValuesTableView: UITableView!
    @IBOutlet weak var ListButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        print(selectedBox)
        super.viewDidLoad()
        BoxnameLable.text = selectedBox.Nome        
        tableView.delegate = self
        tableView.dataSource = self
        optimalValuesTableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.backBarButtonItem = ListButton
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.navigationController?.navigationBar.isHidden = false

    }

}


