//
//  SettingView.swift
//  CONVID-19-NA
//
//  Created by ARMSTRONG on 4/3/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var settings: Setting
    
    var settingStore: SettingStore
    
    var StatesList = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","American Samoa","Guam","Northern Mariana Islands","Puerto Rico","Virgin Islands"]
    
    var CountyList = ["Middlesex", "Barnstablen", "Bristol"]
    
    @State private var selectedOrder = 0
    
    @State private var useCurrentLocation = false
    @State private var selectedStateIndex = 0
    @State private var selectedCountyIndex = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("STATE")) {
                    Picker(selection: $selectedStateIndex, label: Text("Chooes State")) {
                        ForEach(0 ..< StatesList.count, id: \.self) {
                            Text(self.StatesList[$0])
                        }
                    }
                }
                
                Section(header: Text("COUNTY")) {
                Picker(selection: $selectedCountyIndex, label: Text("Choose County")) {
                    ForEach(0 ..< CountyList.count, id: \.self) {
                        Text(self.CountyList[$0])
                        }
                    }
                }
                
                Section(header: Text("LOCATION PREFERENCE")) {
                    Toggle(isOn: $useCurrentLocation) {
                        Text("Use Phone Location")
                    }

                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.black)
                })
                , trailing:
                
                Button(action: {
                    self.settingStore.selectedState = self.StatesList[self.selectedStateIndex]
                    self.settingStore.selectedCounty = self.CountyList[self.selectedCountyIndex]
                    self.settingStore.useCurrentLocation = self.useCurrentLocation
                    
                    self.settings.selectedState = self.StatesList[self.selectedStateIndex]
                    self.settings.selectedCounty = self.CountyList[self.selectedCountyIndex]
                    self.settings.useCurrentLocation = self.useCurrentLocation
                    
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                        .foregroundColor(.black)
                })
            )
        }.onAppear{
            self.settings.selectedCounty = self.settingStore.selectedCounty
            self.settings.selectedState = self.settingStore.selectedState
            self.settings.useCurrentLocation = self.settingStore.useCurrentLocation
            
            self.selectedStateIndex = self.CountyList.firstIndex(of: self.settings.selectedCounty ?? "") ?? 0
            self.selectedCountyIndex = self.StatesList.firstIndex(of: self.settings.selectedState ?? "") ?? 0
            self.useCurrentLocation = self.settings.useCurrentLocation
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(settingStore: SettingStore()).environmentObject(Setting(selectedState: "Massachusetts", selectedCounty: "Middlesex", useCurrentLocation: false))
    }
}
