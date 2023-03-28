//
//  InsertCard.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct ICHelper {
    // Similar to D3.LinearScale
    static func scale(minRange: CGFloat, maxRange: CGFloat, minDomain: CGFloat, maxDomain: CGFloat, value: CGFloat) -> CGFloat {
        return minDomain + (maxDomain - minDomain) * (value - minRange) / (maxRange - minRange)
    }
}

struct InsertCard: View {
    @State private var offset = CGPoint.zero
    @State private var cardScale: CGFloat = 1
    @State private var cardDrop: CGFloat = 0
    @State private var showOverlay: Bool = false
    @State private var dropisReady: Bool = false
    var width: CGFloat = 320
    var height: CGFloat = 250
    var intensity: CGFloat = 10
    var body: some View {
        CommonContainer {
            ZStack {
                Color(.black).ignoresSafeArea()

                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(dropisReady ? Color("ic-yellow") : .white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .frame(width: width - 10, height: 24)
                    .offset(y: 110)

                RoundedRectangle(cornerRadius: 2)
                    .fill(.black)
                    .frame(width: width - 32, height: 4)
                    .offset(y: 110)
                    .animation(.linear(duration: 0.4), value: dropisReady)

                Image("ic-cardbg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                    .rotation3DEffect(.degrees(offset.y), axis: (x: 1, y: 0, z: 0))
                    .animation(.easeOut(duration: 0.2), value: offset.y)
                    .animation(.easeOut(duration: 0.2), value: offset.x)

                    .gesture(
                        DragGesture(minimumDistance: 0.0)
                            .onChanged { event in

                                let normalizedY = ICHelper.scale(minRange: 0, maxRange: height, minDomain: intensity, maxDomain: -intensity, value: event.location.y)

                                if normalizedY < -16 {
                                    offset = CGPoint(x: 0, y: -30)
                                    withAnimation {
                                        dropisReady = true
                                    }

                                } else {
                                    offset = CGPoint(x: 0, y: normalizedY)
                                    dropisReady = false
                                }
                            }
                            .onEnded { _ in
                                print(offset.y)
                                if offset.y >= -20 {
                                    offset.y = 0
                                } else {
                                    showOverlay = true
                                    withAnimation {
                                        cardScale = 0.65
                                        cardDrop = 310
                                        dropisReady = false
                                    }
                                }
                            }

                    ).offset(y: cardDrop)
                    .scaleEffect(cardScale)
                    .animation(.linear(duration: 3), value: cardDrop)
                    .animation(.linear(duration: 3), value: cardScale)

                if showOverlay {
                    ZStack {
                        Color(.black)

                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(dropisReady ? Color("ic-yellow") : .white.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .frame(width: width - 10, height: 24)
                            .offset(y: -165)

                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(.black).opacity(1))
                            .frame(width: width - 32, height: 4)
                            .offset(y: -165)
                            .animation(.linear(duration: 0.4), value: dropisReady)

                    }.frame(width: UIScreen.main.bounds.width, height: 330).clipped()
                        .offset(y: 275)
                        .onTapGesture {
                            cardDrop = 0
                            cardScale = 1
                            dropisReady = false
                            showOverlay = false
                            offset = CGPoint.zero
                        }
                }

                RoundedRectangle(cornerRadius: 0)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("ic-yellow").opacity(0.8), Color("ic-yellow").opacity(0.0)]), startPoint: .bottom, endPoint: .top))
                    .frame(width: width, height: 100)
                    .rotation3DEffect(.degrees(-48), axis: (x: 1, y: 0, z: 0))
                    .offset(y: 84)
                    .blur(radius: 6)
                    .opacity(dropisReady ? 1 : 0)
                    .animation(.linear(duration: 3), value: cardDrop)
                    .animation(.linear(duration: 0.14), value: dropisReady)

            }.statusBar(hidden: true)
        }
    }
}

struct InsertCard_Previews: PreviewProvider {
    static var previews: some View {
        InsertCard()
    }
}
