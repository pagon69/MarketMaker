//
//  MarketViewController.swift
//  MarketMaker
//
//  Created by Andy Alleyne on 12/2/18.
//  Copyright © 2018 AlleyneVentures. All rights reserved.
//

import UIKit

class MarketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTableViewOutlet: UITableView!
    
    let myData = ["test1", "second", "third", "fourth", "fifth", "sixth"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableViewOutlet.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MarketTableViewCell
        
      //  cell.backgroundView?.backgroundColor = UIColor.gray
        cell.shortOutlet.text = myData[indexPath.row]
        cell.longOutlet.text = "text for long data"
        cell.volumeOutlet.text = "12338753487543 "
        cell.changeOutlet.text = "+3.45"
       
        
        cell.changeOutlet.textColor = UIColor.black
        
        cell.changeViewOutlet.backgroundColor = UIColor.green
        cell.changeViewOutlet.alpha = 0.5
        
        return cell
    }
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        myTableViewOutlet.delegate = self
        myTableViewOutlet.dataSource = self
        

    }
    


    

}





class MarketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shortOutlet: UILabel!
    @IBOutlet weak var longOutlet: UILabel!
    @IBOutlet weak var volumeOutlet: UILabel!
    @IBOutlet weak var changeViewOutlet: UIView!
    @IBOutlet weak var changeOutlet: UILabel!
    
    
    
    
}
