//
//  DynamicGrid.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct DGHelper {
    static var randomArray = (1...600).map { _ in Int.random(in: 1...108) }
    static func getDistance(p1: CGPoint, p2: CGPoint) -> Float {
        return hypotf(Float(p1.x - p2.x), Float(p1.y - p2.y))
    }

    static func scale(inputMin: CGFloat, inputMax: CGFloat, outputMin: CGFloat, outputMax: CGFloat, value: CGFloat) -> CGFloat {
        return outputMin + (outputMax - outputMin) * (value - inputMin) / (inputMax - inputMin)
    }

    static var rows = 22
    static var cols = 12
}

struct DynamicGrid: View {
    @State var spacing = 18

    @State var size = (Int(UIScreen.main.bounds.width) / DGHelper.cols) - 18
    @State var selectedPoint: CGPoint = .zero
    @State var isDragging = false

    func getOffset(cell: Int, row: Int, selectedPoint: CGPoint) -> CGPoint {
        let p1 = CGPoint(x: spacing + cell * (size + spacing), y: spacing + row * (size + spacing))
        let p2 = selectedPoint

        let distance = DGHelper.getDistance(p1: p1, p2: p2)

        var normalizedDistance = DGHelper.scale(inputMin: 0, inputMax: 1000, outputMin: 0, outputMax: 3.5, value: CGFloat(distance))

        normalizedDistance = min(1, normalizedDistance)
        normalizedDistance = max(0, normalizedDistance)

        let x = (p2.x * normalizedDistance) + (p1.x * (1 - normalizedDistance))
        let y = (p2.y * normalizedDistance) + (p1.y * (1 - normalizedDistance))

        return CGPoint(x: x, y: y)
    }

    func getScale(cell: Int, row: Int, selectedPoint: CGPoint) -> CGFloat {
        let p1 = CGPoint(x: spacing + cell * (size + spacing), y: spacing + row * (size + spacing))
        let p2 = selectedPoint

        let distance = DGHelper.getDistance(p1: p1, p2: p2)

        var normalizedDistance = DGHelper.scale(inputMin: 0, inputMax: 1000, outputMin: 0, outputMax: 20, value: CGFloat(distance))

        normalizedDistance = min(2.2, normalizedDistance)
        normalizedDistance = max(0, normalizedDistance)

        return normalizedDistance
    }

    var body: some View {
        CommonContainer {
            Color(.black)
            ZStack {
                Color(.black).ignoresSafeArea()
                    .gesture(
                        DragGesture(minimumDistance: 0)
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
                ZStack {
                    ForEach(0...DGHelper.rows - 1, id: \.self) { row in
                        ForEach(0...DGHelper.cols - 1, id: \.self) { cell in
                            Image("photo\(DGHelper.randomArray[row * DGHelper.cols + cell])")
                                .resizable()
                                .frame(width: CGFloat(size), height: CGFloat(size))
                                .clipShape(RoundedRectangle(cornerRadius: isDragging ? 5 : 4, style: .continuous))
                                .scaleEffect(isDragging ? 2.4 - getScale(cell: cell, row: row, selectedPoint: selectedPoint) : 1.5)
                                .position(x: isDragging ? getOffset(cell: cell, row: row, selectedPoint: selectedPoint).x : CGFloat(spacing + cell * (size + spacing)), y: isDragging ? getOffset(cell: cell, row: row, selectedPoint: selectedPoint).y : CGFloat(spacing + row * (size + spacing)))
                                .zIndex(isDragging ? 2.4 - getScale(cell: cell, row: row, selectedPoint: selectedPoint) * 100.0 : 1)
                        }
                    }
                }
            }
            .offset(x: 8, y: 100)
            .scaleEffect(isDragging ? 2 : 0.9, anchor: .center)
            .ignoresSafeArea()
        }
    }
}

struct DynamicGrid_Previews: PreviewProvider {
    static var previews: some View {
        DynamicGrid()
    }
}
