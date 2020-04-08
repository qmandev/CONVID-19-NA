//
//  Setting.swift
//  CONVID-19-NA
//
//  Created by ARMSTRONG on 4/5/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import Foundation

final class Setting: ObservableObject {
    
    init(selectedState: String?, selectedCounty: String?, useCurrentLocation:Bool) {
        self.selectedState = selectedState
        self.selectedCounty = selectedCounty
        self.useCurrentLocation = useCurrentLocation
    }
    
    @Published var selectedState: String?
    @Published var selectedCounty: String?
    @Published var useCurrentLocation = false
}
