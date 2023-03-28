//
//  FidgetText.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct FidgetText: View {
    @State var isDragging = false
    @State var dragLocation: CGPoint = .zero
    var text = Array("Happy Birthday")

    func scale(inputMin: CGFloat, inputMax: CGFloat, outputMin: CGFloat, outputMax: CGFloat, value: CGFloat) -> CGFloat {
        return outputMin + (outputMax - outputMin) * (value - inputMin) / (inputMax - inputMin)
    }

    func locationScale(_ value: CGFloat) -> CGFloat {
        return scale(inputMin: 0, inputMax: 360, outputMin: 0, outputMax: 14, value: value)
    }

    func offsetScale(_ value: CGFloat, index: Int) -> CGFloat {
        var dragPosition = scale(inputMin: 0, inputMax: 360, outputMin: 0, outputMax: 14, value: value)
        dragPosition = max(dragPosition, 0)
        if index == Int(dragPosition) {
            return -20.0
        } else if index == Int(dragPosition) + 1 || index == Int(dragPosition) - 1 {
            return -10.0
        } else {
            return 0.0
        }
    }

    func sizeScale(_ value: CGFloat, index: Int) -> CGFloat {
        var dragPosition = scale(inputMin: 0, inputMax: 360, outputMin: 0, outputMax: 14, value: value)
        dragPosition = max(dragPosition, 0)
        print(dragPosition)
        if index == Int(dragPosition) {
            return 1.8
        } else if index == Int(dragPosition) + 1 || index == Int(dragPosition) - 1 {
            return 1.1
        } else {
            return 1.0
        }
    }

    func colorScale(_ value: CGFloat, index: Int) -> Color {
        var dragPosition = scale(inputMin: 0, inputMax: 360, outputMin: 0, outputMax: 14, value: value)
        dragPosition = max(dragPosition, 0)
        if index == Int(dragPosition) {
            return Color("ft-dark")
        } else if index == Int(dragPosition) + 1 || index == Int(dragPosition) - 1 {
            return Color("ft-medium")
        } else {
            return Color("ft-light")
        }
    }

    func zScale(_ value: CGFloat, index: Int) -> Double {
        var dragPosition = scale(inputMin: 0, inputMax: 360, outputMin: 0, outputMax: 14, value: value)
        dragPosition = max(dragPosition, 0)
        if index == Int(dragPosition) {
            return 1
        } else {
            return 0
        }
    }

    var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { gesture in
                if !isDragging {
                    dragLocation = gesture.location
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                }
                isDragging = true
                if Int(locationScale(gesture.location.x)) != Int(locationScale(dragLocation.x)) {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                }
                withAnimation(.spring(response: 0.24, dampingFraction: 0.825, blendDuration: 0)) {
                    dragLocation = gesture.location
                }
            }
            .onEnded { _ in
                isDragging = false
            }
    }

    var body: some View {
        CommonContainer {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack {
                    HStack(spacing: 0) {
                        ForEach(Array(text.enumerated()), id: \.0) { index, value in
                            Text(String(value))
                                .offset(y: isDragging ? offsetScale(dragLocation.x, index: index) : 0)
                                .scaleEffect(isDragging ? sizeScale(dragLocation.x, index: index) : 1)
                                .foregroundColor(isDragging ? colorScale(dragLocation.x, index: index) : .white)
                                .zIndex(zScale(dragLocation.x, index: index))
                                .animation(.spring(), value: isDragging)
                                .padding(.vertical, 100)
                        }
                    }

                    .gesture(drag)
                }

            }.font(.system(size: 44.0, weight: .bold, design: .rounded))
                .statusBarHidden()
        }
        
    }
}

struct FidgetText_Previews: PreviewProvider {
    static var previews: some View {
        FidgetText()
    }
}
