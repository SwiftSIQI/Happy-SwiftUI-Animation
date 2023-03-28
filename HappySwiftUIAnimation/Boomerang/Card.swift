//
//  Card.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct CardHelper {
    // Constants
    static let delay: Double = 0.17
    static var startingOffset = 550.0
}


struct Card: View {

    // Card State
    @State var rotation: Double = 0
    @State var zIndex: Double = 0
    @State var dragTranslation: CGSize = .init(width: 0, height: CardHelper.startingOffset)

    // View Parameters
    let color: Color
    let index: Int
    @Binding var topCard: Int

    // Base Linear Scale
    func scale(inputMin: CGFloat, inputMax: CGFloat, outputMin: CGFloat, outputMax: CGFloat, value: CGFloat) -> CGFloat {
        return outputMin + (outputMax - outputMin) * (value - inputMin) / (inputMax - inputMin)
    }

    // How much should the card rotate based on velocity
    func rotationalScale(value: CGFloat) -> CGFloat {
        return round(scale(inputMin: 0, inputMax: 1, outputMin: 0, outputMax: 3, value: value))
    }

    // Change translation based on velocity
    func locationScale(value: CGFloat) -> CGFloat {
        return scale(inputMin: 0, inputMax: 1, outputMin: -500, outputMax: 300, value: value)
    }

    // Change resting offset based on the topCard value
    func offsetScale(topCard: Int, index: Int) -> CGFloat {
        let position = whereAmI(topCard: topCard, index: index)
        return scale(inputMin: 1, inputMax: 4, outputMin: 60, outputMax: 0, value: CGFloat(position))
    }

    // Change scale based on the topCard value
    func sizeScale(topCard: Int, index: Int) -> CGFloat {
        let position = whereAmI(topCard: topCard, index: index)
        return scale(inputMin: 0.0, inputMax: 4.0, outputMin: 0.7, outputMax: 1, value: CGFloat(4 - position))
    }

    // For a given card and topCard card determine where it is in the stack
    func whereAmI(topCard: Int, index: Int) -> Int {
        let order = whatsTheOrder(topCard: topCard)
        let position = order.firstIndex(of: index)
        return position!
    }

    // For a given topCard, figure out the order of the stack
    func whatsTheOrder(topCard: Int) -> [Int] {
        switch topCard {
        case 1:
            return [1, 2, 3, 4]
        case 2:
            return [2, 3, 4, 1]
        case 3:
            return [3, 4, 1, 2]
        case 4:
            return [4, 1, 2, 3]
        default:
            print("Order failed")
            return [0, 0, 0, 0]
        }
    }

    var drag: some Gesture {
        return DragGesture()
            .onChanged { gesture in
                dragTranslation.height = gesture.translation.height + CardHelper.startingOffset
            }
            .onEnded { gesture in
                let predictedEndTranslation: Double = gesture.predictedEndTranslation.height
                let velocity = abs(predictedEndTranslation - gesture.translation.height) / 1500
                var shouldRotate: Bool
                if velocity > 0.01 {
                    shouldRotate = true
                } else {
                    shouldRotate = false
                }

                if predictedEndTranslation <= -250 {
                    if topCard < 4 {
                        topCard += 1
                    } else {
                        topCard = 1
                    }

                    // Animate up to the peak
                    if shouldRotate {
                        withAnimation(.easeOut(duration: CardHelper.delay)) {
                            dragTranslation.height = locationScale(value: 1 - velocity)
                            rotation -= rotationalScale(value: velocity) * 180
                        }
                    }

                    // At the peak, update the z index
                    DispatchQueue.main.asyncAfter(deadline: shouldRotate ? .now() + CardHelper.delay : .now()) {
                        zIndex -= 1
                    }

                    // Animate down the the resting state
                    withAnimation(.spring().delay(shouldRotate ? CardHelper.delay : 0)) {
                        dragTranslation.height = CardHelper.startingOffset
                        rotation -= shouldRotate ? rotationalScale(value: velocity) * 180 : 0
                    }
                } else {
                    withAnimation(.spring()) {
                        dragTranslation.height = CardHelper.startingOffset
                    }
                }
            }
    }

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Circle()
                        .fill(color)
                        .frame(width: 44, height: 44)

                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(color)
                            .frame(width: 100, height: 16)
                        RoundedRectangle(cornerRadius: 12)
                            .fill(color)
                            .frame(width: 60, height: 16)
                    }
                    Spacer()

                }.padding(30)
                    .brightness(-0.3)
            }
        }
        .frame(width: 320, height: 220, alignment: .center)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .rotationEffect(.degrees(rotation))
        .scaleEffect(sizeScale(topCard: topCard, index: index))
        .position(x: UIScreen.main.bounds.width / 2, y: dragTranslation.height)
        .zIndex(zIndex)
        .offset(y: offsetScale(topCard: topCard, index: index))
        .animation(.spring(), value: topCard)
        .gesture(drag)
        .allowsHitTesting(topCard == index)
    }
}
