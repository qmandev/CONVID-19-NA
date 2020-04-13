//
//  ConvidDataStore.swift
//  CONVID-19-NA
//
//  Created by ARMSTRONG on 3/19/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import Foundation
import Combine

public class Admin2Data : Identifiable {
        
    init(FIPS: String, Admin2: String?, Confirmed: Int, Deaths: Int, Recovered: Int, Active: Int, Latitude: Double, Longitude: Double, Combined_Key: String) {
        
        self.FIPS = FIPS
        self.Admin2 = Admin2
        self.Confirmed = Confirmed
        self.Deaths = Deaths
        self.Recovered = Recovered
        self.Active = Active
        self.Latitude = Latitude
        self.Longitude = Longitude
        self.Combined_Key = Combined_Key
    }
    
    public var id: String {
        return Combined_Key
    }
    public let FIPS: String
    public let Admin2: String?
    public let Confirmed: Int
    public let Deaths: Int
    public let Recovered: Int
    public let Active: Int
    public let Latitude: Double
    public let Longitude: Double
    public let Combined_Key: String
}

public class ConvidData : Identifiable {
    

    
    init(Province_State: String, LastUpdate: Date, Country_Region: String, Admin2Data: [Admin2Data]) {
        self.Province_State = Province_State
        self.LastUpdate = LastUpdate
        self.Country_Region = Country_Region
        self.Admin2DataList = Admin2Data
    }
    
    public var id: String {
        return Province_State
    }
    public let Province_State: String
    public let LastUpdate: Date
    public let Country_Region: String
    public var Admin2DataList: [Admin2Data]

    public var StateCode: String {
        return Helper.app.nameToCode(name: Province_State)
    }
    
    public var Confirmed: Int {
        let total = self.Admin2DataList
            .reduce(0) {
                $0 + $1.Confirmed
            }
        
        return total
    }
    
    public var Deaths: Int {
        let total = self.Admin2DataList
            .reduce(0) {
                $0 + $1.Deaths
            }
        
        return total
    }
    
    public var Recovered: Int {
        let total = self.Admin2DataList
            .reduce(0) {
                $0 + $1.Recovered
            }
        
        return total
    }
    
    public var Active: Int {
        let total = self.Admin2DataList
            .reduce(0) {
                $0 + $1.Active
            }
        
        return total
    }
    
    /*
    func shortStateName(_ state:String) -> String {
        let lowercaseNames = fullStateNamesList.map { $0.lowercased() }
        let dic = NSDictionary(objects: fullStateNamesList, forKeys: lowercaseNames as [NSCopying])
        return dic.object(forKey:state.lowercased()) as? String ?? state}

    func longStateName(_ stateCode:String) -> String {
        let dic = NSDictionary(objects: fullStateNamesList, forKeys:fullStateNamesList as [NSCopying])
        return dic.object(forKey:stateCode) as? String ?? stateCode
    }*/
}


public class NetworkManager : ObservableObject {
    
    public init() {
        self.load()
    }
    
    @Published public var loading: Bool = false {
        didSet {
            if oldValue == false && loading == true {
                self.convidDataDictionary.removeAll()  // clear out when refresh
                self.load()
            }
        }
    }

    @Published public var convidDataDictionary : [String : ConvidData] = [:]
        
