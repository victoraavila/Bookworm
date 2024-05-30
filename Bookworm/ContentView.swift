//
//  ContentView.swift
//  Bookworm
//
//  Created by Víctor Ávila on 30/05/24.
//

import SwiftUI

// We'll add a new SwiftData model for our books and then make a new View to add books to the database
import SwiftData

struct ContentView: View {
    // Add a @State property to track whether the sheet is showing or not,
    // Add some kind of Button to the toolbar (whcih toggles the property),
    // Add a .sheet() modifier to track that property and show or don't.
    
    // The modelContext here is important so we can delete books further on
    @Environment(\.modelContext) var modelContext
    
    // To read all our books out
    @Query var books: [Book]
    
    @State private var showingAddScreen = false
    
    var body: some View {
        // This View is going to have an Add Button, and also information about how many items we have in the books array
        NavigationStack {
            // Listing all the books that have been added along with the rating and the author
            // ForEach works out of the box (we don't need to set an id here) because all SwiftData Model objects conform to identifiable
            List {
                ForEach(books) { book in // So we can add deleting later on
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Book", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
}

#Preview {
    ContentView()
}
