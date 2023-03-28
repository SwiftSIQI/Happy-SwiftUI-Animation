//
//  BaseView.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct CommonContainer<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode

    
    var content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        ZStack {
            self.content()
        }
        .frame(minWidth: 0,maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture(count: 3) {
            self.presentationMode.wrappedValue.dismiss()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

