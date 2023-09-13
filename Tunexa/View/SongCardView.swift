//
//  SongCardView.swift
//  Tunexa
//
//  Created by Viet Nguyen Hoang on 13/09/2023.
//

import SwiftUI

struct SongCardView: View {
    @State private var currentSongPosition: Double = 0.0
    let totalSongDuration: Double = 210.0  // for a 4-minute song, for instance
    var formattedTotalDuration: String {
        let minutes = Int(totalSongDuration) / 60
        let seconds = Int(totalSongDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    var currentTime: String {
        let minutes = Int(currentSongPosition) / 60
        let seconds = Int(currentSongPosition) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
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
                        .font(.custom("Nunito-Bold", size: 20))
                    
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
                
                // MARK: SONG PROGRESS SLIDER
                HStack {
                    // Text representing current time in the song
                    Text(currentTime)
                        .font(.caption)
                        .padding(.leading)

                    // The progress slider itself
                    Slider(value: $currentSongPosition, in: 0.0...totalSongDuration, onEditingChanged: { isEditing in
                        if !isEditing {
                            // Handle the change in song position here when the user finishes dragging the slider.
                            // This might involve seeking the audio to the correct position.
                        }
                    })
                    .padding(.horizontal)

                    // Text representing total duration of the song
                    Text(formattedTotalDuration)
                        .font(.caption)
                        .padding(.trailing)
                }

                Spacer()
        
                // MARK: AUDIO CONTROLS
                HStack {
                    Spacer()
                    
                    HStack(spacing: 30) {
                        Button {
                            print("Repeat")
                        } label: {
                            Image(systemName: "repeat")
                                .font(.system(size: 22))
                                .foregroundColor(Color("text-color"))
                        }
                        Button {
                            print("Backward")
                        } label: {
                            Image(systemName: "backward.end.fill")
                                .font(.system(size: 22))
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
                    
                    HStack(spacing: 30) {
                        Button {
                            print("Forward")
                        } label: {
                            Image(systemName: "forward.end.fill")
                                .font(.system(size: 22))
                                .foregroundColor(Color("text-color"))
                        }
                        Button {
                            print("Shuffle")
                        } label: {
                            Image(systemName: "shuffle")
                                .font(.system(size: 22))
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
