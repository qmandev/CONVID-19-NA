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
    
    var networkManager = NetworkManager()
    
    let Province_State = "Massachusetts"
    let Admin2 = "Middlesex"
    
    private var confirmed: Int {
        let admin2Data = networkManager.convidDataDictionary[Province_State]?.Admin2DataList
            .filter {
                $0.Admin2 == Admin2
            }
        
        return admin2Data?[0].Confirmed ?? 0
    }
    
    private var deaths: Int {
        let admin2Data = networkManager.convidDataDictionary[Province_State]?.Admin2DataList
            .filter {
                $0.Admin2 == Admin2
            }
        
        return admin2Data?[0].Deaths ?? 0
    }
    
    private var recovered: Int {
        let admin2Data = networkManager.convidDataDictionary[Province_State]?.Admin2DataList
            .filter {
                $0.Admin2 == Admin2
            }
        
        return admin2Data?[0].Recovered ?? 0
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.stateLabel.text = Admin2
        self.dateLabel.text = Date.today.string(with: "MM-dd-yyyy")
        self.confirmedCase.text = String(confirmed)
        self.deathCase.text = String(deaths)
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
            self.stateLabel.text = self.Admin2
            self.dateLabel.text = Date.today.string(with: "MM-dd-yyyy")
            self.confirmedCase.text = String(self.confirmed)
            self.deathCase.text = String(self.deaths)
        })
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
