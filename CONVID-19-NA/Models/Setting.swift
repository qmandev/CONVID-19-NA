//
//  Setting.swift
//  CONVID-19-NA
//
//  Created by ARMSTRONG on 4/5/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import Foundation

final class Setting: ObservableObject {
    
    @Published var defaults: UserDefaults
    
    init(defaults: UserDefaults = UserDefaults(suiteName: "group.com.armstrongsoftwarellc.CONVID-19-NA")!) {
        
        self.defaults = defaults
        
        defaults.register(defaults: ["selectedState" : "", "selectedCounty" : "", "useCurrentLocation" : true, "gpsLocationState" : "", "gpsLocationCounty" : "" ])
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
    
    
    var useCurrentLocation: Bool {
        
        get {
            defaults.bool(forKey: "useCurrentLocation")
        }
        
        set {
            defaults.set(newValue, forKey: "useCurrentLocation")
        }
    }
    
    var gpsLocationState: String {
        
        get {
            defaults.string(forKey: "gpsLocationState") ?? "No State"
        }
        
        set {
            defaults.set(newValue, forKey: "gpsLocationState")
        }
    }
    
    var gpsLocationCounty: String {
        
        get {
            defaults.string(forKey: "gpsLocationCounty") ?? "No County"
        }
        
        set {
            defaults.set(newValue, forKey: "gpsLocationCounty")
        }
    }
}
