//
//  ViewController.swift
//  not rich
//
//  Created by ADG RIT 3 on 31/03/19.
//  Copyright © 2019 ADG RIT 3. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController,ChartDelegate{
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
       //
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        //
    }
    
    func didEndTouchingChart(_ chart: Chart) {
       //
    }
    

    @IBOutlet weak var chartA: Chart!
    @IBOutlet weak var segmentA: UISegmentedControl!
    @IBOutlet weak var labelA: UILabel!
    @IBAction func buttonA(_ sender: Any) {
        getPrice()
    }
    
    
    var arrayUSD: [Double] = [4000.00]
    var arrayINR: [Double] = [200000.00]
    
    
    struct Prices: Decodable{
        let bpi: [String: Bpi]
    }
    
    struct Bpi: Decodable{
        let code: String?
        let rate_float: Double?
    }
    
    
    func updateChart(usdValue: Double, priceArray: inout [Double]){
        if priceArray.count > 20{
            priceArray.remove(at: 0)
        }
        priceArray.append(usdValue)
        let series = ChartSeries(priceArray)
        chartA.removeAllSeries()
        chartA.add(series)
        
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPrice()
        chartA.delegate = self
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(getPrice), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func getPrice(){
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/INR.json")
        URLSession.shared.dataTask(with: url!){ data, response, error  in
            if error != nil{
                print(error!.localizedDescription)
            }
            
            if let data = data{
                let price = try? JSONDecoder().decode(Prices.self, from: data)
                let bpi = price?.bpi
                //let code = bpi!["USD"]!.code
                let rateUSD = bpi!["USD"]!.rate_float!
                let rateINR = bpi!["INR"]!.rate_float!
                DispatchQueue.main.async {
                    if self.segmentA.selectedSegmentIndex == 0{
                        self.labelA.text = "\(rateUSD)"
                        self.updateChart(usdValue: rateUSD, priceArray: &self.arrayUSD)
                    }
                    else{
                        self.labelA.text = "\(rateINR)"
                        self.updateChart(usdValue: rateINR, priceArray: &self.arrayINR)
                    }
                }
            }
        }.resume()
    }

}

