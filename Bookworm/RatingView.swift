//
//  RatingView.swift
//  Bookworm
//
//  Created by Víctor Ávila on 30/05/24.
//

import SwiftUI

// Custom Components are regular Views that expose some kind of @Binding property for us to read elsewhere
// We will build a star rating component with a bunch of extra customizable properties for flexibility: a label for it, an integer value for the maximum number of stars, off/on Images (the default will be nil for the off Image and a filled star for the on Image), off/on colors (if the star is highlighted it will be yellow, otherwise it will be gray).
// We will also have a @Binding to an Integer made elsewhere that will be changed when the user taps the stars.

struct RatingView: View {
    @Binding var rating: Int
    
    var label = ""
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            
            ForEach(1 ..< maximumRating + 1, id: \.self) { number in
                Button {
                    rating = number
                } label: {
                    image(for: number)
                        .foregroundStyle(number > rating ? offColor : onColor)
                }
            }
        }
        // Add this so the whole row won't be equivalent to a single Button in a Form
        // (even Seniors don't know this hack)
        .buttonStyle(.plain)
    }
    
    // The logic to select the Images is this: if the rating passed in is greater than the current rating, return the offImage if it was set. Otherwise, return the onImage.
    // If the rating passed in is smaller than the current rating, return the onImage.
    func image(for number: Int) -> Image {
        if number > rating {
            offImage ?? onImage
        } else {
            onImage
        }
    }
}

#Preview {
    // How to pass Bindings in Previews: via Constant Bindings (with fixed values). You can change them easily and create them trivially.
    RatingView(rating: .constant(0))
}
