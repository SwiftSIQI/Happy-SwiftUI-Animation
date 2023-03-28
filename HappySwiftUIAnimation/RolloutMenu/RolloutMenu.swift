//
//  RolloutMenuApp.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import SwiftUI

struct RolloutMenu: View {
    @State var isExpanded = false
    @GestureState var isDetectingLongPress = false
    @State var completedLongPress = false
    @State var damping = 0.56
    @State var buttonDamping = 0.68

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($isDetectingLongPress) { currentState, gestureState,
                transaction in
                gestureState = currentState
                transaction.animation = Animation.easeIn(duration: 1.0)
                print(transaction)
            }
    }

    var fastest = 0.0
    var fast = 0.04
    var medium = 0.08
    var slow = 0.12
    var slowest = 0.16

    var returnConstant = 0.0

    var body: some View {
        CommonContainer {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Spacer()
                    ZStack {
                        HStack {
                            ZStack {
                                Image(systemName: "film.fill")
                                    .font(.system(size: 22.0))
                                    .rotationEffect(isExpanded ? .degrees(0) : .degrees(-180))
                                    .blendMode(.plusDarker)
                                    .opacity(0.6)
                            }
                            .frame(width: 48, height: 48)
                            .background(Color("RolloutMenuRed"))
                            .clipShape(Circle())
                            .scaleEffect(isExpanded ? 1 : 0)
                            .animation(.spring(dampingFraction: damping).delay(isExpanded ? fastest : slowest - returnConstant), value: isExpanded)

                            ZStack {
                                Image(systemName: "calendar")
                                    .font(.system(size: 22.0))
                                    .rotationEffect(isExpanded ? .degrees(0) : .degrees(-180))
                                    .blendMode(.plusDarker)
                                    .opacity(0.6)
                            }
                            .frame(width: 48, height: 48)
                            .background(Color("RolloutMenuYellow"))
                            .clipShape(Circle())
                            .scaleEffect(isExpanded ? 1 : 0)
                            .animation(.spring(dampingFraction: damping).delay(isExpanded ? fast : slow - returnConstant), value: isExpanded)

                            ZStack {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 22.0))
                                    .rotationEffect(isExpanded ? .degrees(0) : .degrees(-180))
                                    .blendMode(.plusDarker)
                                    .opacity(0.6)
                            }
                            .frame(width: 48, height: 48)
                            .background(Color("RolloutMenuGreen"))
                            .clipShape(Circle())
                            .scaleEffect(isExpanded ? 1 : 0)
                            .animation(.spring(dampingFraction: damping).delay(isExpanded ? medium : medium - returnConstant), value: isExpanded)

                            ZStack {
                                Image(systemName: "quote.closing")
                                    .font(.system(size: 22.0))
                                    .rotationEffect(isExpanded ? .degrees(0) : .degrees(-180))
                                    .blendMode(.plusDarker)
                                    .opacity(0.6)
                            }
                            .frame(width: 48, height: 48)
                            .background(Color("RolloutMenuBlue"))
                            .clipShape(Circle())
                            .scaleEffect(isExpanded ? 1 : 0)
                            .animation(.spring(dampingFraction: damping).delay(isExpanded ? slow : fast - returnConstant), value: isExpanded)

                            ZStack {
                                Image(systemName: "mic.fill")
                                    .font(.system(size: 22.0))
                                    .blendMode(.plusDarker)
                                    .rotationEffect(isExpanded ? .degrees(0) : .degrees(-180))
                                    .opacity(0.6)
                            }
                            .frame(width: 48, height: 48)
                            .background(Color("RolloutMenuPink"))
                            .clipShape(Circle())
                            .scaleEffect(isExpanded ? 1 : 0)
                            .animation(.spring(dampingFraction: damping).delay(isExpanded ? slowest : fastest - returnConstant), value: isExpanded)

                            ZStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 26.0, weight: .semibold))
                                    .rotationEffect(.degrees(isExpanded ? 45 : 0))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 48, height: 48)
                            .background(.green)
                            .clipShape(Circle())
                            .onTapGesture {
                                isExpanded.toggle()
                            }.rotationEffect(.degrees(isExpanded ? 360 : 0))
                            .offset(x: isExpanded ? 0 : -280)
                            .animation(.spring(dampingFraction: buttonDamping), value: isExpanded)
                        }
                        ZStack {
                            Rectangle()
                                .fill(.black.opacity(1))
                                .frame(width: 400, height: 48)
                                .clipShape(RoundedRectangle(cornerRadius: 100))
                                .offset(x: isExpanded ? 316 : 36)
                                .animation(.spring(dampingFraction: buttonDamping), value: isExpanded)
                                .allowsHitTesting(false)

                            ZStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 26.0, weight: .semibold))
                                    .rotationEffect(.degrees(isExpanded ? 45 : 0))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 48, height: 48)
                            .background(.white)
                            .clipShape(Circle())
                            .scaleEffect(isDetectingLongPress ? 1.6 : (completedLongPress ? 1.0 : 1.0))
                            .rotationEffect(.degrees(isDetectingLongPress ? 0 : 720))
                            .rotationEffect(.degrees(isExpanded ? 0 : -360))
                            .offset(x: isExpanded ? 140 : -140)
                            .animation(.spring(dampingFraction: buttonDamping), value: isExpanded)
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 3.0, maximumDistance: 100)
                                    .updating($isDetectingLongPress) { currentState, gestureState,
                                        transaction in
                                        gestureState = currentState
                                        transaction.animation = Animation.easeInOut(duration: 2.2)
                                    }
                                    .onEnded { _ in
                                        damping = 0.4
                                        buttonDamping = 0.4
                                        isExpanded.toggle()
                                    }
                            )
                            .highPriorityGesture(TapGesture()
                                .onEnded { _ in
                                    damping = 0.56
                                    buttonDamping = 0.68
                                    isExpanded.toggle()
                                })
                        }
                    }
                }
                .padding(.bottom, 50)
            }
            .statusBarHidden()
        }
    }
}

struct RolloutMenu_Previews: PreviewProvider {
    static var previews: some View {
        RolloutMenu()
    }
}
