//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by Víctor Ávila on 30/05/24.
//

import SwiftUI

// We'll create an Emoji rating View to differ things a little
// It will select a different Emoji depending on the rating
struct EmojiRatingView: View {
    let rating: Int
    
    var body: some View {
        switch rating {
        case 1:
            Text("☹️")
        case 2:
            Text("🥱")
        case 3:
            Text("🫤")
        case 4:
            Text("😊")
        default: // In case everything goes wrong (but probably not, because we really only have 5 possible options)
            Text("🤯")
        }
    }
}

#Preview {
    EmojiRatingView(rating: 3)
}
