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
//    @Query var books: [Book]
    
    // When you use @Query to pull data, you get to specify how you want that data to be sorted: alphabetically by one of the fields, numerically with the highest value, etc. It's important to choose some kind of sorting, because you want the user to have a predictable experience every time.
    // We can also have more than one: sort by title first, then by rating.
    // Sorting can be done in two ways:
    // One is a simple option that allows only one sort field and the other is a more advanced that allows an array of type SortDescriptor
    // Sorting on alphabetical order based on their title
//    @Query(sort: \Book.title) var books: [Book]
    
    // Sorting based on rating, but with 5-star books first
//    @Query(sort: \Book.rating, order: .reverse) var books: [Book]
    
    // However, it is better to have a back-up field to sort with in order to have a predictable behaviour
    // This is done by using a SortDescriptor type which we can create from either one or two values: the field (property) to sort and the order
    // Sorting on alphabetical order based on their title
//    @Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]
    // Sorting on alphabetical order based on their title, and then reverse it (from Z-A)
//    @Query(sort: [SortDescriptor(\Book.title, order: .reverse)]) var books: [Book]
    
    // Give me the Book title first, and when there are two books with same name sort by author
    // Having two or three fields in this array to sort by it is a good idea, because it causes almost no impact! (Unless there are lots of data with multiple similar titles).
    // If they have different titles, authors are never checked.
    @Query(sort: [SortDescriptor(\Book.title),
                  SortDescriptor(\Book.author)
    ]) var books: [Book]
    
    
    @State private var showingAddScreen = false
    
    var body: some View {
        // This View is going to have an Add Button, and also information about how many items we have in the books array
        NavigationStack {
            // Listing all the books that have been added along with the rating and the author
            // ForEach works out of the box (we don't need to set an id here) because all SwiftData Model objects conform to identifiable
            List {
                ForEach(books) { book in // So we can add deleting later on
                    // When the user taps a book here in ContentView, we're gonna present a new DetailView with more information (the genre, the brief review, and more.)
                    // We will use reuse the RatingView in a customized way, as well as use artwork from unsplash.com
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
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book)
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
