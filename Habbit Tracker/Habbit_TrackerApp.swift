//
//  Habbit_TrackerApp.swift
//  Habbit Tracker
//
//  Created by Yadnyesh Khakal on 06/06/25.
//

import SwiftUI

@main
struct Habbit_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
