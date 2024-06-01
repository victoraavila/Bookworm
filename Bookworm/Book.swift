//
//  Book.swift
//  Bookworm
//
//  Created by Víctor Ávila on 30/05/24.
//

import Foundation
import SwiftData

@Model
class Book {
    // When you use @Query to pull data, you get to specify how you want that data to be sorted: alphabetically by one of the fields, numerically with the highest value, etc. It's important to choose some kind of sorting, because you want the user to have a predictable experience every time.
    // We can also have more than one: sort by title first, then by rating.
    // Sorting can be done in two ways:
    // One is a simple option that allows only one sort field and the other is a more advanced that allows an array of type SortDescriptor
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    
    init(title: String, author: String, genre: String, review: String, rating: Int) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
    }
}
