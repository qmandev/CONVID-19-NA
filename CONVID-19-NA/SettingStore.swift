//
//  SettingStore.swift
//  CONVID-19-NA
//
//  Created by ARMSTRONG on 4/3/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import Foundation
import Combine

final class SettingStore: ObservableObject {
    
    var defaults: UserDefaults
    
    init(defaults: UserDefaults = UserDefaults(suiteName: "group.com.armstrongsoftwarellc.CONVID-19-NA")!) {
        
        self.defaults = defaults
        
        defaults.register(defaults: ["selectedState" : "", "selectedCounty" : "", "useCurrentLocation" : false ])
    }
    
    var useCurrentLocation: Bool {
        
        get {
            defaults.bool(forKey: "useCurrentLocation")
        }
        
        set {
            defaults.set(newValue, forKey: "useCurrentLocation")
        }
    }
    
    var selectedState: String {
        
        get {
            defaults.string(forKey: "selectedState") ?? "No State"
        }
        
        set {
            defaults.set(newValue, forKey: "selectedState")
        }
    }
    
    var selectedCounty: String {
        
        get {
            defaults.string(forKey: "selectedCounty") ?? "No County"
        }
        
        set {
            defaults.set(newValue, forKey: "selectedCounty")
        }
    }


}
