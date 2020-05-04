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

    let UnassignedAdmin2 = "Unassigned"
    
    private var Province_State_Full_Name: String {
        //return self.setting.selectedState ?? "No State Chosen"
        if (self.setting.useCurrentLocation == true ) {
            
            let stateName = Helper.app.codeToName(code: self.lm.currentStateCode ?? "No State")
            self.setting.gpsLocationState = stateName
            
            return stateName
        }
        else {
            return self.setting.selectedState
        }
    }
    
    private var Province_State_Code: String {
        
        if (self.setting.useCurrentLocation == true ) {
            
            return self.lm.currentStateCode ?? "No State Found"
        } else {
            return Helper.app.nameToCode(name: self.setting.selectedState)
        }
    }
    
    private var Admin2: String {

        if (self.setting.useCurrentLocation == true ) {
            let countyName = self.lm.currentCounty ?? "No County Found"
            self.setting.gpsLocationCounty = countyName
            return countyName
        } else {
            return self.setting.selectedCounty
        }
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
    
    // @ObservedObject var networkManager = NetworkManager()
    
    @ObservedObject var lm = LocationManager()

    var gpsAuthorized: Bool {
        guard let authorized = lm.status?.rawValue else {
            self.setting.useCurrentLocation = false
            return false
        }
        
        self.setting.useCurrentLocation = authorized == 4 ? true : false
        
        return authorized == 4 ? true : false
    }
    
    var currentState: String { return("\(lm.placemark?.administrativeArea ?? "No State from current location")") }
    var currentCounty: String { return("\(lm.placemark?.subAdministrativeArea ?? "No County from current location")") }
    
    @State private var showSettings: Bool = false
    @State private var showInfos: Bool = false
    
    @EnvironmentObject var networkManager : NetworkManager
    
    @EnvironmentObject var setting: Setting
    
    //var settingStore: SettingStore
    
    private let cellHeight: CGFloat = 30

    // https://stackoverflow.com/questions/56505528/swiftui-update-navigation-bar-title-color
    init() {
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.gray]

        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.gray]
    }
    
    var body: some View {

        RefreshableNavigationView(title: "CONVID", action:{
            self.networkManager.loading = true
        })
        {
        //NavigationView  {
            VStack {
                /*
                Section {
                    Text("Status, \(self.gpsAuthorized.description)")
                    Text("Hello,  \(self.currentState)")
                    Text("Hello,  \(self.currentCounty)")
                } */
                
                Text(self.today)
                    .font(.system(Font.TextStyle.callout, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("TotalBalanceCard"))
                    .padding(.vertical)

                Section(header: Text("County: \(self.Admin2)")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("TotalBalanceCard"))
                
                ) {
                    HStack(spacing: 15) {
                        TileCard(tileName: "Confirmed", tileQuote: self.Admin2Confirmed, tileHeight: self.cellHeight, tileColor: "Card-Confirmed")

                        TileCard(tileName: "Deaths", tileQuote: self.Admin2Deaths, tileHeight: self.cellHeight, tileColor: "Card-Deaths")
                        
                    }.padding(.bottom)
                }
                
                Section(header: Text("State/Territory: \(self.Province_State_Full_Name)")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("TotalBalanceCard"))
                ) {
                    HStack(spacing: 15) {
                        TileCard(tileName: "Confirmed", tileQuote: self.Confirmed, tileHeight: self.cellHeight, tileColor: "Card-Confirmed")

                        TileCard(tileName: "Deaths", tileQuote:
                            self.Deaths, tileHeight: self.cellHeight, tileColor: "Card-Deaths")
                        
                    }
                    .padding(.bottom)
                }

                Section(header: Text("Country: USA")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("TotalBalanceCard"))
                ) {
                    HStack(spacing: 15) {
                        TileCard(tileName: "Confirmed", tileQuote: self.USConfirmed, tileHeight: self.cellHeight, tileColor: "Card-Confirmed")

                        TileCard(tileName: "Deaths", tileQuote:
                            self.USDeaths, tileHeight: self.cellHeight, tileColor: "Card-Deaths")
                        
                        TileCard(tileName: "Recovered", tileQuote: self.USRecovered, tileHeight: self.cellHeight, tileColor: "Card-Recovered")
                    }
                    .padding(.bottom)
                }
                                
                Spacer()
                
                Text("Updated: \(self.LastUpdate)      Source: John Hopkins CSSE")
                    .font(.footnote)
                    .fontWeight(.light)
                    .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                
                Spacer()
            }
            .padding(.horizontal)
            .listRowInsets(EdgeInsets())
            .navigationBarTitle("CONVID-19 USA", displayMode: .inline )
            .navigationBarItems(leading:
                Button(action: {
                    self.showInfos = true
                }, label: {
                    Image("help-2").resizable().scaledToFill().frame(width: 30, height: 40)                  .foregroundColor(.primary).aspectRatio(contentMode: .fill).clipShape(Circle())
                }).sheet(isPresented: self.$showInfos) {
                    InfoView()
                },
                trailing:
                
                HStack(spacing: 10) {
                    Button(action: {
                        self.networkManager.loading = true
                    }, label: {
                        Image(systemName: "goforward").font(.title)
                            .foregroundColor(.primary)
                    }).position(x: 0, y: 7)
                    
                    Button(action: {
                        self.showSettings = true
                    }, label: {
                        Image(systemName: "gear").font(.title)
                            .foregroundColor(.primary)
                    }).sheet(isPresented: self.$showSettings) {
                        SettingView().environmentObject(self.setting).environmentObject(self.networkManager)
                    }
                }.frame(alignment: .center)
            )  //.onAppear { self.networkManager.fetchCSVData()}
        }// Navigation view
    }
}

//}// freshView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Setting()).environmentObject(NetworkManager())
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
