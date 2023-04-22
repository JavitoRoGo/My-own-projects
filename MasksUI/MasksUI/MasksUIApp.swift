//
//  MasksUIApp.swift
//  MasksUI
//
//  Created by Javier Rodríguez Gómez on 3/12/21.
//

import SwiftUI

@main
struct MasksUIApp: App {
    @StateObject private var model = MasksModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
