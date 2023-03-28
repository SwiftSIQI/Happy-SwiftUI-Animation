//
//  BoomerangApp.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct Boomerang: View {
    @State private var topCard = 1

    var body: some View {
        CommonContainer {
            Color(.black)
            ZStack {
                Card(color: Color("br-yellow"), index: 4, topCard: $topCard)
                Card(color: Color("br-red"), index: 3, topCard: $topCard)
                Card(color: Color("br-white"), index: 2, topCard: $topCard)
                Card(color: Color("br-blue"), index: 1, topCard: $topCard)
            }
            .statusBarHidden()
        }
        
    }
}

struct Boomerang_Previews: PreviewProvider {
    static var previews: some View {
        Boomerang()
    }
}
