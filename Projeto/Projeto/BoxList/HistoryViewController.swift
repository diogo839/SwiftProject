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

class HistoryViewController: UIViewController, ChartViewDelegate, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return labels[Int(value)]
    }
    
    var selectedBox:Box = Box.init(Nome: "", Id: "1", Humidade: 0, HumidadeSolo: 0, Luminosidade: 0, Temperatura: 0, HumidadeIdeal: 0, HumidadeSoloIdeal: 0, LuminosidadeIdeal: 0, TemperaturaIdeal: 0, Rega: (0 != 0), updatedAt: "")
    
    //var barChart = LineChartView()
    
    var finalValues = [ChartDataEntry]()
    var boxes = [DadosBox]()
    var months: [String]!
    var unitsSold = [Double]()
    var valores = [Double]()
    var labels = [String]()
    weak var axisFormatDelegate: IAxisValueFormatter?

   @IBOutlet var viewForChart: BarChartView!
    var barChart = BarChartView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        GetHistory()
        prepareData()
        print(valores)
        print(labels)
        axisFormatDelegate = self
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]

        // setChart(_ dataPoints:months,_ forY: unitsSold)
        setChart(dataPoints: labels, values: valores)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        barChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width-100, height: self.view.frame.size.height-300)
        barChart.center = view.center
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        barChart.xAxis.granularity = 1
        view.addSubview(barChart)
    }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }

       
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []

        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y:values[i], data: labels )
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Units Sold")

        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        barChart.data = chartData
    }
    
    
    func convertDateFormat(inputDate: String) -> String {
        let fullNameArr = inputDate.components(separatedBy: ".")
        var firstName: String = fullNameArr[0]
        
         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

         let oldDate = olDateFormatter.date(from: firstName)
        

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "dd MMM yyyy h:mm a"

         return convertDateFormatter.string(from: oldDate!)
    }
    func prepareData(){
        for dado in boxes {
            valores.append(Double(dado.Humidade))
            print(Double(dado.Humidade))
            labels.append(convertDateFormat(inputDate: dado.Data))
            print(convertDateFormat(inputDate: dado.Data))

        }
        
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
                    self.prepareData()
                }
             } catch let error {
               print(error.localizedDescription)
             }
          })

          task.resume()
        
    }
    
    struct response:Codable {
        let status:String
        let list:String??;
        let message:String??;
        
    }
    
}

