//
//  SpringboardZoom.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct SpringboardZoom: View {
    @State var level = 1
    @State var ascending = true
    @State var scaleEffect = 1.0
    @State private var dragCoords = CGPoint.zero
    @State private var dragX: Int = 0
    @State private var dragY: Int = 0
    @State private var isDragging: Bool = false
    
    var cellCounter = 0
    
    var scale = [
        1: 1.0,
        2: 0.75,
        3: 0.60
    ]
    
    var size = [
        1: 60.0,
        2: 42.0,
        3: 35.0
    ]
    
    var radius = [
        1: 14.0,
        2: 12.0,
        3: 10.0
    ]
    
    var xOffset = [
        1: -100.0,
        2: -50.0,
        3: -25.0,
        4: 0.0,
        5: 0.0,
        6: 25.0,
        7: 50.0,
        8: 100.0
    ]
    
    var yOffset = [
        1: -200.0,
        2: -150.0,
        3: -100.0,
        4: -50.0,
        5: -0.0,
        6: -0.0,
        7: -0.0,
        8: -0.0,
        9: 0.0,
        10: 0.0,
        11: 0.0,
        12: 0.0,
        13: 50.0,
        14: 100.0,
        15: 150.0,
        16: 200.0
    ]
    
    var staggerY = [
        1: 8.0,
        2: 7.0,
        3: 6.0,
        4: 5.0,
        5: 4.0,
        6: 3.0,
        7: 2.0,
        8: 1.0,
        9: 1.0,
        10: 2.0,
        11: 3.0,
        12: 4.0,
        13: 5.0,
        14: 6.0,
        15: 7.0,
        16: 8.0
    ]
    
    var staggerX = [
        1: 4.0,
        2: 3.0,
        3: 2.0,
        4: 1.0,
        5: 0.5,
        6: 2.0,
        7: 3.0,
        8: 4.0
    ]
    
    var hSpacing = [
        1: 30.0,
        2: 20.0,
        3: 10.0
    ]
    
    var vSpacing = [
        1: 30.0,
        2: 20.0,
        3: 10.0
    ]
    
    var lowerRowBounds = [
        1: 4,
        2: 2,
        3: 0
    ]
    
    var upperRowBounds = [
        1: 12,
        2: 14,
        3: 16
    ]
    
    var lowerCellBounds = [
        1: 3,
        2: 2,
        3: 1
    ]
    
    var upperCellBounds = [
        1: 6,
        2: 7,
        3: 8
    ]
    
    func getVisibility(row: Int, cell: Int, level: Int) -> Bool {
        var visibility = false
        if row <= lowerRowBounds[level]! || row > upperRowBounds[level]! {
            visibility = false
        } else {
            if cell < lowerCellBounds[level]! || cell > upperCellBounds[level]! {
                visibility = false
            } else {
                visibility = true
            }
        }
        return visibility
    }
    
    func dragScale(row: Int, cell: Int) -> Double {
        var scaled = 0.4
        
        if row == 1 && cell == 0 {
            return scaled
        }
       
        if row == dragY && cell == dragX {
            scaled = 1.9
        }
        
        if row == dragY + 1 && cell == dragX {
            scaled = 1.1
        }
        
        if row == dragY - 1 && cell == dragX {
            scaled = 1.1
        }
        
        if row == dragY && cell == dragX + 1 {
            scaled = 1.1
        }
        
        if row == dragY && cell == dragX - 1 {
            scaled = 1.1
        }
        
        if row == dragY + 1 && cell == dragX + 1 {
            scaled = 0.9
        }
        
        if row == dragY - 1 && cell == dragX + 1 {
            scaled = 0.9
        }
        
        if row == dragY - 1 && cell == dragX - 1 {
            scaled = 0.9
        }
        
        if row == dragY + 1 && cell == dragX - 1 {
            scaled = 0.9
        }
        
        return scaled
    }
    
    func dragOffset(row: Int, cell: Int) -> CGSize {
        var offset: CGSize = .zero
       
        if row == dragY && cell == dragX {
            offset.height = -10
        }
        if row == dragY + 1 && cell == dragX {
            offset.height = 10
        }
        
        if row == dragY - 1 && cell == dragX {
            offset.height = -22
        }
        
        if row == dragY && cell == dragX + 1 {
            offset.width = 10
        }
        
        if row == dragY && cell == dragX - 1 {
            offset.width = -10
        }
        
        if row == dragY + 1 && cell == dragX + 1 {
            offset.width = 3
            offset.height = 3
        }
        
        if row == dragY - 1 && cell == dragX + 1 {
            offset.width = 3
            offset.height = -3
        }
        
        if row == dragY - 1 && cell == dragX - 1 {
            offset.width = -3
            offset.height = -3
        }
        
        if row == dragY + 1 && cell == dragX - 1 {
            offset.width = -3
            offset.height = 3
        }
        
        if row == dragY + 2 && cell == dragX {
            offset.height = 3
        }
        
        if row == dragY - 2 && cell == dragX {
            offset.height = -14
        }
        
        if row == dragY && cell == dragX - 2 {
            offset.width = -3
        }
        
        if row == dragY && cell == dragX + 2 {
            offset.width = 3
        }
        
        return offset
    }

    var drag: some Gesture {
        DragGesture(minimumDistance: 0.1)
            .onChanged { gesture in
                    
                withAnimation(.interpolatingSpring(mass: 1, stiffness: 200, damping: 50, initialVelocity: 10)) {
                    isDragging = true
                    dragX = Int(linearScale(minRange: 0, maxRange: 390, minDomain: 1, maxDomain: 8, value: gesture.location.x))
                    dragY = Int(linearScale(minRange: 0, maxRange: 600, minDomain: 0, maxDomain: 15, value: gesture.location.y))
                }
            }
            .onEnded { _ in
                    
                withAnimation(.spring().delay(1)) {
                    isDragging = false
                    dragX = 100
                    dragY = 100
                }
            }
    }
    
    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { gesture in
                scaleEffect = pow(gesture, 0.05)
                
            }.onEnded { gestureState in
                withAnimation(.interpolatingSpring(mass: 1, stiffness: 200, damping: 20, initialVelocity: 5)) {
                    scaleEffect = 1.0
                }
                    
                if gestureState < 1 {
                    if level < 3 {
                        ascending = true
                        level += 1
                    }
                } else {
                    if level != 1 {
                        ascending = false
                        level -= 1
                    }
                }
            }
    }
    
    var body: some View {
        CommonContainer{
            ZStack{
                Color.black.ignoresSafeArea()
                VStack(spacing: isDragging ? 10 : CGFloat(vSpacing[level]!)) {
                    ForEach(1...16, id: \.self) { row in
                        HStack(spacing: isDragging ? 10 : CGFloat(hSpacing[level]!)) {
                            ForEach(1...8, id: \.self) { cell in
                                VStack {
                                    ZStack {
                                        ZStack {
                                            Image("photo\(getIndex(cell: cell, row: row))")
                                                .resizable()
                                                
                                        }.clipShape(RoundedRectangle(cornerRadius: radius[level]!, style: .continuous))
                                            .scaleEffect(isDragging ? dragScale(row: row, cell: cell) : 1)

                                            .frame(width: size[level]!, height: size[level]!)
                                            .opacity(getVisibility(row: row, cell: cell, level: level) ? 1 : 0)
                                            .offset(x: getVisibility(row: row, cell: cell, level: level) ? 0 : CGFloat(xOffset[cell]!) / 6, y: getVisibility(row: row, cell: cell, level: level) ? 0 : CGFloat(yOffset[row]!) / 6)
                                            .animation(ascending && getVisibility(row: row, cell: cell, level: level) ? .spring().delay((staggerY[row]! + staggerX[cell]!) / 40) : .spring(), value: level)
                                        
                                    }.offset(isDragging ? dragOffset(row: row, cell: cell) : .zero)
                                }
                            }
                        }
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                .scaleEffect(scaleEffect)
//                .preferredColorScheme(.dark)
                
            }.gesture(magnification.simultaneously(with: level == 3 ? drag : nil))
                .statusBar(hidden: true)
        }
        
    }
    
    func linearScale(minRange: CGFloat, maxRange: CGFloat, minDomain: CGFloat, maxDomain: CGFloat, value: CGFloat) -> CGFloat {
        return minDomain + (maxDomain - minDomain) * (value - minRange) / (maxRange - minRange)
    }
    
    func getIndex(cell: Int, row: Int) -> Int {
        return row * 8 + cell
    }
    
    func setZoom(magnification: CGFloat) -> CGFloat {
        return pow(magnification, 0.7)
    }
    
    func getXOffset(x: Int) -> CGFloat {
        return CGFloat(x)
    }
    
    func getYOffset(y: Int) -> CGFloat {
        return CGFloat(y)
    }
}

struct SpringboardZoom_Previews: PreviewProvider {
    static var previews: some View {
        SpringboardZoom()
    }
}
