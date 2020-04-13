//
//  InfoView.swift
//  CONVID-19-NA
//
//  Created by ARMSTRONG on 4/10/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            
            ScrollView {
                
            VStack(alignment: .leading, spacing: 8) {
                
                Group {
                    Text("On Today Widget").font(.title)
                    
                    Text("Simplified CONVID-19 data on selected State and County will be shown on your phones Today widget.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    Text("To view Today Widget just swipe right over the Home screen, Lock screen, or while youre looking at your notifications. ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }.foregroundColor(.gray)
                
                Spacer()
                
                Group {
                    Text("Setting").font(.title).foregroundColor(.gray)
                    
                    Text("You can use the GPS location on your phone or choose state/territory and county to display the CONVID-19 data.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                    Text("When choose to use your phone location, state/territory and county will be gray and not able to change. ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }.foregroundColor(.gray)

                Spacer()
                
                Section(header: Text("Use Phone location").font(.title)) {
                    Text("Select \"Allow While Using App\" to enable this App to use your phone's location while open the App first time.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                }.foregroundColor(.gray)
                
                Spacer()
                
                Section(header: Text("Data Update and Source").font(.title)) {
                    Text("Credit to John Hopkins University Coronavirus Resource Center for CONVID-19 data. This App only covers USA state/territory.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                    Text("Data updated once between 6-7pm daily by JHU CSSE. Tap the second top right Update icon to get updated data.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                    Text("Full Global ineractive Map at https://coronavirus.jhu.edu/map.html")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                }.foregroundColor(.gray)
                
                Spacer()
                Spacer()
            }
            .padding(.horizontal)
            .navigationBarTitle("Help")
            .navigationBarItems(leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Back")
                        .foregroundColor(.black)
                })
            ) // end of VStack
                
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
