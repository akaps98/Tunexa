//
//  SongCardView.swift
//  Tunexa
//
//  Created by Viet Nguyen Hoang on 13/09/2023.
//

import SwiftUI
import AVFoundation
import Combine

struct SongCardView: View {
    var cancellables: Set<AnyCancellable> = []
    @State private var currentSongIndex: Int = 9
    // Since songs are loaded from the JSON file
    var songs: [Song] = decodeJsonFromJsonFile(jsonFileName: "songs.json")

    // Computed property to get the current song
    var currentSong: Song {
        return songs[currentSongIndex]
    }
    
    @ObservedObject var playSound: PlaySound
    
    
    init() {
        playSound = PlaySound(fileName: songs[0].name, fileType: "mp3")
        NotificationCenter.default.publisher(for: .songDidFinishPlaying)
            .sink { [self] _ in
                print("Received songDidFinishPlaying notification")
                switchSong(to: currentSongIndex + 1)
            }
            .store(in: &cancellables)
    }
    
    private func switchSong(to index: Int) {
        guard index >= 0 && index < songs.count else { return }
        print("Switching song to index:", index)
        // Stop the current song
        playSound.stop()

        // Update the currentSongIndex
        
        currentSongIndex = index

        // Initialize the player with the new song
        playSound.changeSong(fileName: currentSong.name, fileType: "mp3")
        playSound.play()
    }
    
    var totalSongDuration: Double {
        return playSound.duration
    }
    
    var formattedTotalDuration: String {
        let minutes = Int(totalSongDuration) / 60
        let seconds = Int(totalSongDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    var currentTime: String {
        let minutes = Int(playSound.currentTime) / 60
        let seconds = Int(playSound.currentTime) % 60
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
                            print("Settings View")
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
                    Text(currentSong.name)
                        .font(.custom("Nunito-Bold", size: 22))
                    Text(currentSong.author)
                        .font(.custom("Nunito-Light", size: 16))
                }
                
                Spacer()
                
                // MARK: SONG PROGRESS SLIDER
                HStack {
                    Text(currentTime)
                        .font(.custom("Nunito-Light", size: 12))
                        .padding(.leading)

                    Slider(value: $playSound.currentTime, in: 0.0...totalSongDuration, onEditingChanged: { isEditing in
                        if !isEditing {
                            playSound.setProgress(to: playSound.currentTime)
                        }
                    })
                    .padding(.horizontal)

                    Text(formattedTotalDuration)
                        .font(.custom("Nunito-Light", size: 12))
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
                            switchSong(to: currentSongIndex - 1)
                        } label: {
                            Image(systemName: "backward.end.fill")
                                .font(.system(size: 22))
                                .foregroundColor(Color("text-color"))
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        if playSound.isPlaying {
                            playSound.pause()
                        } else {
                            playSound.play()
                        }
                    } label: {
                        Image(systemName: playSound.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color("text-color"))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 30) {
                        Button {
                            switchSong(to: currentSongIndex + 1)
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
