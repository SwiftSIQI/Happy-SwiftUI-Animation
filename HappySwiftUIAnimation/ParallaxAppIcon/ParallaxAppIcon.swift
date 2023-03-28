//
//  ParallaxAppIcon.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import CoreMotion
import SwiftUI

var randomSizes = (1...600).map { _ in Double.random(in: 0.3...2) }
var randomLocations = (1...600).map { _ in Double.random(in: -1...1) }

enum Icon {
    case moon, quickCapture, egg, sunset, none
}

let outterPadding = 30
let innerPadding = 20
let iconSize = 62
let rWidth = Int(UIScreen.main.bounds.size.width) - (outterPadding * 2)
let startX = (iconSize / 2) + outterPadding + innerPadding
let spacing = (rWidth - (2 * innerPadding + 4 * iconSize)) / 3 + iconSize

struct ParallaxAppIcon: View {
    @State var pitch: Double = 0.0
    @State var roll: Double = 0.0
    @State var yaw: Double = 0.0
    @State var factor = 4.0
    @State var isZoomed = false
    @State var selected: Icon = .none

    func getIconPosition(selected: Icon, index: Icon, offset: Int) -> CGPoint {
        if selected == index {
            return CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 50)
        } else if selected == .none {
            return CGPoint(x: Double(offset), y: UIScreen.main.bounds.height - 120.0)
        } else {
            return CGPoint(x: Double(offset), y: UIScreen.main.bounds.height + 120.0)
        }
    }

    let manager = CMMotionManager()

    var body: some View {
        CommonContainer {
            ZStack {
                Color(.black).ignoresSafeArea()
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .frame(width: CGFloat(rWidth), height: 96)
                    .position(x: UIScreen.main.bounds.width / 2, y: isZoomed ? UIScreen.main.bounds.height + 120 : UIScreen.main.bounds.height - 120)
                    .foregroundColor(Color(.white))
                    .opacity(0.1)
                ZStack {
                    Moon(roll: roll, pitch: pitch, factor: factor, isZoomed: $isZoomed, selected: $selected)
                        .position(getIconPosition(selected: selected, index: Icon.moon, offset: startX))
                    QuickCapture(roll: roll, pitch: pitch, factor: factor, isZoomed: $isZoomed, selected: $selected)
                        .position(getIconPosition(selected: selected, index: Icon.quickCapture, offset: startX + spacing))
                    Egg(roll: roll, pitch: pitch, factor: factor, isZoomed: $isZoomed, selected: $selected)
                        .position(getIconPosition(selected: selected, index: Icon.egg, offset: startX + 2 * spacing))
                    Sunset(roll: roll, pitch: pitch, factor: factor, isZoomed: $isZoomed, selected: $selected)
                        .position(getIconPosition(selected: selected, index: Icon.sunset, offset: startX + 3 * spacing))
                }
            }.statusBarHidden()
                .onAppear {
                    manager.startDeviceMotionUpdates(to: .main) { motionData, _ in
                        pitch = motionData!.attitude.pitch
                        roll = motionData!.attitude.roll
                        yaw = motionData!.attitude.yaw
                    }
                }
        }
    }
}

struct Sunset: View {
    let roll: Double
    let pitch: Double
    let factor: Double
    @State var isShrunk = true
    @Binding var isZoomed: Bool
    @Binding var selected: Icon

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 90, style: .continuous)
                .fill(.black)
                .offset(x: CGFloat(roll * factor * 0), y: CGFloat(pitch * factor * 1))
                .animation(.linear(duration: 0.1), value: pitch)
            Image("pa-sunset")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 344)
                .offset(x: CGFloat(0 + (roll * factor * 28)), y: 0)

            Image("pa-santorini")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 700)
                .offset(x: -30 + CGFloat(roll * factor * 4), y: 180 + CGFloat(pitch * factor * 1))

        }.frame(width: 344, height: 344)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 90, style: .continuous))
            .scaleEffect(isShrunk ? 0.18 : 1)
            .zIndex(isShrunk ? 0 : 1)
            .onTapGesture {
                withAnimation(.spring()) {
                    isShrunk.toggle()
                    if isShrunk {
                        selected = Icon.none
                        isZoomed = false
                    } else {
                        selected = Icon.sunset
                        isZoomed = true
                    }
                }
            }
    }
}

