//
//  SongCard.swift
//  Tunexa
//
//  Created by Viet Nguyen Hoang on 13/09/2023.
//

import SwiftUI
import AVFoundation
import Combine

struct SongCard: View {
    let song: Song
    let songs: [Song]
    @StateObject private var cancellables = CancellableManager()
    @StateObject var playSound = PlaySound()
    
    @State private var currentSongIndex: Int = 0
    @State private var isShuffling = false
    @State private var isRepeating = false
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode> // Store the presented value when the view is navigated
    
    class CancellableManager: ObservableObject {
        var cancellables: Set<AnyCancellable> = []
    }
    
    // This initializes the player and sets up the notification listener
    func setupPlayer() {
        currentSongIndex = songs.firstIndex(of: song) ?? 0
        playSound.changeSong(fileName: currentSong.name ?? "", fileType: "mp3", fileURL: currentSong.songURL ?? "")
        playSound.play()

        NotificationCenter.default.publisher(for: .songDidFinishPlaying)
            .sink { [self] _ in
                print("Received songDidFinishPlaying notification")
                switchSong(to: currentSongIndex + 1)
            }
            .store(in: &cancellables.cancellables)
    }
    
    private func switchSong(to index: Int, source: String? = nil) {
        // If repeating is on and the function isn't called by user interaction (forward or backward tap)
        if isRepeating && source == nil {
            playSound.stop()
            playSound.changeSong(fileName: currentSong.name ?? "", fileType: "mp3", fileURL: currentSong.songURL ?? "")
            playSound.play()
            return
        }

        var newIndex = index

        if isShuffling {
            newIndex = Int.random(in: 0..<songs.count)
        } else if index == songs.count {
            newIndex = 0
        }
        
        guard newIndex >= 0 && newIndex < songs.count else { return }
        print("Switching song to index:", newIndex)
        
        // Stop the current song
        playSound.stop()

        // Update the currentSongIndex
        currentSongIndex = newIndex

        // Initialize the player with the new song
        playSound.changeSong(fileName: currentSong.name ?? "", fileType: "mp3", fileURL: currentSong.songURL ?? "")
        playSound.play()
    }

    // Computed property to get the current song
    var currentSong: Song {
        return songs[currentSongIndex]
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
                        // Remove the current view and return to the previous view
                        presentationMode.wrappedValue.dismiss()
                        
                        // Stop sound
                        playSound.stop()
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
                AsyncImage(url: URL(string: currentSong.avatarName ?? "")){ phase in
                    if let image = phase.image{
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .cornerRadius(8)
                    }else if phase.error != nil{
                        Rectangle()
                            .frame(width: 250, height: 250)
                            .cornerRadius(8)
                    }else{
                        Rectangle()
                            .frame(width: 250, height: 250)
                            .cornerRadius(8)
                    }
                }
                
                // MARK: SONG TITLE AND ARTIST
                VStack {
                    Text(currentSong.name ?? "")
                        .font(.custom("Nunito-Bold", size: 22))
                    Text(currentSong.author[0] ?? "")
                        .font(.custom("Nunito-Light", size: 16))
                        .padding(.bottom, 30)
//                    Rating(rating: currentSong.rating)
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
                            print("Repeat tapped")
                            isRepeating.toggle()
                        } label: {
                            Image(systemName: isRepeating ? "repeat.1" : "repeat")
                                .font(.system(size: 22))
                                .foregroundColor(isRepeating ? .blue : Color("text-color"))
                        }
                        Button {
                            switchSong(to: currentSongIndex - 1, source: "userInteraction")
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
                            switchSong(to: currentSongIndex + 1, source: "userInteraction")
                        } label: {
                            Image(systemName: "forward.end.fill")
                                .font(.system(size: 22))
                                .foregroundColor(Color("text-color"))
                        }
                        Button {
                            print("Shuffle tapped")
                            isShuffling.toggle()
                        } label: {
                            Image(systemName: "shuffle")
                                .font(.system(size: 22))
                                .foregroundColor(isShuffling ? .blue : Color("text-color"))
                        }
                    }
                    
                    Spacer()

                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .onAppear {
            setupPlayer()
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

//struct SongCard_Previews: PreviewProvider {
//    static var previews: some View {
//        SongCard()
//    }
//}
