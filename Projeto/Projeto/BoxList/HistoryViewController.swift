//
//  HistoryViewController.swift
//  Projeto
//
//  Created by Eduarda Ramos on 10/01/2022.
//

import UIKit
import Charts

struct DadosBox: Decodable{
    let BoxId:String
    let Humidade:Float
    let HumidadeSolo:Float
    let Luminosidade:Float
    let Temperatura:Float
    var Rega:Bool
    let Data:String
}
class HistoryViewController: UIViewController, ChartViewDelegate {
    var selectedBox:Box = Box.init(Nome: "", Id: "1", Humidade: 0, HumidadeSolo: 0, Luminosidade: 0, Temperatura: 0, HumidadeIdeal: 0, HumidadeSoloIdeal: 0, LuminosidadeIdeal: 0, TemperaturaIdeal: 0, Rega: (0 != 0), updatedAt: "")
    
    var barChart = BarChartView()
    var boxes = [DadosBox]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetHistory()
        barChart.delegate = self
        print(selectedBox.Id)
        // Do any additional setup after loading the view.
    }
    
    private func GetHistory(){
        guard let ConUrl = URL(string: url + "/api/GetBox/history/" + selectedBox.Id) else { return}
        
        
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
                self.boxes = try JSONDecoder().decode([DadosBox].self, from: data)
                
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        barChart.center = view.center
        view.addSubview(barChart)
        var entries = [BarChartDataEntry]()
        
        /*for dado in boxes{
            entries.append(BarChartDataEntry(x: dado.Temperatura, y: dado.Data))
            
        }*/
        for x in 0..<10 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = BarChartDataSet(entries: entries)
        let data = BarChartData(dataSet: set)
        barChart.data = data
    }
    
    
    struct response:Codable {
        let status:String
        let list:String??;
        let message:String??;
        
    }

}
