//
//  RadialDial.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct RadialDial: View {
    @State private var angle: Double = 0
    @State private var size: Double = 160
    @State private var circles = 15

    func scale(inputMin: CGFloat, inputMax: CGFloat, outputMin: CGFloat, outputMax: CGFloat, value: CGFloat) -> CGFloat {
        return outputMin + (outputMax - outputMin) * (value - inputMin) / (inputMax - inputMin)
    }

    func lightScale(_ value: CGFloat, index: Int) -> Bool {
        let normalizedAngle = scale(inputMin: -120, inputMax: 105, outputMin: 0, outputMax: 100, value: value)
        let normalizedLight = scale(inputMin: 0, inputMax: CGFloat(circles), outputMin: 0, outputMax: 100, value: CGFloat(index))

        if normalizedAngle >= normalizedLight {
            return true
        } else {
            return false
        }
    }

    func maskScale(_ value: CGFloat) -> CGFloat {
        return scale(inputMin: -100, inputMax: 100, outputMin: -0.30, outputMax: 0.30, value: value)
    }

    var drag: some Gesture {
        DragGesture()
            .onChanged { gesture in
                angle = atan2(gesture.location.x - size / 2, size / 2 - gesture.location.y) * (180 / .pi)
            }
            .onEnded { _ in
            }
    }

    var body: some View {
        CommonContainer {
            ZStack {
                RadialGradient(colors: [Color("rd-top"), Color("rd-bottom")], center: .top, startRadius: 0, endRadius: 500)
                    .ignoresSafeArea()
                Circle()
                    .fill(Color("rd-bottom"))
                    .frame(width: size)
                    .blur(radius: 9)
                    .brightness(-0.1)
                    .opacity(0.4)
                    .offset(y: 5)

                Circle()
                    .fill(Color("rd-bottom"))
                    .frame(width: size)
                    .blur(radius: 4)
                    .brightness(-0.1)
                    .offset(y: 3)

                Circle()
                    .fill(Color("rd-bottom"))
                    .frame(width: size)
                    .blur(radius: 1)
                    .brightness(-0.1)
                    .offset(y: 2)

                Circle()
                    .fill(RadialGradient(colors: [Color("rd-circleTop"), Color("rd-bottom")], center: .top, startRadius: 0, endRadius: 130)
                        .shadow(
                            .inner(color: Color("rd-red"), radius: 6, x: 0, y: 10)
                        ))
                    .frame(width: size)
                    .allowsHitTesting(false)

                Circle()
                    .fill(RadialGradient(colors: [Color("rd-circleTop"), Color("rd-bottom")], center: .top, startRadius: 0, endRadius: 130)
                        .shadow(
                            .inner(color: Color("rd-top"), radius: 6, x: 0, y: 10)
                        ))
                    .frame(width: size)
                    .allowsHitTesting(false)
                    .mask {
                        AngularGradient(
                            stops: [
                                .init(color: .white, location: 0.00),
                                .init(color: .white, location: 0.15),
                                .init(color: .clear, location: 0.16),
                                .init(color: .clear, location: 0.45 + maskScale(angle)),
                                .init(color: .white, location: 0.55 + maskScale(angle)),
                                .init(color: .white, location: 1.0)
                            ],
                            center: .center,
                            startAngle: .degrees(0 + 90),
                            endAngle: .degrees(360 + 90)
                        )
                    }

                ZStack {
                    Circle()
                        .fill(.clear)
                        .frame(width: size)

                    Circle()
                        .fill(Color(.white))
                        .frame(width: 100)
                        .opacity(0.0001)
                        .offset(y: -60)
                        .brightness(0.2)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.white))
                        .frame(width: 4, height: 10)
                        .offset(y: -60)
                        .brightness(0.2)
                }
                .rotationEffect(.degrees(Double(angle)))
                .gesture(drag)

                ZStack {
                    ForEach(1 ... circles, id: \.self) { value in
                        Circle()
                            .fill(lightScale(angle, index: value) ? Color("rd-red") : .black)
                            .frame(width: 8)
                            .offset(y: -94)
                            .rotationEffect(.degrees(Double((260 / circles) * value)))
                            .shadow(color: Color("rd-red"), radius: lightScale(angle, index: value) ? 4 : 0)
                    }
                }.rotationEffect(.degrees(-136))
            }
        }
        
    }
}

struct RadialDial_Previews: PreviewProvider {
    static var previews: some View {
        RadialDial()
    }
}