    //https://stackoverflow.com/questions/43295163/swift-3-1-how-to-get-array-or-dictionary-from-csv
    //This one fixes the deprecated scanUpTo() in iOS 13
    func parseCSV (contentsOfURL: URL, encoding: String.Encoding) -> [(FIPS:String, Admin2:String, Province_State: String,
        Country_Region: String, Last_Update: String, Lat: String, Long_: String, Confirmed: String, Deaths: String,
        Recovered: String, Active: String, Combined_Key: String)]? {
        
        // Load the CSV file and parse it
        let delimiter = ","
        var items:[(FIPS:String, Admin2:String, Province_State: String,
        Country_Region: String, Last_Update: String, Lat: String, Long_: String, Confirmed: String, Deaths: String,
        Recovered: String, Active: String, Combined_Key: String)]?
        
        do {
            let content = try String(contentsOf: contentsOfURL, encoding: encoding)
            items = []
            let lines: [String] = content.components(separatedBy: .newlines)
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    
                    // To handle the CSV row with the first column been ""
                    if (line.first == delimiter.first) {
                        values.append("Unassigned")
                    }
                    
                    // To handle the CSV row for US recovery with the first and second column been ""
                    // It will add "Unassigned" above
                    if (line.first == delimiter.first && line.contains("Recovered") && line.contains("US")) {
                        values.append("Recovered")
                    }
                    
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.range(of: "\"") != nil {
                        var textToScan:String = line
                        var value:String?
                        var textScanner:Scanner = Scanner(string: textToScan)
                        while !textScanner.isAtEnd {
                            
                            if (textScanner.string as NSString).substring(to: 1) == "\"" {
                                textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
                                value = textScanner.scanUpToString("\"")
                                textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
                            } else {
                                value = textScanner.scanUpToString(delimiter)
                            }
                            
                            // Store the value into the values array
                            if let value = value {
                                values.append(value as String)
                            }
                            
                            // Retrieve the unscanned remainder of the string
                            if !textScanner.isAtEnd {
                                let indexPlusOne = textScanner.string.index(after: textScanner.currentIndex)
                                textToScan = String(textScanner.string[indexPlusOne...])
                            } else {
                                textToScan = ""
                            }
                            textScanner = Scanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the delimiter (e.g. comma)
                    } else  {
                        values = line.components(separatedBy: delimiter)
                    }
                    
                    /*
                    if ( values[0] == "41059") {
                        print( values)
                    }*/

                    // Patch for Diamond Princess, Grand Princess
                    if ( values.count == 9 && values[2] == "US") {
                        values.insert(values[1], at: 1) // insert missing Latitude
                    }
                    
                    // Patch for missing Latitude and Longitude in CSV
                    if ( values.count == 10 && values[3] == "US") {
                        values.insert("0", at: 5) // insert missing Latitude
                        values.insert("1", at: 5) // insert missing Longitude
                    }
                    
                    // Patch for "Guam","Northern Mariana Islands","Puerto Rico","Virgin Islands"
                    if ( values.count == 11 && values[2] == "US") {
                        values.insert("Unassigned", at: 1)
                    }
                    
                    // Put the values into the tuple and add it to the items array
                    if ( values.count == 12 && values[3] == "US") {
                        let item = (FIPS: values[0], Admin2: values[1], Province_State: values[2],
                        Country_Region: values[3], Last_Update: values[4], Lat: values[5], Long_: values[6], Confirmed: values[7], Deaths: values[8],
                        Recovered: values[9], Active: values[10], Combined_Key: values[11])
                        items?.append(item)

                        guard let updateDate = Date.fromString(string: (values[4]),
                                                               with: "yyyy-MM-dd' 'HH:mm:ss") else {
                             print ("At field of DateTime: \(values[4]) didn\'t convert")
                             continue
                         }
                        
                        let amin2 : Admin2Data = Admin2Data(FIPS: values[0], Admin2: values[1], Confirmed: Int(values[7]) ?? 0, Deaths: Int(values[8]) ?? 0, Recovered: Int(values[9]) ?? 0, Active: Int(values[10]) ?? 0, Latitude: Double(values[5]) ?? 0.0, Longitude: Double(values[6]) ?? 0.0, Combined_Key: values[11])
                        
                        var stateCode = Helper.app.nameToCode(name: values[2])
                        
                        if (stateCode == "") {
                            stateCode = "Cruise"
                        }
                        // check if the convidDataDictionary Dictionary is nil
                        if (self.convidDataDictionary[stateCode] != nil ) {
                            // check if he Admin2Data Array is empty
                            self.convidDataDictionary[stateCode]?.Admin2DataList.append(amin2)
                        } else {
                            let convid : ConvidData = ConvidData(Province_State: values[2], LastUpdate: updateDate, Country_Region: values[3], Admin2Data: [amin2])
                            
                            self.convidDataDictionary.updateValue(convid, forKey: stateCode)
                        }
                    }
                }
            }
            
        } catch {
            print(error)
        }
        
        return items
    }
    
    // invoked in Init() and Loading property to refreshScrollView
    func load () {
        // Simulate async task
        DispatchQueue.main.async() {
            
            self.preloadData(checkedDate: Date.today.string(with: "MM-dd-yyyy"))
            
            if (self.convidDataDictionary.count < 1) {
                self.preloadData(checkedDate: Date.yesterday.string(with: "MM-dd-yyyy"))
            }
            
            // reset loading flag
            self.loading = false
        }
    }
    
    func loadBAK () {
        preloadData(checkedDate: Date.today.string(with: "MM-dd-yyyy"))
        
        if (self.convidDataDictionary.count < 1) {
            preloadData(checkedDate: Date.yesterday.string(with: "MM-dd-yyyy"))
        }
        
        // reset loading flag
        self.loading = false
    }
    
    func preloadData(checkedDate :String) {
        
        // Load the data file from a remote URL
        guard let remoteURL = URL(string: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/" + checkedDate + ".csv") else {
            return
        }
        
        // Parse the CSV file and import the data
        if let items = parseCSV(contentsOfURL: remoteURL, encoding: String.Encoding.utf8) {
            print("CSV line count for US data:  \(items.count)")

            // print(items[1])
        }
    }
}
