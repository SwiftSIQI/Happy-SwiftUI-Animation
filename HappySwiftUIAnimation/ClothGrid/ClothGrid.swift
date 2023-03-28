//
//  ClothGrid.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct CGHelper {
    static func getDistance(p1: CGPoint, p2: CGPoint) -> Float {
        return hypotf(Float(p1.x - p2.x), Float(p1.y - p2.y))
    }

    static func scale(inputMin: CGFloat, inputMax: CGFloat, outputMin: CGFloat, outputMax: CGFloat, value: CGFloat) -> CGFloat {
        return outputMin + (outputMax - outputMin) * (value - inputMin) / (inputMax - inputMin)
    }

    static var rows: Int = .init((UIScreen.main.bounds.width - 44) / 18)
    static var cols: Int = 14
    static var spacing: Int = 4
    static var padding: Int = 4
    static var width: Int = .init(UIScreen.main.bounds.width)
    static var height: Int = 220
    static var size: Int = 16
}



struct ClothGrid: View {
    @State var selectedPoint: CGPoint = .zero
    @State var isDragging = false

    let colors: [Color] = [Color("cg-red"), Color("cg-pink"), Color("cg-yellow"), Color("cg-green"), Color("cg-blue"), Color("cg-red")]

    func getOffset(cell: Int, row: Int, selectedPoint: CGPoint, isDragging: Bool) -> CGPoint {
        let p1 = CGPoint(
            x: Double(row * (CGHelper.size + CGHelper.spacing)),
            y: Double(cell * (CGHelper.size + CGHelper.spacing))
        )
        let p2 = selectedPoint

        let distance = CGHelper.getDistance(p1: p1, p2: p2)

        var normalizedDistance = CGHelper.scale(inputMin: 0, inputMax: 1000, outputMin: 0, outputMax: 5, value: CGFloat(distance))

        normalizedDistance = min(1, normalizedDistance)
        normalizedDistance = max(0, normalizedDistance)

        if isDragging {
            let x = (p1.x * normalizedDistance) + (p2.x * (1 - normalizedDistance))
            let y = (p1.y * normalizedDistance) + (p2.y * (1 - normalizedDistance))
            return CGPoint(x: x, y: y)
        } else {
            return p1
        }
    }

    func getScale(cell: Int, row: Int, selectedPoint: CGPoint) -> CGFloat {
        let p1 = CGPoint(x: Double(row * (CGHelper.size + CGHelper.spacing)), y: Double(cell * (CGHelper.size + CGHelper.spacing)))
        let p2: CGPoint = selectedPoint

        let distance = CGHelper.getDistance(p1: p1, p2: p2)

        var normalizedDistance = CGHelper.scale(inputMin: 0, inputMax: 1000, outputMin: 0, outputMax: 4, value: CGFloat(distance))

        normalizedDistance = min(1, normalizedDistance)
        normalizedDistance = max(0.3, normalizedDistance)

        return normalizedDistance
    }

    var body: some View {
        CommonContainer{
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
                    ForEach(0...CGHelper.rows - 1, id: \.self) { row in
                        ForEach(0...CGHelper.cols - 1, id: \.self) { cell in
                            RoundedRectangle(cornerRadius: 4, style: .circular)
                                .fill(.white)
                                .frame(width: CGFloat(CGHelper.size), height: CGFloat(CGHelper.size))
                                .scaleEffect(isDragging ? getScale(cell: cell, row: row, selectedPoint: selectedPoint) : 1)
                                .position(getOffset(cell: cell, row: row, selectedPoint: selectedPoint, isDragging: isDragging))
                                .zIndex(isDragging ? 2.4 - getScale(cell: cell, row: row, selectedPoint: selectedPoint) * 100.0 : 1)
                                .allowsHitTesting(false)
                        }
                    }
                }
            }
            .offset(x: CGFloat(CGHelper.size), y: (UIScreen.main.bounds.size.height - 220) / 2)
            .scaleEffect(1)
            .background(Color.black)
            .statusBar(hidden: true)

            AngularGradient(gradient: Gradient(colors: colors), center: .center, angle: .degrees(90))
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                .blur(radius: 30)
                .blendMode(.multiply)
                .allowsHitTesting(false)
        }

    }
}

struct ClothGrid_Previews: PreviewProvider {
    static var previews: some View {
        ClothGrid()
    }
}
