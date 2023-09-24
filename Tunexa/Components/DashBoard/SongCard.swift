/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141)
  2. Seoungjoon Hong (s3726123) - Main Contributor
  3. Junsik Kang (s3916884)
  4. Christina Yoo (s3938331) - Sub Contributor
  5. Nguyen Hoang Viet (s3926104) - Main Contributor
  Created date: 13/09/2023
  Last modified: 13/09/2023
  Acknowledgement: None
  -
*/

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
    
    @State private var isLoading = true

    // This initializes the player and sets up the notification listener
    func setupPlayer() {
        currentSongIndex = songs.firstIndex(of: song) ?? 0
        playSound.changeSong(fileName: currentSong.name ?? "", fileType: "mp3", fileURL: currentSong.songURL ?? "") {
            isLoading = false
        }
//        playSound.play()

        NotificationCenter.default.publisher(for: .songDidFinishPlaying)
            .sink { [self] _ in
                print("Received songDidFinishPlaying notification")
                switchSong(to: currentSongIndex + 1)
            }
            .store(in: &cancellables.cancellables)
    }
    
    private func switchSong(to index: Int, source: String? = nil) {
        // set isLoading for the fetching song file time
        isLoading = true
        // If repeating is on and the function isn't called by user interaction (forward or backward tap)
        if isRepeating && source == nil {
            playSound.stop()
            playSound.changeSong(fileName: currentSong.name ?? "", fileType: "mp3", fileURL: currentSong.songURL ?? "") {
                isLoading = false
            }
//            playSound.play()
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
        playSound.changeSong(fileName: currentSong.name ?? "", fileType: "mp3", fileURL: currentSong.songURL ?? "") {
            isLoading = false
        }
//        playSound.play()
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
            
            // When the song file is being fetched, a progress view is displayed with buttons disabled
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .frame(width: 200, height: 80)
                    .foregroundColor(.blue)
                    .overlay(
                        Text("Loading song...")
                            .font(.custom("Nunito", size: 20))
                            .foregroundColor(.blue)
                            .offset(y:27)
                    )
                    .offset(y:80)
            }
            
            VStack {
                // MARK: HEADER
                HStack(spacing: 10) {
                    Button {
                        // Stop sound
                        playSound.stop()
                        
                        // Remove the current view and return to the previous view
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 25))
                            .foregroundColor(Color("text-color"))
                    }
                    .disabled(isLoading)
                    
                    Spacer()
                    
                    Text("Now Playing")
                        .font(.custom("Nunito-Bold", size: 20))
                        .offset(x: -10)
                    Spacer()
    
                    
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
                        .disabled(isLoading)
                        Button {
                            switchSong(to: currentSongIndex - 1, source: "userInteraction")
                        } label: {
                            Image(systemName: "backward.end.fill")
                                .font(.system(size: 22))
                                .foregroundColor(Color("text-color"))
                        }
                        .disabled(isLoading)
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
                    .disabled(isLoading)
                    
                    Spacer()
                    
                    HStack(spacing: 30) {
                        Button {
                            switchSong(to: currentSongIndex + 1, source: "userInteraction")
                        } label: {
                            Image(systemName: "forward.end.fill")
                                .font(.system(size: 22))
                                .foregroundColor(Color("text-color"))
                        }
                        .disabled(isLoading)
                        Button {
                            print("Shuffle tapped")
                            isShuffling.toggle()
                        } label: {
                            Image(systemName: "shuffle")
                                .font(.system(size: 22))
                                .foregroundColor(isShuffling ? .blue : Color("text-color"))
                        }
                        .disabled(isLoading)
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
