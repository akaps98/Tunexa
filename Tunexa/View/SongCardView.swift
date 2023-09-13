//
//  SongCardView.swift
//  Tunexa
//
//  Created by Viet Nguyen Hoang on 13/09/2023.
//

import SwiftUI

struct SongCardView: View {
    
    var body: some View {
        ZStack {
            Color("bg-color")
                .edgesIgnoringSafeArea(.all)
            VStack {
                // MARK: HEADER
                HStack(spacing: 10) {
                    Button {
                        print("Back")
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 25))
                            .foregroundColor(Color("text-color"))
                    }
                    
                    Spacer()
                    
                    Text("Now Playing")
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Button {
                            print("Setting View")
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.system(size: 25))
                                .foregroundColor(Color("text-color"))
                        }
                        
                    }
                    
                }
                .padding(.horizontal)
                
                Spacer()
                
                // MARK: SONG COVER
                Image("song-avatar-1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .cornerRadius(8)
                
                // MARK: SONG TITLE AND ARTIST
                VStack {
                    Text("See you again")
                        .font(.custom("Nunito-Bold", size: 22))
                    Text("Charlie Puth")
                        .font(.custom("Nunito-Light", size: 16))
                }
                
                Spacer()
                
                // MARK: AUDIO SLIDER
                HStack {
                    
                }
                
                Spacer()
        
                // MARK: AUDIO CONTROLS
                HStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            print("Repeat")
                        } label: {
                            Image(systemName: "repeat")
                                .font(.system(size: 25))
                                .foregroundColor(Color("text-color"))
                        }
                        Button {
                            print("Backward")
                        } label: {
                            Image(systemName: "backward.end.fill")
                                .font(.system(size: 25))
                                .foregroundColor(Color("text-color"))
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        print("Play")
                    } label: {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color("text-color"))
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            print("Forward")
                        } label: {
                            Image(systemName: "forward.end.fill")
                                .font(.system(size: 25))
                                .foregroundColor(Color("text-color"))
                        }
                        Button {
                            print("Shuffle")
                        } label: {
                            Image(systemName: "shuffle")
                                .font(.system(size: 25))
                                .foregroundColor(Color("text-color"))
                        }
                    }
                    
                    Spacer()

                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

struct SongCardView_Previews: PreviewProvider {
    static var previews: some View {
        SongCardView()
    }
}
