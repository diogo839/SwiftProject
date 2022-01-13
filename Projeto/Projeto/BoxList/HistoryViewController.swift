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

class HistoryViewController: UIViewController, ChartViewDelegate, IAxisValueFormatter, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            //Temperature
            setChart(dataPoints: labels, values: dadosTemperatura)
        }
        if row == 1 {
            //Humidity
            setChart(dataPoints: labels, values: dadosHumidade)
        }
        if row == 2 {
            //Luminosity
            setChart(dataPoints: labels, values: dadosLuminosidade)
        }
        if row == 3 {
            //Soil Moisture
            setChart(dataPoints: labels, values: dadosHumidadeSolo)
        }
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return labels[Int(value)]
    }
    
    
    var selectedBox:Box = Box.init(Nome: "", Id: "1", Humidade: 0, HumidadeSolo: 0, Luminosidade: 0, Temperatura: 0, HumidadeIdeal: 0, HumidadeSoloIdeal: 0, LuminosidadeIdeal: 0, TemperaturaIdeal: 0, Rega: (0 != 0), updatedAt: "", manualMode: false)
    
    //var barChart = LineChartView()
    
    var finalValues = [ChartDataEntry]()
    var boxes = [DadosBox]()
    var months: [String]!
    var unitsSold = [Double]()
    var valores = [Double]()
    var labels = [String]()
    var dadosHumidade = [Double]()
    var dadosTemperatura = [Double]()
    var dadosHumidadeSolo = [Double]()
    var dadosLuminosidade = [Double]()
    var pickerData = [String]()
    @IBOutlet weak var dataPicker: UIPickerView!
    @IBOutlet weak var viewForChart: UIView!
    weak var axisFormatDelegate: IAxisValueFormatter?

    var barChart = BarChartView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["Temperature", "Humidity", "Luminosity", "Soil Moisture"]
        self.dataPicker.delegate = self
        self.dataPicker.dataSource = self
        GetHistory()
        axisFormatDelegate = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        barChart.frame = CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: self.view.frame.size.height - 300)
        //barChart.center = view.center
        //barChart.center = viewForChart.center
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        barChart.xAxis.granularity = 1
        viewForChart.addSubview(barChart)
    
        //view.addSubview(barChart)
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

        let chartDataSet = BarChartDataSet(entries: dataEntries)

        let chartData = BarChartData()
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
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
            dadosHumidade.append(Double(dado.Humidade))
            dadosTemperatura.append(Double(dado.Temperatura))
            dadosLuminosidade.append(Double(dado.Luminosidade))
            dadosHumidadeSolo.append(Double(dado.HumidadeSolo))
            print(Double(dado.Humidade))
            labels.append(convertDateFormat(inputDate: dado.Data))
            print(convertDateFormat(inputDate: dado.Data))

        }
        setChart(dataPoints: labels, values: dadosTemperatura)
    }
    
    private func GetHistory(){
        guard let ConUrl = URL(string: url + "/api/GetBoxHistory/" + selectedBox.Id + "/5") else { return}
        print(ConUrl)
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