struct Egg: View {
    let roll: Double
    let pitch: Double
    let factor: Double
    @State var isShrunk = true
    @Binding var isZoomed: Bool
    @Binding var selected: Icon

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 90, style: .continuous)
                .fill(.white)
                .offset(x: CGFloat(roll * factor * 0), y: CGFloat(pitch * factor * 0))
                .animation(.linear(duration: 0.1), value: pitch)
            Image("pa-pan")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 330)
                .offset(x: CGFloat(-38 + (roll * factor * 20)), y: -20 + CGFloat(pitch * factor * 20))

            ZStack {
                Image("pa-eggwhite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140)
                    .offset(x: 0, y: 0)
                    .rotationEffect(.degrees(30))

                Image("pa-eggyoke")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 59)
                    .offset(x: 20, y: -20)
                    .scaleEffect(0.8)
                    .rotationEffect(.degrees(90))
                    .offset(x: CGFloat(-(roll * factor * 4)), y: CGFloat(pitch * factor * 4))
            }.offset(x: CGFloat(-(roll * factor * 12)), y: CGFloat(pitch * factor * 12))
        }.frame(width: 344, height: 344)
            .clipShape(RoundedRectangle(cornerRadius: 90, style: .continuous))
            .scaleEffect(isShrunk ? 0.18 : 1)
            .zIndex(isShrunk ? 0 : 1)
            .onTapGesture {
                withAnimation(.spring()) {
                    isShrunk.toggle()
                    if isShrunk {
                        selected = Icon.none
                        isZoomed = false
                    } else {
                        selected = Icon.egg
                        isZoomed = true
                    }
                }
            }
    }
}

struct QuickCapture: View {
    let roll: Double
    let pitch: Double
    let factor: Double
    @State var isShrunk = true
    @Binding var isZoomed: Bool
    @Binding var selected: Icon
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 90, style: .continuous)
                .fill(.white)
                .frame(width: 344, height: 344)
                .offset(x: CGFloat(roll * factor * 0), y: CGFloat(pitch * factor * 0))
                .animation(.linear(duration: 0.1), value: pitch)

            Circle()
                .fill(Color("pa-red3"))
                .brightness(-0.1)
                .saturation(1.3)
                .frame(width: 305, height: 305)
                .offset(x: CGFloat(roll * factor * 1), y: CGFloat(pitch * factor * 1))
                .animation(.linear(duration: 0.1), value: pitch)
            Circle()
                .fill(Color("pa-red3"))
                .frame(width: 305, height: 305)
                .offset(x: CGFloat(roll * factor * 2), y: CGFloat(pitch * factor * 2))
                .animation(.linear(duration: 0.1), value: pitch)

            Circle()
                .fill(Color("pa-red2"))
                .brightness(-0.1)
                .saturation(1.3)
                .frame(width: 250, height: 250)
                .offset(x: CGFloat(roll * factor * 6), y: CGFloat(pitch * factor * 6))
                .animation(.linear(duration: 0.1), value: pitch)

            Circle()
                .fill(Color("pa-red2"))
                .frame(width: 250, height: 250)
                .offset(x: CGFloat(roll * factor * 8), y: CGFloat(pitch * factor * 8))
                .animation(.linear(duration: 0.1), value: pitch)

            Circle()
                .fill(Color("pa-red").opacity(1))
                .brightness(-0.1)
                .saturation(1.0)
                .frame(width: 191, height: 191)
                .offset(x: CGFloat(roll * factor * 13), y: CGFloat(pitch * factor * 13))
                .animation(.linear(duration: 0.1), value: pitch)
                .blur(radius: 0)

            Circle()
                .fill(Color("pa-red").opacity(1))
                .frame(width: 191, height: 191)
                .offset(x: CGFloat(roll * factor * 16), y: CGFloat(pitch * factor * 16))
                .animation(.linear(duration: 0.1), value: pitch)

            Image("pa-bolt-red")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .saturation(1.1)
                .frame(width: 141.42)
                .offset(x: CGFloat(roll * factor * 16), y: CGFloat(20 + pitch * factor * 16))
                .animation(.linear(duration: 0.1), value: pitch)
                .blur(radius: 2)

            Image("pa-bolt")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 141.42)
                .offset(x: CGFloat(roll * factor * 24), y: CGFloat(20 + pitch * factor * 24))
                .animation(.linear(duration: 0.1), value: pitch)
        }.scaleEffect(isShrunk ? 0.18 : 1)
            .zIndex(isShrunk ? 0 : 1)
            .onTapGesture {
                withAnimation(.spring()) {
                    isShrunk.toggle()
                    if isShrunk {
                        selected = Icon.none
                        isZoomed = false
                    } else {
                        selected = Icon.quickCapture
                        isZoomed = true
                    }
                }
            }
    }
}

