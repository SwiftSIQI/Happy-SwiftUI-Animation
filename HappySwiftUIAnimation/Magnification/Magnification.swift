//
//  Magnification.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct Magnification: View {
    let images: [String] = ["m-1pass", "m-quickcapture", "m-camera", "m-messages", "m-photos", "m-maps", "m-ia", "m-fantastical", "m-things"]
    
    @State private var dragX: Int = 0
    @State private var isDragging: Bool = false
    var body: some View {
        CommonContainer{
            VStack {
                Color.white.ignoresSafeArea()
                ZStack {
                    ZStack {}.frame(width: 350, height: 70)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    isDragging = true
                                    if dragX != Int(linearScale(minRange: 0, maxRange: 340, minDomain: 0, maxDomain: 9, value: value.location.x)) {
                                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                        impactMed.impactOccurred()
                                        dragX = Int(linearScale(minRange: 0, maxRange: 340, minDomain: 0, maxDomain: 9, value: value.location.x))
                                    }
                                }
                                .onEnded { _ in
                                    dragX = 0
                                    isDragging = false
                                }
                        )
                    
                    HStack {
                        ForEach(0 ... 8, id: \.self) { number in
                            Image(images[number])
                                .resizable()
                                .frame(width: isDragging ? rescale(position: number, dragPosition: Int(dragX)) : 26, height: isDragging ? rescale(position: number, dragPosition: Int(dragX)) : 26)
                                .clipShape(RoundedRectangle(cornerRadius: isDragging ? reRadius(position: number, dragPosition: Int(dragX)) : 8, style: .continuous))
                                .animation(.interpolatingSpring(mass: 1, stiffness: 200, damping: 40, initialVelocity: 8), value: dragX)
                                .offset(y: isDragging ? reTranslate(position: number, dragPosition: Int(dragX)) : 0)
                        }
                    }.allowsHitTesting(false)
                }
            }
            .padding()

        }
    }

    func rescale(position: Int, dragPosition: Int) -> CGFloat {
        if position == dragPosition {
            return 68
        } else if position == dragPosition - 1 || position == dragPosition + 1 {
            if dragPosition == 7 || dragPosition == 1 {
                return 44
            } else if dragPosition == 8 || dragPosition == 0 {
                return 52
            } else {
                return 40
            }
        } else if position == dragPosition - 2 || position == dragPosition + 2 {
            return 22
        } else if position == dragPosition - 3 || position == dragPosition + 3 {
            if dragPosition == 7 || dragPosition == 1 {
                return 18
            } else if dragPosition == 8 || dragPosition == 0 {
                return 20
            } else {
                return 16
            }
        } else {
            if dragPosition == 7 || dragPosition == 1 {
                return 14
            } else if dragPosition == 8 || dragPosition == 0 {
                return 18
            } else {
                return 12
            }
        }
    }
    
    func reRadius(position: Int, dragPosition: Int) -> CGFloat {
        if position == dragPosition {
            return 18
        } else if position == dragPosition - 1 || position == dragPosition + 1 {
            return 12
        } else if position == dragPosition - 2 || position == dragPosition + 2 {
            return 8
        } else if position == dragPosition - 3 || position == dragPosition + 3 {
            return 6
        } else {
            return 4
        }
    }
    
    func reTranslate(position: Int, dragPosition: Int) -> CGFloat {
        if position == dragPosition {
            return -18
        } else if position == dragPosition - 1 || position == dragPosition + 1 {
            return -10
        } else if position == dragPosition - 2 || position == dragPosition + 2 {
            return -4
        } else if position == dragPosition - 3 || position == dragPosition + 3 {
            return -2
        } else {
            return 0
        }
    }
    
    func divergingScale(minRange: CGFloat, midRange: CGFloat, maxRange: CGFloat, minDomain: CGFloat, midDomain: CGFloat, maxDomain: CGFloat, value: CGFloat) -> CGFloat {
        if value < midRange {
            return minDomain + (midDomain - minDomain) * (value - minRange) / (maxRange - minRange)
        } else {
            return minDomain + (midDomain - minDomain) * (value - minRange) / (maxRange - minRange)
        }
    }
    
    func linearScale(minRange: CGFloat, maxRange: CGFloat, minDomain: CGFloat, maxDomain: CGFloat, value: CGFloat) -> CGFloat {
        return minDomain + (maxDomain - minDomain) * (value - minRange) / (maxRange - minRange)
    }
}

struct Magnification_Previews: PreviewProvider {
    static var previews: some View {
        Magnification()
    }
}
