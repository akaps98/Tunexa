/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141) - Main Contributor
  2. Seoungjoon Hong (s3726123)
  3. Junsik Kang (s3916884)
  4. Christina Yoo (s3938331)
  5. Nguyen Hoang Viet (s3926104)
  Created date: 12/09/2023
  Last modified: 12/09/2023
  Acknowledgement:
 - Custom Splash Screen: https://www.youtube.com/watch?v=0ytO3wCRKZU&ab_channel=Indently
 - How to run code after a delay using asyncafter and perform: https://www.hackingwithswift.com/example-code/system/how-to-run-code-after-a-delay-using-asyncafter-and-perform
*/

import SwiftUI

struct SplashView: View {
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
                            // Perform the series of animated action by adjusting the self-defined variables (delay 2 seconds)
                            withAnimation(.easeIn(duration: 1.0).delay(2.0)) {
                                self.textOpacity = 1.0
                                self.textYOffset = -10
                            }
                        }
                }
                
            }
            .onAppear {
                // Wait for splashscreen animation to finish and load the content view
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    withAnimation {
                        self.isSplashActive = true
                    }
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
