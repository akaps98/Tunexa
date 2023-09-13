//
//  LibraryView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI

struct LibraryView: View {
    var body: some View {
        VStack {
            Text("Library View")
                .font(.title)
                .bold()
            Text("User create play list here")
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
