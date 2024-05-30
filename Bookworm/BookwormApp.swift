//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Víctor Ávila on 30/05/24.
//

import SwiftUI
import SwiftData

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Asking SwiftData to make a ModelContainer for our Book model
        .modelContainer(for: Book.self)
    }
}
