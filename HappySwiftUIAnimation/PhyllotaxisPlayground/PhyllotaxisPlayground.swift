//
//  PhyllotaxisPlayground.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct PhyllotaxisPlayground: View {
    @State var radius = 8.0
    @State var dragged = false
    @State var theta = .pi * (3 - sqrt(5))
    @State var count = 500.0
    @State var spacingFactor = 1.0

    var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                if !dragged {
                    withAnimation(.spring()) {
                        dragged = true
                    }
                }
            }
            .onEnded { _ in
                withAnimation(.spring()) {
                    dragged = false
                }
            }
    }

    func phyllotaxis(_ index: Int) -> CGSize {
        let radius = 8.0 * Double(index).squareRoot()
        let a = theta * Double(index)

        return CGSize(width: radius * cos(a) * spacingFactor, height: radius * sin(a) * spacingFactor)
    }

    func scale(inputMin: CGFloat, inputMax: CGFloat, outputMin: CGFloat, outputMax: CGFloat, value: CGFloat) -> CGFloat {
        return outputMin + (outputMax - outputMin) * (value - inputMin) / (inputMax - inputMin)
    }

    func size(_ value: Int) -> CGFloat {
        return scale(inputMin: 0, inputMax: 500, outputMin: dragged ? 0 : 0, outputMax: radius, value: CGFloat(value))
    }

    var body: some View {
        CommonContainer {
            VStack {
                Color(.white)
                ZStack {
                    ForEach(1...Int(count), id: \.self) { value in
                        Circle()
                            .fill(.black)
                            .frame(width: size(value), height: size(value))
                            .offset(phyllotaxis(value))
                            .animation(.interactiveSpring(), value: theta)
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                .gesture(drag)

                VStack {
                    Spacer()
                    Slider(value: $theta,
                           in: 2.396...2.41,
                           step: 0.0001)
                    Text("Theta: \(theta)")

                    Slider(value: $count,
                           in: 20...1000,
                           step: 1.0)
                    Text("Count: \(count)")

                    Slider(value: $radius,
                           in: 0...20,
                           step: 0.1)
                    Text("Radius: \(radius)")

                    Slider(value: $spacingFactor,
                           in: 0.1...3,
                           step: 0.1)
                    Text("Spacing: \(spacingFactor)")
                }.padding(.bottom, 100)
            }
        }
    }
}

struct PhyllotaxisPlayground_Previews: PreviewProvider {
    static var previews: some View {
        PhyllotaxisPlayground()
    }
}
