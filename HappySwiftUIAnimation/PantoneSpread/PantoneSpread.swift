//
//  PantoneSpread.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct PantoneSpread: View {
    let cardCount = 6.0
    
    let hues = [Color(.systemRed), Color(.systemPink), Color(.systemPurple), Color(.systemBlue), Color(.systemCyan), Color(.black)]
    @State private var angle: CGFloat = 0
    @State private var width: CGFloat = 60
    @State private var height: CGFloat = 200
    @State private var lastAngle: CGFloat = 0
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { gesture in
                
                var theta = (atan2(gesture.location.x - self.width / 2, self.height / 2 - gesture.location.y) - atan2(gesture.startLocation.x - self.width / 2, self.height / 2 - gesture.startLocation.y)) * 180 / .pi
            
                print(angle)
                self.angle = theta + lastAngle
            }
            .onEnded { gesture in
                
                let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue
                let deceleration = decelerationRate / (1000.0 * (1.0 - decelerationRate))
                let velocityY = (gesture.predictedEndLocation.y - gesture.location.y) / deceleration
                let velocityX = (gesture.predictedEndLocation.x - gesture.location.x) / deceleration
                print(velocityX)
                if velocityX > 100 || angle >= 45 {
                    withAnimation(.spring()) {
                        angle = 90
                    }
                } else {
                    withAnimation(.spring()) {
                        angle = 0
                    }
                }
                self.lastAngle = self.angle
            }
    }
    
    func scale(minRange: CGFloat, maxRange: CGFloat, minDomain: CGFloat, maxDomain: CGFloat, value: CGFloat) -> CGFloat {
        return minDomain + (maxDomain - minDomain) * (value - minRange) / (maxRange - minRange)
    }
    
    func damping(_ value: Int) -> CGFloat {
        return scale(minRange: 1, maxRange: cardCount, minDomain: 0, maxDomain: 1, value: CGFloat(value))
    }
    
    var body: some View {
        CommonContainer {
            ZStack {
                Color(.black).ignoresSafeArea()
                VStack {
                    ZStack {
                        ForEach(1 ... Int(hues.count), id: \.self) { value in
                            ZStack {
                                ColorPalette(color: hues[value - 1])
                                    .frame(width: 60, height: 200)
                                    .shadow(color: Color.black.opacity(0.3), radius: 6)
                                    .offset(x: 40, y: 0)
                                    .rotationEffect(.degrees(Double(self.angle) * damping(value)), anchor: .bottomTrailing)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            if angle == 0 {
                                                angle = 90
                                                lastAngle = 90
                                            } else {
                                                angle = 0
                                                lastAngle = 0
                                            }
                                        }
                                        
                                    }.gesture(drag)
                            }
                            .position(x: 30, y: 590)
                        }
                    }
                }
                
            }.statusBarHidden()
        }
        
    }
}

struct PantoneSpread_Previews: PreviewProvider {
    static var previews: some View {
        PantoneSpread()
    }
}

struct ColorPalette: View {
    let color: Color
    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                    .brightness(0.3)
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                    .brightness(0.5)
            }.background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }.padding(4).background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
