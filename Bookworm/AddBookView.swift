//
//  AddBookView.swift
//  Bookworm
//
//  Created by Víctor Ávila on 30/05/24.
//

import SwiftUI

// This thing needs to have one environment property to read our modelContext back out of the environment
struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    
    // Make the Form dismiss itself when we add a Book
    @Environment(\.dismiss) var dismiss
    
    // This form is going to store all the data required to make up a new book, so we need @State properties to save these local values
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3 // Middling by default
    @State private var genre = "Fantasy"
    @State private var review = ""
    
    // This will store all genre possible options, so we can make a Picker
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                // Since we're using a TextEditor for the review, we cannot add a placeholder. This is way we created a new Section (to use the title)
                Section("Write a review") {
                    TextEditor(text: $review)
                    
                    // When SwiftUI has these rows in a Form, it likes to assume these rows are tappable (for example, the whole Save row can be tapped as a Button)
                    // In this case, however, we have multiple Buttons in this row. SwiftUI is confused, it basically taps them all in order (add a print() inside RatingView to see it)
                    RatingView(rating: $rating)
                }
                
                Section {
                    Button("Save") {
                        // Making an instance of our Book class using all the values from our form and inserting it into the modelContext, which triggers the auto-save
                        let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating)
                        modelContext.insert(newBook)
                        dismiss()
                    }
                    .disabled(
                        title.trimmingCharacters(in: .whitespaces).isEmpty || author.trimmingCharacters(in: .whitespaces).isEmpty ? 
                        true : false
                    )
                }
            }
            .navigationTitle("Add Book")
        }
    }
}

#Preview {
    AddBookView()
}
