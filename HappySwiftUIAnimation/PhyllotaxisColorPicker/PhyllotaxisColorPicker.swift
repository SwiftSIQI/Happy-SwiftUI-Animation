//
//  PhyllotaxisColorPicker.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct PhyllotaxisColorPicker: View {
    let cardWidth = 380.0
    let cardHeight = 800.0
    let count = 320
    var radius = 7.0
    var dF = 0.55
    @State var dragged = false
    @State var theta = .pi * (3 - sqrt(5)) - 0.0005
    @State var scale = 1.4
    @State var rotation = 0.0

    @State var test = false

    var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                withAnimation(.spring()) {
                    dragged = true
                    theta = .pi * (3 - sqrt(5))
                }
            }
            .onEnded { _ in
                withAnimation(.spring()) {
                    dragged = false
                    theta = .pi * (3 - sqrt(5)) - 0.0005
                }
            }
    }

    func phyllotaxis(_ index: Int) -> CGSize {
        let radius = radius * Double(index).squareRoot()
        let a = theta * Double(index)

        return CGSize(width: radius * cos(a), height: radius * sin(a))
    }

    func scale(inputMin: CGFloat, inputMax: CGFloat, outputMin: CGFloat, outputMax: CGFloat, value: CGFloat) -> CGFloat {
        return outputMin + (outputMax - outputMin) * (value - inputMin) / (inputMax - inputMin)
    }

    func radiansToTheta(_ value: CGFloat) -> CGFloat {
        return scale(inputMin: 0, inputMax: 6.28, outputMin: 2.398, outputMax: 2.4, value: value)
    }

    func size(_ value: Int) -> CGFloat {
        return scale(inputMin: 0, inputMax: CGFloat(count), outputMin: dragged ? 0 : 0, outputMax: radius, value: CGFloat(value))
    }

    var body: some View {
        CommonContainer {
            ZStack {
                Color.black.ignoresSafeArea()

                AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
                    .saturation(1.5)
                    .frame(width: 240, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .offset(y: 2)

                AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
                    .saturation(1.5)
                    .frame(width: cardWidth, height: cardHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                ZStack {
                    Color.black
                        .frame(width: cardWidth, height: cardHeight)

                    ZStack {
                        ForEach(1 ... count, id: \.self) { value in
                            Circle()
                                .fill(.white)
                                .frame(width: size(value), height: size(value))
                                .offset(dragged ? phyllotaxis(value) : .zero)
                                .animation(.spring().delay(dragged ? Double(count - value) * 0.0008 : Double(value) * 0.0003), value: dragged)
                                .blendMode(.destinationOut)
                        }
                    }
                    .rotationEffect(.degrees(rotation))
                    .scaleEffect(scale)
                    .animation(.spring(), value: rotation)
                    .animation(.spring(), value: scale)

                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                            .blendMode(.destinationOut)

                        Circle()
                            .fill(.black)
                            .frame(width: dragged ? 55 : 40)
                            .animation(.spring(), value: dragged)
                    }
                }
                .compositingGroup()
                .drawingGroup()
                .gesture(drag)
                .statusBarHidden()
            }
        }
        
    }
}

struct PhyllotaxisColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        PhyllotaxisColorPicker()
    }
}
