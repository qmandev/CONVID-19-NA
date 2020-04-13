//
//  SettingView.swift
//  CONVID-19-NA
//
//  Created by ARMSTRONG on 4/3/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import SwiftUI
import CONVID_19DataKit

struct SettingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var networkManager : NetworkManager
    
    @EnvironmentObject var settings: Setting
    
    // var settingStore: SettingStore
    
    var stateCodeList = Helper.app.stateCodeList

    var countyList: [String] {
        let stateCode = self.stateCodeList[self.selectedStateIndex]
        
        let admin2DataList = networkManager.convidDataDictionary[stateCode]?.Admin2DataList ?? []
        
        return admin2DataList.compactMap( { $0.Admin2 ?? "" } )
    }
        
    @State private var useCurrentLocation = false
    @State private var selectedStateIndex = 0
    @State private var selectedCountyIndex = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("SATE/TERRITORY")) {
                    Picker(selection: $selectedStateIndex, label: Text("Chooes State/Territory")) {
                        ForEach(0 ..< stateCodeList.count, id: \.self) {
                            Text(Helper.app.codeToName(code: self.stateCodeList[$0]))
                        }
                    }
                }.disabled(self.useCurrentLocation)
                
                Section(header: Text("COUNTY")) {
                Picker(selection: $selectedCountyIndex, label: Text("Choose County")) {
                    ForEach(0 ..< countyList.count, id: \.self) {
                        Text("\(self.countyList[$0])")
                        }
                    }
                }.disabled(self.useCurrentLocation)
                
                Section(header: Text("LOCATION PREFERENCE")) {
                    Toggle(isOn: $useCurrentLocation) {
                        Text("Use Current Phone Location")
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
                    
                    self.settings.selectedState = Helper.app.codeToName(code: self.stateCodeList[self.selectedStateIndex])
                    self.settings.selectedCounty = self.countyList[self.selectedCountyIndex]
                    self.settings.useCurrentLocation = self.useCurrentLocation
                                        
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                        .foregroundColor(.black)
                })
            )
        }.onAppear{
            
            self.selectedStateIndex = self.stateCodeList.firstIndex(of: Helper.app.nameToCode(name: self.settings.selectedState)) ?? 0
            self.selectedCountyIndex = self.countyList.firstIndex(of: self.settings.selectedCounty) ?? 0
            self.useCurrentLocation = self.settings.useCurrentLocation
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView().environmentObject(Setting()).environmentObject(NetworkManager())
    }
}
