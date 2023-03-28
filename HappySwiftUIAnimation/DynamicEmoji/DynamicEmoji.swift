//
//  DynamicEmoji.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SpriteKit
import SwiftUI

struct ConfettiEffect: GeometryEffect {
    var value: Double

    var animatableData: Double {
        get { value }
        set { value = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let value = 1.0-(cos(2*value*Double.pi) + 1) / 2
        let translation = CGFloat(20*value)
        let scaleFactor = CGFloat(1 + 1*value)

        let affineTransform = CGAffineTransform(translationX: size.width*0.5, y: size.height*0.5)
            .translatedBy(x: -size.width*0.5 + translation, y: -size.height*0.5-translation*3)
            .scaledBy(x: scaleFactor, y: scaleFactor)

        return ProjectionTransform(affineTransform)
    }
}

struct DynamicEmoji: View {
    @State var smoke = false
    @State var confetti = false
    @State var count = 0.0
    @State var eyes = false
    @State var sparkler = false
    
    let centerX = UIScreen.main.bounds.size.width / 2
    let spacing = 200
    let startY = 200

    var body: some View {
        CommonContainer {
            ZStack {
                Color.black.ignoresSafeArea()
                ZStack {
                    ZStack {
                        if smoke {
                            SpriteView(scene: Smoke(), options: [.allowsTransparency])

                            SpriteView(scene: Embers(), options: [.allowsTransparency])
                        }

                        Text("🔥")
                            .offset(y: -35)
                            .font(.system(size: 44.0))
                            .scaleEffect(smoke ? 1.4 : 1.0)
                            .animation(.spring(), value: smoke)

                    }.onTapGesture {
                        smoke.toggle()
                    }.position(x: centerX , y: CGFloat(startY))

                    ZStack {
                        if eyes {
                            SpriteView(scene: Eyes(), options: [.allowsTransparency])
                        }

                        Text("👀")
                            .offset(y: -35)
                            .font(.system(size: 44.0))
                            .scaleEffect(eyes ? 1.4 : 1.0)
                            .animation(.spring(), value: eyes)
                            .onTapGesture {
                                eyes.toggle()
                            }

                    }.position(x: centerX , y: CGFloat(startY + spacing))

                    ZStack {
                        if sparkler {
                            SpriteView(scene: Sparkler(), options: [.allowsTransparency])
                            SpriteView(scene: Starkler(), options: [.allowsTransparency])
                        }

                        Text("🎂")
                            .offset(y: -40)
                            .font(.system(size: 44.0))
                            .scaleEffect(sparkler ? 1.4 : 1.0)
                            .animation(.spring(), value: sparkler)
                            .onTapGesture {
                                sparkler.toggle()
                            }

                    }.position(x: centerX , y: CGFloat(startY + spacing * 2))

                    ZStack {
                        ZStack {
                            ForEach(0 ... Int(count), id: \.self) { _ in
                                SpriteView(scene: Confetti(), options: [.allowsTransparency])
                                    .offset(x: 12, y: -4)
                                SpriteView(scene: Confetti2(), options: [.allowsTransparency])
                                    .offset(x: 12, y: -4)
                                SpriteView(scene: Confetti3(), options: [.allowsTransparency])
                                    .offset(x: 12, y: -4)
                                SpriteView(scene: Confetti4(), options: [.allowsTransparency])
                                    .offset(x: 12, y: -4)
                            }
                        }.allowsHitTesting(false)
                            .zIndex(-1)

                        Text("🎉")
                            .offset(y: -35)
                            .font(.system(size: 44.0))
                            .modifier(ConfettiEffect(value: count))
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    count += 1
                                }
                            }

                    }.position(x: centerX, y: CGFloat(startY + spacing * 3))
                }
            }

        }
        
    }
}

class Smoke: SKScene {
    override func sceneDidLoad() {
        size = CGSize(width: 50, height: 100)
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 0.55)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "Smoke.sks")!
        node.particlePositionRange.dx = 20
        addChild(node)
    }
}

class Embers: SKScene {
    override func sceneDidLoad() {
        size = CGSize(width: 50, height: 100)
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 0.55)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "Embers.sks")!
        node.particlePositionRange.dx = 25
        addChild(node)
    }
}

class Confetti: SKScene {
    override func sceneDidLoad() {
        size = CGSize(width: 50, height: 100)
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 0.55)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "Confetti.sks")!
        node.particlePositionRange.dx = 25
        addChild(node)
    }
}

class Confetti2: SKScene {
    override func sceneDidLoad() {
        size = CGSize(width: 50, height: 100)
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 0.55)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "Confetti2.sks")!
        node.particlePositionRange.dx = 25
        addChild(node)
    }
}

class Confetti3: SKScene {
    override func sceneDidLoad() {
        size = CGSize(width: 50, height: 100)
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 0.55)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "Confetti3.sks")!
        node.particlePositionRange.dx = 25
        addChild(node)
    }
}

class Confetti4: SKScene {
    override func sceneDidLoad() {
        size = CGSize(width: 50, height: 100)
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 0.55)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "Confetti4.sks")!
        node.particlePositionRange.dx = 25
        addChild(node)
    }
}

class Eyes: SKScene {
    override func sceneDidLoad() {
        size = CGSize(width: 50, height: 100)
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 0.55)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "Eyes.sks")!
        node.particlePositionRange.dx = 25
        addChild(node)
    }
}

class Sparkler: SKScene {
    override func sceneDidLoad() {
        size = CGSize(width: 70, height: 100)
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 0.59)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "Sparkler.sks")!
        node.particlePositionRange.dx = 30
        addChild(node)
    }
}

class Starkler: SKScene {
    override func sceneDidLoad() {
        size = CGSize(width: 70, height: 100)
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 0.59)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "Starkler.sks")!
        node.particlePositionRange.dx = 30
        addChild(node)
    }
}

struct DynamicEmoji_Previews: PreviewProvider {
    static var previews: some View {
        DynamicEmoji()
    }
}
