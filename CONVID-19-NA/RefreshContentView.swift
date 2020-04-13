//
//  RefreshContentView.swift
//  CONVID-19-NA
//
//  Created by ARMSTRONG on 4/11/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import SwiftUI
import CONVID_19DataKit

struct RefreshContentView: View {
    
    // @ObservedObject var networkManager = NetworkManager()
    
    @EnvironmentObject var networkManager : NetworkManager
    
    @State private var alternate: Bool = true
    
    let array = Array<String>(repeating: "Hello", count: 100)
    let transaction = Transaction(animation: .easeInOut(duration: 2.0))
    
    var body: some View {
        return VStack(spacing: 0) {
            
            RefreshableScrollView(height: 70, refreshing: self.$networkManager.loading) {
                
            ContentView().environmentObject(Setting()).environmentObject(self.networkManager)
            }
        }
    }
}

struct RefreshContentView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshContentView().environmentObject(NetworkManager())
    }
}
