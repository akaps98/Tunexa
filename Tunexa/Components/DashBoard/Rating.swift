//
//  Rating.swift
//  Tunexa
//
//  Created by Tony on 2023/09/17.
//

import SwiftUI

struct Rating: View {
    @State var rating: Int

    var maximum = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color("light-gray")
    var onColor = Color("primary-color")
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
    var body: some View {
        HStack {
            ForEach(1..<maximum + 1, id: \.self) { number in
                image(for: number)
                    .font(.system(size: 12))
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
}

struct Rating_Previews: PreviewProvider {
    static var previews: some View {
        Rating(rating: 4)
    }
}
