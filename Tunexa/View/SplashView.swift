//
//  SplashScreen.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import SwiftUI

struct SplashScreen: View {
    // State variables to define the initial value of logo size, position, angles, and opacity for later animation modified
    @State private var isSplashActive = false
    @State private var size = 0.2
    @State private var opacity = 0.2
    @State private var angle: Double = 1
    @State private var textYOffset: Double = 10
    @State private var textOpacity: Double = 0
    
    var body: some View {
        // Check if the splash screen is available or disabled (only appeared once for each time the app start/restart)
        if (isSplashActive) {
            ContentView()
        } else {
            ZStack {
                // MARK: BACKGROUND
                Color(.white)
                    .edgesIgnoringSafeArea(.all)
                
                // MARK: CONTENT
                VStack {
                    Image("logo-icon-transparent")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 120)
                    // Set Animation Effects for logo
                        .scaleEffect(size)
                        .rotationEffect(Angle(degrees: angle))
                        .opacity(opacity)
                        .onAppear{
                            // Perform the series of animated action by adjusting the self-defined variables
                            withAnimation(.easeInOut(duration: 2.0)) {
                                self.size = 1.0
                                self.opacity = 1.0
                                self.angle = 540
                            }
                        }
                    Text("Tunexa")
                        .font(.custom("Nunito-Black", size: 50))
                        .foregroundColor(Color("text-color"))
                        .offset(y: textYOffset)
                        .opacity(textOpacity)
                        .onAppear{
                            // Perform the series of animated action by adjusting the self-defined variables
                            withAnimation(.easeIn(duration: 1.0).delay(2.0)) {
                                self.textOpacity = 1.0
                                self.textYOffset = -10
                            }
                        }
                }
                
            }
            .onAppear {
                // 
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    withAnimation {
                        self.isSplashActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
