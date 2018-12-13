//
//  WatchListViewController.swift
//  MarketMaker
//
//  Created by Andy Alleyne on 12/12/18.
//  Copyright © 2018 AlleyneVentures. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import AlamofireImage

class WatchListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    //MARK: tableview setup
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        let cell = myTableview.dequeueReusableCell(withIdentifier: "watchListCell", for: indexPath) as! WatchListCell
        
        
        cell.changeSymbolOutlet.text = "🔽"
        cell.changePercentageOutlet.text = "-3.45"
        cell.companyNameOutlet.text = "Apple Company INC"
        cell.priceOutlet.text = "234.56"
        cell.symbolOutlet.text = "AAPL"
      //  cell.iconOutlet.image =
        */
        
        let cell = myTableview.dequeueReusableCell(withIdentifier: "watchListCell", for: indexPath)
        
        
        
        let test1 = "345.56"
        let test2 = "🔽"
        let test3 = "-3.45"
        let test4 = "AAPL"
        
        cell.detailTextLabel?.text = "\(test4)     $\(test1) \(test2)\(test3)"
        cell.textLabel?.text = "Apple Company inc"
        //cell.imageView?.image = Image(contentsOfFile: "Icon-29@2x.png")
        
    
        
        
        return cell
    }
    
    //MARK: global variables
    
    let userSelection = "aapl"
    let currentWatchList = [String]()
    let watchListSetup = "apl,fb,tsla"
    let defaultURL = "https://api.iextrading.com/1.0/stock/market/batch?symbols="
  //  let test = "\(watchListSetup)&types=quote,news,icon,chart&range=1m&last=5"

    
    @IBOutlet weak var myTableview: UITableView!
    @IBOutlet weak var NewsOutlet: UIView!
    @IBOutlet weak var anotherViewOutlet: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        apiCalls(url: defaultURL)
        test()
        
        
    }
    

    func apiCalls(url: String){
        
        let createURL = "\(watchListSetup)&types=quote,news,icon,chart&range=1m&last=5"
        let finalURL = url + createURL
        
        print(finalURL)
        
        Alamofire.request(finalURL, method: .get) //parameters can be placed after the get
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    let returnedStockData : JSON = JSON(response.result.value!)
                    SVProgressHUD.dismiss()
                   // self.processMarketData(jsonData: returnedStockData)
                   
                    //print(returnedStockData)
                    
                }else{
                    
                    print("somthing went wrong: \(String(describing: response.result.error))")
                    
                }
        }
        
    }
    
    
    func updateUIComponents() {
        
        myTableview.reloadData()
        
    }
    
    /*
    func processMarketData(jsonData: JSON) {
        
        for eachItem in jsonData.arrayValue{
            
            print(eachItem)
            
            let myMarketData = MarketData()
            myMarketData.venueName = eachItem["venueName"].stringValue
            myMarketData.symbolName = eachItem["mic"].stringValue
            myMarketData.volume = eachItem["volume"].stringValue
            
            marketDataArray.append(myMarketData)
        }
        
        marketDataArray.remove(at: 0)
        updateUIComponents()
        
    }
 */
    
    func test() {
        
        Alamofire.request("http://storage.googleapis.com/iex/api/logos/FB.png").responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                self.anotherViewOutlet.image = image
                print("image downloaded: \(image)")
            }
        }
        
    }
    
    
    
    func updateImage() -> UIImage{
        let url = "http://storage.googleapis.com/iex/api/logos/FB.png"
        let test = "https://httpbin.org/image/png"
        var returnedImage = UIImage(contentsOfFile: "Icon-29@2x.png")
        
        Alamofire.request(test).responseImage { response in
            debugPrint(response)
            
           print(response.request)
           print(response.response)
           debugPrint(response.result)
            
            print("things are working")
            
            if let image = response.result.value{
               print("image downloaded: \(image)")
                returnedImage = image
               // self.iconImageView.image = image
                
                
                print("image downloaded: \(image)")
            }
        }
        
        return returnedImage!
       
    }
 
   
    
}






//MARK: custom cell building

class WatchListCell: UITableViewCell {
    
    @IBOutlet weak var iconOutlet: UIImageView!
    @IBOutlet weak var companyNameOutlet: UILabel!
    @IBOutlet weak var symbolOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var changeSymbolOutlet: UILabel!
    @IBOutlet weak var changePercentageOutlet: UILabel!
    
    
    
    func test() {
        
        Alamofire.request("http://storage.googleapis.com/iex/api/logos/FB.png").responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                self.iconOutlet.image = image
                print("image downloaded: \(image)")
            }
        }
        
    }
    
}
