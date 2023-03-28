//
//  TransformPlayground.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct TransformPlayground: View {
    @State private var shadowSelected = false

    @State private var zAxis = 0.0
    @State private var xAxis = 0.0
    @State private var yAxis = 0.0
    @State private var scaleX = 1.0
    @State private var scaleY = 1.0
    @State private var yOffset = 0.0
    @State private var xOffset = 0.0

    @State private var zAxisShadow = 0.0
    @State private var xAxisShadow = 0.0
    @State private var yAxisShadow = 0.0
    @State private var scaleXShadow = 1.0
    @State private var scaleYShadow = 1.0
    @State private var yOffsetShadow = 0.0
    @State private var xOffsetShadow = 0.0

    func linear(inMin: CGFloat, inMax: CGFloat, outMin: CGFloat, outMax: CGFloat, value: CGFloat) -> CGFloat {
        return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin)
    }

    func reset() {
        if shadowSelected {
            zAxisShadow = 0.0
            xAxisShadow = 0.0
            yAxisShadow = 0.0
            scaleXShadow = 1.0
            scaleYShadow = 1.0
            yOffsetShadow = 0.0
            xOffsetShadow = 0.0
        } else {
            zAxis = 0.0
            xAxis = 0.0
            yAxis = 0.0
            scaleX = 1.0
            scaleY = 1.0
            yOffset = 0.0
            xOffset = 0.0
        }
    }

    var body: some View {
        CommonContainer {
            Color(.white).offset(x: 0, y: 0)
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.black)
                        .blur(radius: 0)
                        .frame(width: 200, height: 200)
                        .padding(100)
                        .rotation3DEffect(.degrees(zAxisShadow), axis: (x: 0, y: 0, z: 1))
                        .rotation3DEffect(.degrees(yAxisShadow), axis: (x: 0, y: 1, z: 0))
                        .rotation3DEffect(.degrees(xAxisShadow), axis: (x: 1, y: 0, z: 0))
                        .offset(x: xOffsetShadow, y: yOffsetShadow)
                        .scaleEffect(x: scaleXShadow, y: scaleYShadow)
                        .onTapGesture {
                            if !shadowSelected {
                                shadowSelected = true
                            } else {
                                withAnimation(.spring()) {
                                    reset()
                                }
                            }
                        }

                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.blue)
                        .frame(width: 200, height: 200)
                        .padding(100)
                        .scaleEffect(x: scaleX, y: scaleY)
                        .rotation3DEffect(.degrees(zAxis), axis: (x: 0, y: 0, z: 1))
                        .rotation3DEffect(.degrees(yAxis), axis: (x: 0, y: 1, z: 0))
                        .rotation3DEffect(.degrees(xAxis), axis: (x: 1, y: 0, z: 0))
                        .offset(x: xOffset, y: yOffset)
                        .onTapGesture {
                            if shadowSelected {
                                shadowSelected = false
                            } else {
                                withAnimation(.spring()) {
                                    reset()
                                }
                            }
                        }
                }

                Spacer()
                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("X Axis Rotate")
                            Spacer()
                            Text("\(shadowSelected ? xAxisShadow : xAxis, specifier: "%.0f°")")
                                .font(.title2)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        if shadowSelected {
                                            xAxisShadow = 0
                                        } else {
                                            xAxis = 0
                                        }
                                    }
                                }
                        }
                        Slider(value: shadowSelected ? $xAxisShadow : $xAxis, in: -360...360, step: 1)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Y Axis Rotate")
                            Spacer()
                            Text("\(shadowSelected ? yAxisShadow : yAxis, specifier: "%.0f°")")
                                .font(.title2)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        if shadowSelected {
                                            yAxisShadow = 0
                                        } else {
                                            yAxis = 0
                                        }
                                    }
                                }
                        }
                        Slider(value: shadowSelected ? $yAxisShadow : $yAxis, in: -360...360, step: 1)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Z Axis Rotate")
                            Spacer()
                            Text("\(shadowSelected ? zAxisShadow : zAxis, specifier: "%.0f°")")
                                .font(.title2)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        if shadowSelected {
                                            zAxisShadow = 0
                                        } else {
                                            zAxis = 0
                                        }
                                    }
                                }
                        }
                        Slider(value: shadowSelected ? $zAxisShadow : $zAxis, in: -360...360, step: 1)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("X Scale")
                            Spacer()
                            Text("\(shadowSelected ? scaleXShadow : scaleX, specifier: "%.2f")")
                                .font(.title2)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        if shadowSelected {
                                            scaleXShadow = 1
                                        } else {
                                            scaleX = 1
                                        }
                                    }
                                }
                        }
                        Slider(value: shadowSelected ? $scaleXShadow : $scaleX, in: 0...2, step: 0.01)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Y Scale")
                            Spacer()
                            Text("\(shadowSelected ? scaleYShadow : scaleY, specifier: "%.2f")")
                                .font(.title2)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        if shadowSelected {
                                            scaleYShadow = 1
                                        } else {
                                            scaleY = 1
                                        }
                                    }
                                }
                        }
                        Slider(value: shadowSelected ? $scaleYShadow : $scaleY, in: 0...2, step: 0.01)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("X Offset")
                            Spacer()
                            Text("\(shadowSelected ? xOffsetShadow : xOffset, specifier: "%.0f")")
                                .font(.title2)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        if shadowSelected {
                                            xOffsetShadow = 0
                                        } else {
                                            xOffset = 0
                                        }
                                    }
                                }
                        }
                        Slider(value: shadowSelected ? $xOffsetShadow : $xOffset, in: -400...400, step: 1)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Y Offset")
                            Spacer()
                            Text("\(shadowSelected ? yOffsetShadow : yOffset, specifier: "%.0f")")
                                .font(.title2)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        if shadowSelected {
                                            yOffsetShadow = 0
                                        } else {
                                            yOffset = 0
                                        }
                                    }
                                }
                        }
                        Slider(value: shadowSelected ? $yOffsetShadow : $yOffset, in: -400...400, step: 1)
                    }
                }
                .padding(30)
                .foregroundColor(.secondary)
                .background(.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .offset(y: -55)
            }
            .padding(20)
        }
    }
}

struct TransformPlayground_Previews: PreviewProvider {
    static var previews: some View {
        TransformPlayground()
    }
}
