//
//  MarketViewController.swift
//  MarketMaker
//
//  Created by Andy Alleyne on 12/2/18.
//  Copyright © 2018 AlleyneVentures. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SVProgressHUD
import GoogleMobileAds


class MarketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: my outlets
    @IBOutlet weak var myTableViewOutlet: UITableView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    //MARK: my global variables
    let myData = ["test1", "second", "third", "fourth", "fifth", "sixth"]
   
    var marketURL = "https://api.iextrading.com/1.0/market"
    
    var marketDataItem = MarketData()
    var marketDataArray = [MarketData()]
    
    //MARK: MY TABLE VIEW methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marketDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableViewOutlet.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        
        cell.detailTextLabel?.text = "Symbol:\(marketDataArray[indexPath.row].symbolName)  Vol:\(marketDataArray[indexPath.row].volume)  Chg: +3.4"
        cell.textLabel?.text =  "\(marketDataArray[indexPath.row].venueName)"
        
        
      //  cell.backgroundView?.backgroundColor = UIColor.gray
       // cell.shortOutlet.text = marketDataArray[indexPath.row].symbolName
        //cell.longOutlet.text = marketDataArray[indexPath.row].venueName
        //cell.volumeOutlet.text = marketDataArray[indexPath.row].volume
        //cell.changeOutlet.text = "+3.45"
       
        
        //cell.changeOutlet.textColor = UIColor.black
        
       // cell.changeViewOutlet.backgroundColor = UIColor.green
        //cell.changeViewOutlet.alpha = 0.5
        
      
        
        return cell
    }
    
    //use to do things to the selected Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //used to indicate which cell was selected
      //  print(indexPath.row)
      //  print(marketDataArray[indexPath.row].symbolName)
        
        //use the below to get details on a market stock?
       // tableView.cellForRow(at: indexPath)?.accessoryType = .detailDisclosureButton
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .detailDisclosureButton {
              tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
              tableView.cellForRow(at: indexPath)?.accessoryType = .detailDisclosureButton
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        myTableViewOutlet.delegate = self
        myTableViewOutlet.dataSource = self
        
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        SVProgressHUD.show()
        
        apiCalls(url: marketURL)
        

    }
    
    
    
    
    
    
    
    func apiCalls(url: String){
        
        Alamofire.request(url, method: .get) //parameters can be placed after the get
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    let returnedStockData : JSON = JSON(response.result.value!)
                    SVProgressHUD.dismiss()
                    self.processMarketData(jsonData: returnedStockData)
                    
                }else{
                    
                    print("somthing went wrong: \(String(describing: response.result.error))")
                    
                }
        }
        
    }
    
    
    func updateUIComponents() {
        
        myTableViewOutlet.reloadData()
        
    }
    

    func processMarketData(jsonData: JSON) {
        
        for eachItem in jsonData.arrayValue{
            
          //  print(eachItem)
            
            let myMarketData = MarketData()
            myMarketData.venueName = eachItem["venueName"].stringValue
            myMarketData.symbolName = eachItem["mic"].stringValue
            myMarketData.volume = eachItem["volume"].stringValue
            
            marketDataArray.append(myMarketData)
        }
        
        marketDataArray.remove(at: 0)
        updateUIComponents()
        
    }
    

}





class MarketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shortOutlet: UILabel!
    @IBOutlet weak var longOutlet: UILabel!
    @IBOutlet weak var volumeOutlet: UILabel!
    @IBOutlet weak var changeViewOutlet: UIView!
    @IBOutlet weak var changeOutlet: UILabel!
    
    
    
    
}
