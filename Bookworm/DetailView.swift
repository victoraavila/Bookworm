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
    
    // Adding a Delete Button that will delete this Book, pop out DetailView from the Navigation Stack, and then return to the original ContentView.
    // We'll also trigger an alert to confirm if the user really wants to delete it. If so, we will delete it from the modelContext.
    // We need 3 properties:
    // 1. To hold the current modelContext and delete stuff from there.
    // 2. To hold the dismiss action.
    // 3. To control if we're currently showing the alert or not.
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    // We also need a method to delete the current book from modelContext and then dismiss the DetailView (doesn't matter if being shown with NavigationLink or .sheet(), dismiss() will work perfectly)
    
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
        
        // We want two Buttons in the alert: one to really delete the book and another one to cancel.
        // Both of them gotta have specific Button roles attached to them so they look like iOS built-in looks
        // Apple's guidance on labeling Alert texts: if it has titles like "I understand", then "OK" is good.
        // However, if the user has to make a choice, then you MUST use verbs like "Ignore", "Reply" and "Confirm".
        // In this case, we will use "Delete" and "Cancel":
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        
        // Adding a ToolbarItem that will flip the value of showingDeleteAlert
        .toolbar {
            Button("Delete this book", systemImage: "trash") {
                showingDeleteAlert = true
            }
        }
        
    }
    
    func deleteBook() {
        modelContext.delete(book)
        dismiss()
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
