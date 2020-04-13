//
//  TodayViewController.swift
//  CONVID-19
//
//  Created by ARMSTRONG on 3/24/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import UIKit
import NotificationCenter
import CONVID_19DataKit

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var confirmedCase: UILabel!
    @IBOutlet weak var deathCase: UILabel!
    
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var countyConfirmedCase: UILabel!
    @IBOutlet weak var countyDeathCase: UILabel!
    
        
    var defaults = UserDefaults(suiteName: "group.com.armstrongsoftwarellc.CONVID-19-NA")!
    
    var networkManager = NetworkManager()
    
    var Province_State: String = ""
    var Admin2: String = ""
    var Province_State_Code: String = ""
    
    private var LastUpdate: String {
        if let theDate = networkManager.convidDataDictionary[Province_State_Code]?.LastUpdate.description(with: Locale.current) {
            return theDate.description
        } else {
            return Date.yesterday.description(with: Locale.current)
       }
    }
    
    private var stateConfirmed: Int {
        return networkManager.convidDataDictionary[Province_State_Code]?.Confirmed ?? 0
    }
    
    private var stateDeaths: Int {
        return networkManager.convidDataDictionary[Province_State_Code]?.Deaths ?? 0
    }
    
    private var stateRecovered: Int {
        return networkManager.convidDataDictionary[Province_State_Code]?.Recovered ?? 0
    }
    
    private var Admin2Confirmed: Int {
        let admin2Data = networkManager.convidDataDictionary[Province_State_Code]?.Admin2DataList
            .filter {
                $0.Admin2 == Admin2
            }
        
        return admin2Data?[0].Confirmed ?? 0
    }
    
    private var Admin2Deaths: Int {
        let admin2Data = networkManager.convidDataDictionary[Province_State_Code]?.Admin2DataList
            .filter {
                $0.Admin2 == Admin2
            }
        
        return admin2Data?[0].Deaths ?? 0
    }
    
    private var Admin2Recovered: Int {
        let admin2Data = networkManager.convidDataDictionary[Province_State_Code]?.Admin2DataList
            .filter {
                $0.Admin2 == Admin2
            }
        
        return admin2Data?[0].Recovered ?? 0
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        /*
        self.stateLabel.text = "New York"
        self.dateLabel.text = Date.today.string(with: "MM-dd-yyyy")
        self.confirmedCase.text = String(self.networkManager.convidDatafeeds[1].Confirmed)
        self.deathCase.text = String(self.networkManager.convidDatafeeds[1].Deaths)
         */
        


        OperationQueue.main.addOperation({ () -> Void in
            
            // Get the location from defaults
            if let selectedState = self.defaults.value(forKey: "selectedState") as? String,
                let selectedCounty = self.defaults.value(forKey: "selectedCounty") as? String,
                let useCurrentLocation = self.defaults.value(forKey: "useCurrentLocation") as? Bool,
                let gpsLocationState = self.defaults.value(forKey: "gpsLocationState") as? String,
                let gpsLocationCounty = self.defaults.value(forKey: "gpsLocationCounty") as? String
            {
                if ( useCurrentLocation == true) {
                    self.Province_State = gpsLocationState
                    self.Admin2 = gpsLocationCounty
                    self.Province_State_Code = Helper.app.nameToCode(name: gpsLocationState)
                } else {
                    self.Province_State = selectedState
                    self.Admin2 = selectedCounty
                    self.Province_State_Code = Helper.app.nameToCode(name: selectedState)
                }
            }
            
            // self.dateLabel.text = Date.today.string(with: "MM-dd-yyyy")
            self.dateLabel.text = "Updated: \(self.LastUpdate)"
            
            self.stateLabel.text = self.Province_State
            self.confirmedCase.text = String(self.stateConfirmed)
            self.deathCase.text = String(self.stateDeaths)
            
            self.countyLabel.text = self.Admin2
            self.countyConfirmedCase.text = String(self.Admin2Confirmed)
            self.countyDeathCase.text = String(self.Admin2Deaths)
        })
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
