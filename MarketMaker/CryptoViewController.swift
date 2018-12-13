//
//  CryptoViewController.swift
//  MarketMaker
//
//  Created by Andy Alleyne on 12/11/18.
//  Copyright © 2018 AlleyneVentures. All rights reserved.
//

import UIKit
import SwiftyJSON
import ScrollableGraphView
import Alamofire
import SVProgressHUD

class CryptoViewController: UIViewController, ScrollableGraphViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: set up my pickerview
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfCrypto.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        currentRow = row
        updateUIComponents()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return listOfCrypto[row].Name
        
    }
    
    
    //MARK: graph view setup
    
    var linePlotData = [Int]()
    var numberOfDataPointsInGraph = 18
    var pointIndex = 1
    var xCoorData = [String]()
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch (plot.identifier) {
        case "line":
            return Double(linePlotData[pointIndex])
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "\(xCoorData)"
    }
    
    func numberOfPoints() -> Int {
        return xCoorData.count
    }
    
    //MARK: global variables
    
    var cryptoItems = CryptoData()
    var listOfCrypto = [CryptoData()]
    let APIURL = "https://api.iextrading.com/1.0/stock/market/crypto"
    var currentRow = 0
    
    
    @IBOutlet weak var symbolOutlet: UILabel!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var changeOutlet: UILabel!
    
    @IBOutlet weak var pickerViewOutlet: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        apiCalls(url: APIURL)
        
        
        
        
        
    }
    
    
    
    
    
    
    
    //MARK: create the graph and add to view

    func createGraphs(dataToPlot : [Int], numberOfPointsToPlot : Int, jsonData : JSON) {
        let graphView = ScrollableGraphView(frame: CGRect(x: 17, y: 300, width: 350, height: 350), dataSource: self)
        let linePlot = LinePlot(identifier: "line")
        let referenceLines = ReferenceLines()
        
        
        graphView.addPlot(plot: linePlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        //custom settings
        graphView.shouldAdaptRange = true
        graphView.shouldAnimateOnStartup = true
        graphView.backgroundFillColor = UIColor.gray
        
        linePlot.lineWidth = 1
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        
        //look for rbg information from hex
        
        // linePlot.fillGradientStartColor = UIColor.#colorLiteral(red: 0.286239475, green: 0.2862946987, blue: 0.2862360179, alpha: 1)
        // linePlot.fillGradientEndColor = UIColor.#colorLiteral(red: 0.1960526407, green: 0.1960932612, blue: 0.1960500479, alpha: 1)
        
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        
        // print(jsonData)
        
        
        //edit Json for chart data
        
        for eachItem in jsonData["chart"].arrayValue{
            
            print(eachItem["label"].stringValue)
            print(eachItem["close"].stringValue)
            
            xCoorData.append(eachItem["label"].stringValue)
            linePlotData.append(eachItem["close"].int!)
            
            
        }
        
        view.addSubview(graphView)
    }

    func apiCalls(url: String){
        
        Alamofire.request(url, method: .get) //parameters can be placed after the get
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    let returnedStockData : JSON = JSON(response.result.value!)
                    SVProgressHUD.dismiss()
                    
                   // print(returnedStockData)
                    
                    self.processMarketData(jsonData: returnedStockData)
                    
                }else{
                    
                    print("somthing went wrong: \(String(describing: response.result.error))")
                    
                }
        }
        
    }
    
    func processMarketData(jsonData: JSON) {
        
        for eachItem in jsonData.arrayValue{
            
            let myMarketData = CryptoData()
            myMarketData.Name = eachItem["companyName"].stringValue
            myMarketData.symbol = eachItem["symbol"].stringValue
            myMarketData.price = eachItem["askPrice"].stringValue
            myMarketData.change = eachItem["change"].stringValue
                
            listOfCrypto.append(myMarketData)
        }
        
       // marketDataArray.remove(at: 0)
        updateUIComponents()
        
    }
    
    
    
    
    func updateUIComponents() {
        
        
        priceOutlet.text = listOfCrypto[currentRow].price
        symbolOutlet.text = listOfCrypto[currentRow].symbol
        nameOutlet.text = listOfCrypto[currentRow].Name
        changeOutlet.text = listOfCrypto[currentRow].change
        
        pickerViewOutlet.reloadAllComponents()
    }
    
}
