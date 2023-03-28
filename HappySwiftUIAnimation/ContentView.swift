//
//  ContentView.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section("位移类动画") {
                    NavigationLink(destination: HalfSheetTrans()) { Text("驶向灵动岛") }
                    NavigationLink(destination: RolloutMenu()) { Text("滚动的按钮") }
                    NavigationLink(destination: SpringboardZoom()) { Text("Q 弹的界面") }
                }
                Section("缩放类动画") {
                    NavigationLink(destination: Magnification()) { Text("iOS Deck") }
                    NavigationLink(destination: FidgetText()) { Text("跳动的字体") }
                    NavigationLink(destination: ClothGrid()) { Text("柔软的视图") }
                    NavigationLink(destination: DynamicTouch()) { Text("闪烁的屏幕") }
                    NavigationLink(destination: DynamicGrid()) { Text("缩放+位移") }
                }
                Section("手势驱动型动画") {
                    NavigationLink(destination: Boomerang()) { Text("旋转的卡片") }
                    NavigationLink(destination: PantoneSpread()) { Text("展开色卡") }
                    NavigationLink(destination: RadialDial()) { Text("旋转按钮") }
                }
                Section("形变动画") {
                    NavigationLink(destination: InsertCard()) { Text("消失的卡片") }
                    NavigationLink(destination: TransformPlayground()) { Text("一个示例搞清 3D 变形") }
                    NavigationLink(destination: EasingShadow()) { Text("阴影与变形") }
                }
                Section("Phyllotaxis") {
                    NavigationLink(destination: PhyllotaxisColorPicker()) { Text("神奇的数学图案") }
                    NavigationLink(destination: PhyllotaxisPlayground()) { Text("一个示例搞清 Phyllotaxis") }
                }
                Section("善用 Core Image") {
                    NavigationLink(destination: CoreImg()) { Text("神奇屏保") }
                }
                Section("好用的 SpriteKit") {
                    NavigationLink(destination: DynamicEmoji()) { Text("调皮的 Emoji") }
                    NavigationLink(destination: LightLeak()) { Text("漏光的卡片") }
                }
                Section("有趣的 Core Motion") {
                    NavigationLink(destination: AnisotropicButton()) { Text("灵动的按钮") }
                    NavigationLink(destination: ParallaxAppIcon()) { Text("晃动的 icon") }
                }
            }
            .navigationTitle("Menu")
        }
//        .preferredColorScheme(.light)
        .accentColor(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
