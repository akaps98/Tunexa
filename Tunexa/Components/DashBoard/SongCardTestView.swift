//
//  SongCardTestView.swift
//  Tunexa
//
//  Created by SeongJoon, Hong  on 16/09/2023.
//

import SwiftUI
import Combine
import AVFoundation

struct SongCardTestView: View {
    let song: Song
    @ObservedObject var playSound: PlaySound
    init(song: Song) {
        self.song = song
        playSound = PlaySound(fileName: song.name ?? "", fileType: "mp3")
    }
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: song.avatarName ?? "")){ phase in
                if let image = phase.image{
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }else if phase.error != nil{
                    Rectangle()
                        .frame(width: 250, height: 250)
                }else{
                    Rectangle()
                        .frame(width: 250, height: 250)
                }
            }
            Text(song.name ?? "")
            Text(song.author ?? "")
            Button{
                playSound.stop()
            }label: {
                Text("pause")
            }
        }
        .onAppear{
            playSound.changeSong(fileName: song.songURL ?? "", fileType: "mp3")
            playSound.play()
        }
        .onDisappear{
            playSound.stop()
        }
    }
}

