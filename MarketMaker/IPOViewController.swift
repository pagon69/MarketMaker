//
//  IPOViewController.swift
//  MarketMaker
//
//  Created by Andy Alleyne on 12/13/18.
//  Copyright © 2018 AlleyneVentures. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import SVProgressHUD




class IPOViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return IPOArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IPOTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        cell.textLabel?.text = "\(IPOArray[indexPath.row].Company)"
        cell.detailTextLabel?.text = "Symbol:\(IPOArray[indexPath.row].symbol)    Price:\(IPOArray[indexPath.row].price)  Expected: \(IPOArray[indexPath.row].expected)"
        
        return cell
    }
    

    
    //var myIPOObject = IPOObject()
    var IPOArray = [IPOObject()]
    let defaultURL = "https://api.iextrading.com/1.0/stock/market/upcoming-ipos"
    let newsURL = "https://api.iextrading.com/1.0/stock/market/news/last/2"
    var counter = 0
    
    
    @IBOutlet weak var newsImage1: UIImageView!
    @IBOutlet weak var newsImage2: UIImageView!
    @IBOutlet weak var newHeadLine1: UILabel!
    @IBOutlet weak var newsTextField1: UITextView!
    @IBOutlet weak var newsHeadLine2: UILabel!
    @IBOutlet weak var newsTextField2: UITextView!
    @IBOutlet weak var IPOTableView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        apiCalls(url: defaultURL)
       
        
        // Do any additional setup after loading the view.
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
        
        IPOTableView.reloadData()
        apiCalls(url: newsURL)
        
        
    }
    
    
     
    func processMarketData(jsonData: JSON) {
        
       //print(jsonData)
        
        
        for eachItem in jsonData["viewData"].arrayValue{
            
            print(eachItem)
            
            let myIPOObject = IPOObject()
            myIPOObject.symbol = eachItem["Symbol"].stringValue
            myIPOObject.amount = eachItem["Amount"].stringValue
            myIPOObject.shares = eachItem["Shares"].stringValue
            myIPOObject.Company = eachItem["Company"].stringValue
            myIPOObject.float = eachItem["Float"].stringValue
            myIPOObject.market = eachItem["Market"].stringValue
            myIPOObject.percent = eachItem["Percent"].stringValue
            myIPOObject.price = eachItem["Price"].stringValue
            myIPOObject.expected = eachItem["Expected"].stringValue
        
            IPOArray.append(myIPOObject)
        }
        
        for newsItem in jsonData.arrayValue{
            newHeadLine1.text = newsItem["headline"].stringValue
            newsTextField1.text = newsItem["summary"].stringValue
            
            
            
        }
        
        
        //marketDataArray.remove(at: 0)
        
        updateUIComponents()
        
    }

   

}
