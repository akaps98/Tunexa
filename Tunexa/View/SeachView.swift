//
//  SearchView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI

struct SearchView: View {
    @Binding var isDark: Bool
    @State private var name: String = ""
    @State private var ratingValue = 1.0
    var minimumValue = 1.0
    var maximumValue = 5.0
        
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: -----BACKGROUND-----
                Color("bg-color")
                    .edgesIgnoringSafeArea(.all)
                // MARK: -----CONTENT-----
                ScrollView {
                    // MARK: -----STAR RATING SLIDER-----
                    Slider(value: $ratingValue, in: minimumValue...maximumValue)
                        .frame(width: 250)
                    Text("Rating: \(Int(ratingValue))")
                        .font(.custom("Nunito-Medium", size: 16))
                        .offset(y: -10)
                    // MARK: BODY
                    VStack {
                        ForEach(songs, id: \.self) {song in
                            SongRow(song: song)
                        }
                    }
                }
            }
            // MARK: HEADER
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Search")
                        .font(.custom("Nunito-Bold", size: 25))
                }
                
                // Dark Mode toggle button on the right-handed side of navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 5) {
                        Button {
                            print("Setting View")
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.system(size: 20))
                                .foregroundColor(Color("text-color"))
                        }
                        
                    }
                    
                }
                
            }
           
        }
        .searchable(text: $name)
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(isDark: .constant(false))
    }
}
