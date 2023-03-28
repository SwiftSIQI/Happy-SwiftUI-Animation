//
//  AnisotropicButton.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import CoreMotion
import SwiftUI

struct AcRotate: ViewModifier {
    @ObservedObject var manager: MotionManager
    var magnitude: Double

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(CGFloat(manager.yaw * magnitude)))
    }
}

struct AcShadow: ViewModifier {
    @ObservedObject var manager: MotionManager
    var magnitude: Double

    func body(content: Content) -> some View {
        content
            .shadow(color: Color("ab-buttonShadow").opacity(1), radius: CGFloat(8 + (abs(manager.yaw) * magnitude / 2)), x: -CGFloat(manager.yaw * 2 * magnitude), y: CGFloat(24))
    }
}

struct AcHighlight: ViewModifier {
    let width: CGFloat = 6
    let angle = 0
    @ObservedObject var manager: MotionManager
    let finalX = CGFloat(cos(0 - Double.pi / 2))
    let finalY = CGFloat(sin(0 - Double.pi / 2))

    func body(content: Content) -> some View {
        content
            .offset(x: manager.yaw * 2 * -9, y: (abs(manager.yaw) * -3) + 4)
    }
}

class MotionManager: ObservableObject {
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var yaw: Double = 0.0

    private var manager: CMMotionManager

    init() {
        manager = CMMotionManager()
        manager.startDeviceMotionUpdates(to: .main) { motionData, error in
            guard error == nil else {
                print(error!)
                return
            }

            if let motionData = motionData {
                self.pitch = motionData.attitude.pitch
                self.roll = motionData.attitude.roll
                var yawNormalized = motionData.attitude.yaw
                yawNormalized = max(yawNormalized, -0.55)
                yawNormalized = min(yawNormalized, 0.55)
                print(yawNormalized)
                self.yaw = yawNormalized
            }
        }
    }
}

extension View {
    func innerShadow<S: Shape>(using shape: S, angle: Angle = .degrees(0), color: Color = Color("ab-buttonHighlight"), width: CGFloat = 11, blur: CGFloat = 3, manager: MotionManager) -> some View {
        return overlay(
            shape
                .stroke(color, lineWidth: width)
                .modifier(AcHighlight(manager: manager))
                .scaleEffect(x: 1.09, y: 1.18)
                .blur(radius: blur)
                .mask(shape)
        )
    }
}

struct AnisotropicButton: View {
    @ObservedObject var manager = MotionManager()
    @State private var phase: CGFloat = 0

    let radius: CGFloat = 40
    let pi = Double.pi
    let dotCount = 14
    let dotLength: CGFloat = 2
    let spaceLength: CGFloat

    init() {
        let circumerence = CGFloat(2.0 * pi) * radius
        spaceLength = circumerence / CGFloat(dotCount) - dotLength
    }

    var body: some View {
        CommonContainer {
            ZStack {
                ZStack {
                    HStack {
                        Text("Submit").foregroundColor(.primary.opacity(0.8))
                    }.padding(.horizontal, 70)
                        .padding(.vertical, 15)
                        .background(LinearGradient(gradient: Gradient(colors: [Color("ab-buttonTop"), Color("ab-buttonBottom")]), startPoint: .top, endPoint: .bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .scaleEffect(0.9)
                        .modifier(AcShadow(manager: manager, magnitude: 30))

                    HStack {
                        Text("Submit").foregroundColor(.primary.opacity(0.8))
                    }.padding(.horizontal, 70)
                        .padding(.vertical, 15)
                        .background(LinearGradient(gradient: Gradient(colors: [Color("ab-buttonTop"), Color("ab-buttonBottom")]), startPoint: .top, endPoint: .bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .scaleEffect(1)
                        .innerShadow(using: RoundedRectangle(cornerRadius: 30, style: .continuous), manager: manager)

                    VStack {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 40, height: 40)
                                .shadow(color: .white, radius: 10, x: 0, y: 0)
                                .shadow(color: .white, radius: 3, x: 0, y: 0)
                                .shadow(color: .white, radius: 30, x: 0, y: 0)
                                .overlay(
                                    ZStack {
                                        Circle()
                                            .fill(Color("ab-Craters")).scaleEffect(0.3).offset(x: 4, y: -3)
                                        Circle()
                                            .fill(Color("ab-Craters")).scaleEffect(0.2).offset(x: 10, y: 10)
                                        Circle()
                                            .fill(Color("ab-Craters")).scaleEffect(0.2).offset(x: -7, y: 7)
                                        Circle()
                                            .fill(Color("ab-Craters")).scaleEffect(0.2).offset(x: -10, y: -8)
                                    }
                                )
                                .offset(y: -200)

                            Circle()
                                .stroke(Color("ab-Sunbeams").opacity(0.8), style: StrokeStyle(lineWidth: 3, lineCap: .butt, lineJoin: .miter, miterLimit: 0, dash: [dotLength, spaceLength], dashPhase: phase))
                                .frame(width: radius * 2, height: radius * 2)
                                .offset(y: -200)
                                .onAppear {
                                    withAnimation(.linear.repeatForever(autoreverses: false)) {
                                        phase -= dotLength + spaceLength
                                    }
                                }

                        }.frame(width: 400, height: 400)
                            .background(.clear)
                            .modifier(AcRotate(manager: manager, magnitude: 140))
                    }

                }.font(.system(size: 26, weight: .bold, design: .rounded))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(Color("ab-gradientBottom"))
            }
        }
        
    }
}

struct AnisotropicButton_Previews: PreviewProvider {
    static var previews: some View {
        AnisotropicButton()
    }
}
