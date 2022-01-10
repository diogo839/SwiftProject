//
//  HistoryViewController.swift
//  Projeto
//
//  Created by Eduarda Ramos on 10/01/2022.
//

import UIKit


class HistoryViewController: UIViewController {
    var selectedBox:Box = Box.init(Nome: "", Id: "1", Humidade: 0, HumidadeSolo: 0, Luminosidade: 0, Temperatura: 0, HumidadeIdeal: 0, HumidadeSoloIdeal: 0, LuminosidadeIdeal: 0, TemperaturaIdeal: 0, Rega: (0 != 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetHistory()
        // Do any additional setup after loading the view.
    }
    
    private func GetHistory(){
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
                    //self.trueValuesTableView.reloadData()
                    //self.optimalValuesTableView.reloadData()
                }
             } catch let error {
               print(error.localizedDescription)
             }
          })

          task.resume()
        
    }

}
