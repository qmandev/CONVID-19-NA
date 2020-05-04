//
//  NavFreshableScrollView.swift
//  CONVID-19-NA
//
//  Created by ARMSTRONG on 4/23/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import SwiftUI

struct NavFreshableScrollView: View {
    
    @State var numbers:[Int] = [23,45,76,54,76,3465,24,423]
    
    var body: some View {
        RefreshableNavigationView(title: "Numbers", action:{
            self.numbers = self.generateRandomNumbers()
        }){
            ForEach(self.numbers, id: \.self){ number in
                VStack(alignment: .leading){
                    Text("\(number)")
                    Divider()
                }
            }
        }
    }
    
    func generateRandomNumbers() -> [Int] {
        var sequence = [Int]()
        for _ in 0...30 {
            sequence.append(Int.random(in: 0 ..< 100))
        }
        return sequence
    }
}

struct NavFreshableScrollView_Previews: PreviewProvider {
    static var previews: some View {
        NavFreshableScrollView()
    }
}

