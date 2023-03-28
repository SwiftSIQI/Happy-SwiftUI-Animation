//
//  DynamicTouch.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import Darwin
import SwiftUI

struct DTHelper {
    static let e = Darwin.M_E

    static var randomArray = (1...600).map { _ in Int.random(in: 1...108) }
    static func getDistance(p1: CGPoint, p2: CGPoint) -> Float {
        return hypotf(Float(p1.x - p2.x), Float(p1.y - p2.y))
    }

    static func scale(inputMin: CGFloat, inputMax: CGFloat, outputMin: CGFloat, outputMax: CGFloat, value: CGFloat) -> CGFloat {
        return outputMin + (outputMax - outputMin) * (value - inputMin) / (inputMax - inputMin)
    }

    static var rows: Int = .init((UIScreen.main.bounds.size.height - 20) / 16)
    static var cols: Int = .init((UIScreen.main.bounds.size.width - 20) / 16)
    static var spacing = 14
    static var size = 4

    static func getScale(cell: Int, row: Int, selectedPoint: CGPoint) -> CGFloat {
        let p1 = CGPoint(x: spacing + cell * (size + spacing), y: spacing + row * (size + spacing))
        let p2 = selectedPoint
        let distance = getDistance(p1: p1, p2: p2)

        var normalizedDistance = scale(inputMin: 0, inputMax: 80, outputMin: 0.0, outputMax: 2.5, value: CGFloat(distance))

        normalizedDistance = min(2.5, normalizedDistance)
        normalizedDistance = max(0, normalizedDistance)

        return normalizedDistance
    }

    static func getScaleDelay(cell: Int, row: Int, selectedPoint: CGPoint) -> CGFloat {
        let p1 = CGPoint(x: spacing + cell * (size + spacing), y: spacing + row * (size + spacing))
        let p2 = selectedPoint
        let distance = getDistance(p1: p1, p2: p2)

        let normalizedDelay = scale(inputMin: 0, inputMax: 600, outputMin: 0.0, outputMax: 0.8, value: CGFloat(distance))
        print(normalizedDelay)

        return normalizedDelay
    }
}

struct DynamicTouch: View {
    @Environment(\.presentationMode) var presentationMode

    var tapped: some Gesture {
        SpatialTapGesture()
            .onEnded { gesture in
                tappedPoint = gesture.location
                count += 1
            }
    }

    @State var selectedPoint: CGPoint = .zero
    @State var tappedPoint: CGPoint = .zero
    @State var isDragging = false
    @State var count = 0.0

    var body: some View {
        CommonContainer {
            Color(.black)
            ZStack {
                Color(.black).ignoresSafeArea()
                    .gesture(
                        DragGesture(minimumDistance: 10)
                            .onChanged { gesture in
                                withAnimation(.spring()) {
                                    selectedPoint = CGPoint(x: gesture.location.x, y: gesture.location.y)
                                    isDragging = true
                                }
                            }
                            .onEnded { _ in
                                withAnimation(.spring()) {
                                    isDragging = false
                                }
                            }
                    )
                    .simultaneousGesture(tapped)
                ZStack {
                    ForEach(0...DTHelper.rows - 1, id: \.self) { row in
                        ForEach(0...DTHelper.cols - 1, id: \.self) { cell in
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(.white)
                                .frame(width: CGFloat(DTHelper.size), height: CGFloat(DTHelper.size))
                                .modifier(ScaleEffect(value: count))
                                .scaleEffect(isDragging ? 3.5 - DTHelper.getScale(cell: cell, row: row, selectedPoint: selectedPoint) : 1.0)
                                .position(x: CGFloat(DTHelper.spacing + cell * (DTHelper.size + DTHelper.spacing)), y: CGFloat(DTHelper.spacing + row * (DTHelper.size + DTHelper.spacing)))
                                .animation(.spring(dampingFraction: 0.4).delay(DTHelper.getScaleDelay(cell: cell, row: row, selectedPoint: tappedPoint)), value: tappedPoint)
                        }
                    }
                }
                .allowsHitTesting(false)
            }
            .statusBarHidden()
            .ignoresSafeArea()
            .offset(x: 0, y: 100)

        }
    }
}

struct ScaleEffect: GeometryEffect {
    var value: Double

    var animatableData: Double {
        get { value }
        set { value = newValue }
    }

    func curveEffectValue(_ value: Double) -> Double {
        return 1 - cos(value * Double.pi * 2) + 1
    }

    func springApprox(_ x: Double) -> Double {
        return -(pow(DTHelper.e, -(x / 0.2)) * cos(x * 20)) + 1
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let effectValue = curveEffectValue(Double(value))

        let scaleBy = CGFloat(effectValue)

        let affineTransform = CGAffineTransform(translationX: size.width * 0.5, y: size.height * 0.5)
            .scaledBy(x: scaleBy, y: scaleBy)
            .translatedBy(x: -size.width * 0.5, y: -size.height * 0.5)

        return ProjectionTransform(affineTransform)
    }
}

struct DynamicTouch_Previews: PreviewProvider {
    static var previews: some View {
        DynamicTouch()
    }
}
