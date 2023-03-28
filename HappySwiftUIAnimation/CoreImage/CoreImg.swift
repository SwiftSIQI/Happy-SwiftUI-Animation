//
//  CoreImg.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct CoreImg: View {
    @State var isAwake = false
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    @State var userIsPressing = false
    @State private var image: Image?
    @State private var currentFilter = CIFilter.bokehBlur()
    @State private var filterIntensity = 50.0
    let gradientImage = UIImage(named: "gradient")
    let context = CIContext()

    var tap: some Gesture {
        DragGesture(minimumDistance: 0.0)
            .onChanged { _ in
                // when longpressGesture started
                print("started")
                userIsPressing = true
            }
            .onEnded { _ in
                print("ended")
                userIsPressing = false
            }
    }
    
    var body: some View {
        ZStack {
            ZStack {
                image?
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .scaleEffect(1.6)
                    .gesture(
                        tap
                    )
                    .onReceive(timer) { _ in
                        if isAwake {
                            if userIsPressing == true {
                                filterIntensity += 1
                                
                            } else {
                                if filterIntensity > 0.0 {
                                    filterIntensity -= 1
                                }
                            }
                            processing()
                        }
                    }
                
                VStack {
                    Text("11:23").font(.system(size: 88.0, weight: .regular, design: .rounded)).padding(.top, 50).foregroundColor(.black)
                    Text("Friday, June 17th").font(.system(size: 24.0, weight: .semibold, design: .rounded)).foregroundColor(.black)
                    
                    Spacer()
                    HStack {
                        ZStack {
                            Image(systemName: "flashlight.off.fill").font(.title2).foregroundColor(.white)
                                .padding(18)
                        }.background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .onTapGesture {
                                filterIntensity = 50
                                isAwake = false
                            }
                        Spacer()
                        ZStack {
                            Image(systemName: "camera.fill").font(.title3).foregroundColor(.white)
                                .padding(16)
                        }.background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }.frame(width: 320)
                }
                
                Color.black.ignoresSafeArea()
                    .onTapGesture {
                        isAwake = true
                    }.opacity(isAwake ? 0 : 1)
                    .animation(.linear(duration: 0.1), value: isAwake)
            }.onAppear(perform: load)
                .statusBarHidden(true)
        }
        
    }

    // These two functions were pulled from Paul Hudson
    // https://www.hackingwithswift.com/books/ios-swiftui/integrating-core-image-with-swiftui
    func load() {
        guard let inputImage = UIImage(named: "ci-flower") else { return }
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        processing()
    }
    
    func processing() {
        currentFilter.radius = Float(filterIntensity)
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
    }
}

struct CoreImg_Previews: PreviewProvider {
    static var previews: some View {
        CoreImg()
    }
}
