//
//  Helper.swift
//  CONVID-19DataKit
//
//  Created by ARMSTRONG on 4/8/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import Foundation

public class Helper {
    
    public static var app: Helper = {
        return Helper()
    }()
    
    // Mark: convert administrative area return the full name instead of the abbreviated state code
    // https://stackoverflow.com/questions/31158998/clgeocoder-us-state-names-are-coming-as-a-short-codes
    public var stateCodeList = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY", "AS", "GU", "MP", "PR", "VI"]
    
    public var fullStateNamesList = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming", "American Samoa","Guam","Northern Mariana Islands","Puerto Rico","Virgin Islands"]
    
    var dictionaryStateCodeToName: [String: String]
    var dictionaryStateNameToCode: [String: String]
    
    init() {
        self.dictionaryStateCodeToName = Dictionary(uniqueKeysWithValues: zip(self.stateCodeList, self.fullStateNamesList))
        self.dictionaryStateNameToCode = Dictionary(uniqueKeysWithValues: zip(self.fullStateNamesList, self.stateCodeList))
    }
    
    public func codeToName(code: String) -> String {
        return self.dictionaryStateCodeToName[code] ?? ""
    }
    
    public func nameToCode(name: String) -> String {
        return self.dictionaryStateNameToCode[name] ?? ""
    }
}
