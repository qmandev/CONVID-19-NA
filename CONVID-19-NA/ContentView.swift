//
//  ContentView.swift
//  CONVID-19-NA
//
//  Created by ARMSTRONG on 3/17/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import SwiftUI
import CONVID_19DataKit

struct ContentView: View {

    let today : String = Date.today.string(with: "MM-dd-yyyy")
    // let Province_State: String
    // let Admin2: String
    // let Admin2 = "Middlesex"
    let UnassignedAdmin2 = "Unassigned"
    
    private var Province_State_Full_Name: String {
        //return self.setting.selectedState ?? "No State Chosen"
        return Helper.app.codeToName(code: self.lm.currentStateCode ?? "No State")
    }
    
    private var Province_State_Code: String {
        //return self.setting.selectedState ?? "No State Chosen"
        
        return self.lm.currentStateCode ?? "No State"
    }
    
    private var Admin2: String {
        //return self.setting.selectedCounty ?? "No State Chosen"
        
        return self.lm.currentCounty ?? "County"
    }
    
    private var USConfirmed: Int {
        var total: Int = 0
        for (_, convidData) in networkManager.convidDataDictionary {
            total += convidData.Confirmed
        }
        return total
    }
    
    private var USDeaths: Int {
        var total: Int = 0
        for (_, convidData) in networkManager.convidDataDictionary {
            total += convidData.Deaths
        }
        return total
    }
    
    private var USRecovered: Int {
        var total: Int = 0
        for (_, convidData) in networkManager.convidDataDictionary {
            total += convidData.Recovered
        }
        return total
    }
    
    private var LastUpdate: Date {
        return networkManager.convidDataDictionary[Province_State_Code]?.LastUpdate ?? Date.yesterday
    }
    
    private var Confirmed: Int {
        return networkManager.convidDataDictionary[Province_State_Code]?.Confirmed ?? 0
    }
    
    private var Deaths: Int {
        return networkManager.convidDataDictionary[Province_State_Code]?.Deaths ?? 0
    }
    
    private var Recovered: Int {
        return networkManager.convidDataDictionary[Province_State_Code]?.Recovered ?? 0
    }
    
    private var Admin2Confirmed: Int {
        // let admin2DataDebug = networkManager.convidDataDictionary[Province_State]?.Admin2DataList
        
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
    
    @ObservedObject var networkManager = NetworkManager()
    
    @ObservedObject var lm = LocationManager()

    var placemark: String { return("\(lm.placemark?.description ?? "XXX")") }
    var status: String { return("\(lm.status?.rawValue ?? 0)") }
    var currentState: String { return("\(lm.placemark?.administrativeArea ?? "No State from current location")") }
    var currentCounty: String { return("\(lm.placemark?.subAdministrativeArea ?? "No County from current location")") }
    
    @State private var showSettings: Bool = false
    
    @EnvironmentObject var setting: Setting
    
    var settingStore: SettingStore
    
    private let cellHeight: CGFloat = 30

    // https://stackoverflow.com/questions/56505528/swiftui-update-navigation-bar-title-color
    init() {
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.gray]

        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        self.settingStore = SettingStore()
    }
    
    var body: some View {

        NavigationView  {
            VStack {

                /*
                Section {
                    Text("Status, \(self.status)")
                    Text("Hello,  \(self.currentState)")
                    Text("Hello,  \(self.currentCounty)")
                }*/
                
                Text(today)
                    .font(.system(Font.TextStyle.callout, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("TotalBalanceCard"))
                    .padding(.vertical)

                Section(header: Text("County: \(Admin2)")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("TotalBalanceCard"))
                
                ) {
                    HStack(spacing: 15) {
                        TileCard(tileName: "Confirmed", tileQuote: Admin2Confirmed, tileHeight: cellHeight, tileColor: "Card-Confirmed")

                        TileCard(tileName: "Deaths", tileQuote: Admin2Deaths, tileHeight: cellHeight, tileColor: "Card-Deaths")
                        
                    }.padding(.bottom)
                }
                
                Section(header: Text("State: \(Province_State_Full_Name)")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("TotalBalanceCard"))
                ) {
                    HStack(spacing: 15) {
                        TileCard(tileName: "Confirmed", tileQuote: Confirmed, tileHeight: cellHeight, tileColor: "Card-Confirmed")

                        TileCard(tileName: "Deaths", tileQuote:
                            Deaths, tileHeight: cellHeight, tileColor: "Card-Deaths")
                        
                    }
                    .padding(.bottom)
                }

                Section(header: Text("Country: USA")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("TotalBalanceCard"))
                ) {
                    HStack(spacing: 15) {
                        TileCard(tileName: "Confirmed", tileQuote: USConfirmed, tileHeight: cellHeight, tileColor: "Card-Confirmed")

                        TileCard(tileName: "Deaths", tileQuote:
                            USDeaths, tileHeight: cellHeight, tileColor: "Card-Deaths")
                        
                        TileCard(tileName: "Recovered", tileQuote: USRecovered, tileHeight: cellHeight, tileColor: "Card-Recovered")
                    }
                    .padding(.bottom)
                }
                                
                Spacer()
                
                Text("Updated: \(LastUpdate)   Source: John Hopkins CSSE")
                    .font(.footnote)
                    .fontWeight(.light)
                
                Spacer()
            }
            .padding(.horizontal)
            .listRowInsets(EdgeInsets())
            .navigationBarTitle("CONVID-19 USA" )
            .navigationBarItems(trailing:
            
                Button(action: {
                    self.showSettings = true
                }, label: {
                    Image(systemName: "gear").font(.title)
                        .foregroundColor(.black)
                })
            )
            .sheet(isPresented: $showSettings) {
                SettingView(settingStore: self.settingStore).environmentObject(self.setting)
            }
            
            //.onAppear { self.networkManager.fetchCSVData()}
        }  // Navigation view
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Setting(selectedState: "Massachusetts", selectedCounty: "Middlesex", useCurrentLocation: false))
    }
}

struct TileCard: View {
    var tileName: String
    var tileQuote: Int
    var tileHeight: CGFloat
    var tileColor: String
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(Color(tileColor))
                .cornerRadius(8.0)
         
            VStack {
                Text("\(tileName)")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.black)
                    .foregroundColor(.white)
                Divider()
                Text("\(tileQuote)")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
            }
        }
        .frame(minHeight: tileHeight, maxHeight: .infinity)
        
    }
}
