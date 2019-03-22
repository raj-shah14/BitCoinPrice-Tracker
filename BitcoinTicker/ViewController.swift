//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Charts

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let forecast = Forecast()
    var lineChartEntry = [ChartDataEntry]()
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1    //Number of columns in picker
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row:Int, forComponent: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        getBitCoinData(url: finalURL,sym:row)
    }

    

//    
//    //MARK: - Networking
//    /***************************************************************/
//
    let x_axis:[Double:String] = [0.0:"Year",1.0:"6 Months",2.0:"3 Months",3.0:"Month",4.0:"Week",5.0:"Today"]
    
    func getBitCoinData(url: String,sym:Int) {
        let formatTo:Formatter = Formatter()
        let xaxis:XAxis = XAxis()
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
//                    print("Sucess! Got the Bitcoin data")
                    
                    let bitCoinJSON : JSON = JSON(response.result.value!)
                    let val = String(format:"%.2f",bitCoinJSON["last"].double!)
                    self.bitcoinPriceLabel.text = self.currencySymbol[sym]+val
                    //print(bitCoinJSON)
                    
                    
                    self.forecast.year = bitCoinJSON["open"]["year"].double!
                    self.lineChartEntry.append( ChartDataEntry(x: 0.0, y: self.forecast.year))
                    formatTo.stringForValue(0.0, axis: xaxis)
                    
                    self.forecast.month_6 = bitCoinJSON["open"]["month_6"].double!
                    self.lineChartEntry.append( ChartDataEntry(x: 1.0, y: self.forecast.month_6))
                    formatTo.stringForValue(1.0, axis: xaxis)
                    
                    self.forecast.month_3 = bitCoinJSON["open"]["month_3"].double!
                    self.lineChartEntry.append( ChartDataEntry(x: 2.0, y: self.forecast.month_3))
                    formatTo.stringForValue(2.0, axis: xaxis)
                    
                    self.forecast.month = bitCoinJSON["open"]["month"].double!
                    self.lineChartEntry.append( ChartDataEntry(x: 3.0, y: self.forecast.month))
                    formatTo.stringForValue(3.0, axis: xaxis)
                    
                    self.forecast.week = bitCoinJSON["open"]["week"].double!
                    self.lineChartEntry.append( ChartDataEntry(x: 4.0, y: self.forecast.week))
                    formatTo.stringForValue(4.0, axis: xaxis)
                    
                    self.lineChartEntry.append( ChartDataEntry(x: 5.0, y: bitCoinJSON["last"].double!))
                    formatTo.stringForValue(5.0, axis: xaxis)
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }
        
        xaxis.valueFormatter = formatTo
        let linechart = LineChartDataSet(values: lineChartEntry, label: "Amount")
        linechart.colors = [UIColor.blue]
        let data = LineChartData()
        data.addDataSet(linechart)
        lineChartView.data = data
//        lineChartView.xAxis.spaceMin = 0.25
        lineChartView.xAxis.spaceMax = 0.25
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
        lineChartView.xAxis.granularity = 1.0
        lineChartView.xAxis.setLabelCount(6, force: true)
        lineChartView.chartDescription?.text = "Forecast Chart"
        lineChartView.chartDescription?.position = CGPoint(x: 300.0, y: 300.0)
        lineChartView.animate(yAxisDuration: 1.0, easingOption: .easeInOutBack)
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartEntry.removeAll()
        }
    
    
    
    


}

