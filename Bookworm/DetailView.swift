//
//  DetailView.swift
//  Bookworm
//
//  Created by Víctor Ávila on 01/06/24.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    // This needs only one property: a Book to show
    let book: Book
    
    var body: some View {
        // Make sure your content is inside a ScrollView, so it ensures our full review fits onto the screen no matter how long it is
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre)
                    .resizable()
                    .scaledToFit()
                
                Text(book.genre.uppercased())
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundStyle(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                    .offset(x: -5, y: -5)
            }
            
            // We don't want to let users change the rating here, so we will use a constant Binding
            // We can use SF Symbols and scale them up using the .font() modifier
            Text(book.author)
                .font(.title)
                .foregroundStyle(.secondary)
            
            Text(book.review)
                .padding()
            
            RatingView(rating: .constant(book.rating))
                .font(.largeTitle)
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize) // If the text fits completely, don't bounce
    }
}

#Preview {
    // Fixing this with SwiftData is messier: creating a new book also means having a view context to create it inside.
    // In order to create a Book object:
    // 1. Create a model object
    // 2. Make a modelContainer and a modelContext for it to live inside
    // 3. Set a custom configuration so everything's temporary and is gone when the Preview stops (it is just for Preview purposes)
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true) // don't write anything to disk here
        let container = try ModelContainer(for: Book.self, configurations: config)
        
        // This book silently finds the container and the context behind the scenes
        let example = Book(title: "Test Book", author: "Test Author", genre: "Fantasy", review: "This was a great book; I really enjoyed it.", rating: 4)
        
        return DetailView(book: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
