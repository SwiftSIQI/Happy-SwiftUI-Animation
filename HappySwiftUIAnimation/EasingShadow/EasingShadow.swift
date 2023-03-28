//
//  EasingShadow.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct EasingShadow: View {
    @State private var layerCount = 60.0
    @State private var blurMax = 70.0
    @State private var blurFactor = 10.0
    @State private var yOffsetFactor = 10.0
    @State private var yOffsetMax = 80.0
    @State private var xOffsetMax = 0.0
    @State private var isDragging = false
    @State private var dragOffset: CGPoint = .zero

    var intensity: CGFloat = 6
    var width: CGFloat = 320
    var height: CGFloat = 220

    func scale(inputMin: CGFloat, inputMax: CGFloat, outputMin: CGFloat, outputMax: CGFloat, value: CGFloat) -> CGFloat {
        return outputMin + (outputMax - outputMin) * (value - inputMin) / (inputMax - inputMin)
    }

    func yOffsetScale(_ value: CGFloat, factor: CGFloat? = 10.0) -> CGFloat {
        return scale(inputMin: -200, inputMax: pow(CGFloat(layerCount), factor!), outputMin: 3, outputMax: yOffsetMax, value: value)
    }

    func yOffsetMaxScale(_ value: CGFloat) -> CGFloat {
        return scale(inputMin: -intensity, inputMax: intensity, outputMin: 0, outputMax: 300, value: value)
    }

    func xOffsetMaxScale(_ value: CGFloat) -> CGFloat {
        return scale(inputMin: -intensity, inputMax: intensity, outputMin: -80, outputMax: 80, value: value)
    }

    func blurMaxScale(_ value: CGFloat) -> CGFloat {
        return scale(inputMin: -intensity, inputMax: intensity, outputMin: 20, outputMax: 120, value: value)
    }

    func xOffsetScale(_ value: CGFloat, factor: CGFloat? = 10.0) -> CGFloat {
        return scale(inputMin: 0, inputMax: pow(CGFloat(layerCount), factor!), outputMin: 0, outputMax: xOffsetMax, value: value)
    }

    func blurScale(_ value: CGFloat, factor: CGFloat) -> CGFloat {
        return scale(inputMin: 0, inputMax: pow(CGFloat(layerCount), factor), outputMin: 0, outputMax: blurMax, value: value)
    }

    func opacityScale(_ value: CGFloat, factor: CGFloat? = 2.0) -> CGFloat {
        return scale(inputMin: 0, inputMax: layerCount, outputMin: 0, outputMax: 1, value: value)
    }

    var body: some View {
        CommonContainer {
            ZStack {
                Color("es-bg").ignoresSafeArea()
                ZStack {
                    ForEach(1...Int(layerCount), id: \.self) { value in
                        if value > 0 {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color("es-shadow").opacity(1 - opacityScale(CGFloat(value))))
                                .scaleEffect(0.92)
                                .blur(radius: blurScale(pow(CGFloat(value), blurFactor), factor: blurFactor))
                                .frame(width: width, height: height)
                                .offset(x: xOffsetScale(pow(CGFloat(value), 10)), y: yOffsetScale(pow(CGFloat(value), yOffsetFactor)))
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .drawingGroup()
                .opacity(0.9)

                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(LinearGradient(gradient: Gradient(colors: [.white, Color("es-cardTop")]), startPoint: .top, endPoint: .bottom))
                    .frame(width: width, height: height)
                    .rotation3DEffect(.degrees(dragOffset.x), axis: (x: 0, y: 1, z: 0))
                    .rotation3DEffect(.degrees(dragOffset.y), axis: (x: 1, y: 0, z: 0))
                    .gesture(
                        DragGesture(minimumDistance: 0.0)
                            .onChanged { gesture in
                                let normalizedX = scale(inputMin: 0, inputMax: width, outputMin: -intensity, outputMax: intensity, value: gesture.location.x)
                                let normalizedY = scale(inputMin: 0, inputMax: height, outputMin: intensity, outputMax: -intensity, value: gesture.location.y)

                                withAnimation(.easeOut(duration: 0.2)) {
                                    yOffsetMax = yOffsetMaxScale(normalizedY)
                                    xOffsetMax = -xOffsetMaxScale(normalizedX)
                                    blurMax = blurMaxScale(normalizedY)
                                    dragOffset = CGPoint(x: normalizedX, y: normalizedY)
                                }
                            }
                            .onEnded { _ in
                                withAnimation(.spring()) {
                                    dragOffset = .zero
                                    yOffsetMax = 80.0
                                    xOffsetMax = 0.0
                                }
                            }
                    )

                VStack(spacing: 4) {
                    Text("Y Offset")
                    Slider(value: $yOffsetMax, in: -400...400, step: 1)
                    Text("Layer Count")
                    Slider(value: $layerCount, in: 1...120, step: 1)
                    Text("X Offset")
                    Slider(value: $xOffsetMax, in: -400...400, step: 1)
                    Text("Blur Max")
                    Slider(value: $blurMax, in: 0...200, step: 1)
                    Spacer()
                }.padding(60)
                    .statusBarHidden()
            }
        }
    }
}

struct EasingShadow_Previews: PreviewProvider {
    static var previews: some View {
        EasingShadow()
    }
}
