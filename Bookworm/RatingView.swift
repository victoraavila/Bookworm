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

// VoiceOver/Accessibility notes
// This RatingView does not work well with VoiceOver: since it uses a lot of Buttons, each star is treated individually (all each one says is "favorite, button").
// This is extra problematic because RatingView was designed to be reusable: you can take it to other projects. Since this accessibility issue is not being corrected, you will pollute the other projects.
// We'll tackle it in two ways:
// 1. Using a lot of modifiers to do an OK job;
// 2. Looking at how adjustable actions get us a more optimal solution.

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
                // 1st way:
                // Adding two modifiers: the 1st is a meaningful label for each star and the 2nd is an extra trait to the Buttons that are currently highlighted (so users can see which one is currently active)
//                .accessibilityLabel("\(number == 1 ? "1 star" : "\(number) stars")")
//                .accessibilityAddTraits(number > rating ? [] : [.isSelected]) // If rating is 3 and number is 4, add no traits. If not, it will say "one star, selected"...
            }
        }
        // Add this so the whole row won't be equivalent to a single Button in a Form
        // (even Seniors don't know this hack)
        .buttonStyle(.plain)
        
        // 2nd way: the adjustable action approach by swapping, which is more confortable to VoiceOver users than tapping the stars
        // Applying to the whole RatingView
        .accessibilityElement() // Grouping all five buttons
        .accessibilityLabel(label) // Label is being passed in already
        .accessibilityValue(rating == 1 ? "1 star" : "\(rating) stars") // This will be read as rating: 2 stars, since the label is "rating".
        // Controlling increasing and decreasing the value with swipe gestures
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if rating < maximumRating { rating += 1 }
            case .decrement:
                if rating > 1 { rating -= 1 }
            default:
                // It probably won't enter here
                break
            }
        }
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
