//
//  SongTestView.swift
//  Tunexa
//
//  Created by SeongJoon, Hong  on 13/09/2023.
//

import SwiftUI
import PhotosUI

struct SongTestView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var songs: FetchedResults<Song>
    @State private var name = ""
    @State private var artist = ""
    @State private var album = ""
    @State private var albumImage: UIImage?
    @State private var image: Image?
    @State private var imageItem: PhotosPickerItem?
    
    var body: some View {
        VStack{
            TextField("Name of the song", text: $name)
            TextField("Name of the artist", text: $artist)
            TextField("Name of the album", text: $album)
            HStack{
                PhotosPicker("Select Album Image", selection: $imageItem, matching: .images)
                if let image{
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }
            }
            .onChange(of: imageItem){ _ in
                Task{
                    if let data = try? await imageItem?.loadTransferable(type: Data.self){
                        if let uiImage = UIImage(data: data){
                            image = Image(uiImage: uiImage)
                            return
                        }
                    }
                }
            }
            Button{
                let newSong = Song(context: moc)
                newSong.id = UUID()
                newSong.name = name
                newSong.artist = artist
                newSong.album = album
                if let albumImage{
                    let imageData = albumImage.pngData()! as Data?
                    newSong.albumImage = imageData
                }
            } label: {
               Text("add")
            }
            NavigationView{
                List{
                    ForEach(songs){ song in
                        Text(song.name ?? "")
                        Text(song.artist ?? "")
                        Text(song.album ?? "")
                        Image(uiImage: UIImage(data: song.albumImage ?? Data()) ?? UIImage())
                    }
                }
                .navigationTitle("Song Titles")
            }
        }
    }
}

struct SongTestView_Previews: PreviewProvider {
    static var previews: some View {
        SongTestView()
            .environment(\.managedObjectContext, SongViewModel.shared.container.viewContext)
    }
}
