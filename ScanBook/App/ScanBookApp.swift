//
//  ScanBookApp.swift
//  ScanBook
//
//  Created by 김학철 on 10/12/23.
//

import SwiftUI

@main
struct ScanBookApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var appState = AppStateVM()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appState)
        }
    }
}