struct Moon: View {
    let roll: Double
    let pitch: Double
    let factor: Double
    @State var isShrunk = true
    @Binding var isZoomed: Bool
    @Binding var selected: Icon

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 90, style: .continuous)
                .fill(LinearGradient(gradient: Gradient(colors: [Color("pa-purple2"), Color("pa-purple1")]), startPoint: .top, endPoint: .bottom))
                .frame(width: 344, height: 344)
                .offset(x: CGFloat(roll * factor * 0), y: CGFloat(pitch * factor * 0))
                .animation(.linear(duration: 0.1), value: pitch)

        }.overlay {
            ZStack {
                ZStack {
                    ForEach(1...50, id: \.self) { value in
                        Circle()
                            .fill(Color("pa-purple2"))
                            .brightness(0.3)
                            .frame(width: randomSizes[value] * 3, height: randomSizes[value] * 3)
                            .offset(x: CGFloat(roll * randomSizes[value + 1] * 50) + Double(randomLocations[value] * 300), y: Double(randomLocations[value + 2]) * 200)
                    }

                    ForEach(1...50, id: \.self) { value in
                        Circle()
                            .fill(Color("pa-purple2"))
                            .brightness(0.8)
                            .frame(width: randomSizes[value] * 3, height: randomSizes[value] * 3)
                            .offset(x: CGFloat(roll * randomSizes[value] * 50) + Double(randomLocations[value] * 300), y: Double(randomLocations[value + 1]) * 200)
                    }
                }

                ZStack {
                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 30, height: 30)
                        .offset(x: CGFloat(roll * 10) + -120, y: -120)

                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 18, height: 18)
                        .offset(x: CGFloat(roll * 15) + -44, y: -138)

                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 14, height: 14)
                        .offset(x: CGFloat(roll * 20) + 52, y: -144)

                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 24, height: 24)
                        .offset(x: CGFloat(roll * 20) + 120, y: -120)

                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 16, height: 16)
                        .offset(x: CGFloat(roll * 14) + 140, y: -48)

                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 12, height: 12)
                        .offset(x: CGFloat(roll * 25) + 144, y: 44)
                }

                ZStack {
                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 30, height: 30)
                        .offset(x: CGFloat(roll * 14) + 124, y: 124)

                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 14, height: 14)
                        .offset(x: CGFloat(roll * 20) + 40, y: 143)

                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 8, height: 8)
                        .offset(x: CGFloat(roll * 30) + -40, y: 140)

                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 32, height: 32)
                        .offset(x: CGFloat(roll * 20) + -110, y: 120)
                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 20, height: 20)
                        .offset(x: CGFloat(roll * 10) + -138, y: -40)
                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 20, height: 20)
                        .offset(x: CGFloat(roll * 39) + -140, y: 42)

                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 20, height: 20)
                        .offset(x: CGFloat(roll * 10) + -80, y: -80)

                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 20, height: 20)
                        .offset(x: CGFloat(roll * 3) + 80, y: 80)
                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 20, height: 20)
                        .offset(x: CGFloat(roll * 14) + -80, y: 80)
                    Circle()
                        .fill(Color(.white))
                        .shadow(color: Color.white, radius: 4)
                        .frame(width: 20, height: 20)
                        .offset(x: CGFloat(roll * 20) + 80, y: -80)
                }.offset(x: CGFloat(roll * 14), y: CGFloat(pitch * 14))

                ZStack {
                    Rectangle()
                        .fill(Color(.white))
                        .frame(width: 250, height: 250)
                    Circle()
                        .fill(Color("pa-purple2").opacity(0.1))
                        .frame(width: 140, height: 140)
                        .offset(x: -110, y: -110)

                    Circle()
                        .fill(Color("pa-purple2").opacity(0.1))
                        .frame(width: 80, height: 80)
                        .offset(x: 50, y: -90)

                    Circle()
                        .fill(Color("pa-purple2").opacity(0.1))
                        .frame(width: 50, height: 50)
                        .offset(x: 80, y: -4)

                    Circle()
                        .fill(Color("pa-purple2").opacity(0.1))
                        .frame(width: 40, height: 40)
                        .offset(x: 0, y: -30)

                    Circle()
                        .fill(Color("pa-purple2").opacity(0.1))
                        .frame(width: 170, height: 170)
                        .offset(x: -110, y: 70)

                    Circle()
                        .fill(Color("pa-purple2").opacity(0.1))
                        .frame(width: 170, height: 170)
                        .offset(x: 80, y: 170)

                    Circle()
                        .fill(Color("pa-purple2").opacity(0.1))
                        .frame(width: 60, height: 60)
                        .offset(x: 30, y: 50)
                }
                .background(.white)
                .clipShape(Circle())
                .shadow(color: Color.white, radius: 8)
                .frame(width: 305, height: 305)
                .offset(x: CGFloat(roll * factor * 1), y: CGFloat(pitch * factor * 1))
                .animation(.linear(duration: 0.1), value: pitch)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 90, style: .continuous))
        .scaleEffect(isShrunk ? 0.18 : 1)
        .zIndex(isShrunk ? 0 : 1)
        .onTapGesture {
            withAnimation(.spring()) {
                isShrunk.toggle()
                if isShrunk {
                    selected = Icon.none
                    isZoomed = false
                } else {
                    selected = Icon.moon
                    isZoomed = true
                }
            }
        }
    }
}

struct ParallaxAppIcon_Previews: PreviewProvider {
    static var previews: some View {
        ParallaxAppIcon()
    }
}
