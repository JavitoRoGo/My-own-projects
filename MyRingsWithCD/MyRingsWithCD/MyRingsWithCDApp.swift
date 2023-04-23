//
//  MyRingsWithCDApp.swift
//  MyRingsWithCD
//
//  Created by Javier Rodríguez Gómez on 16/12/22.
//

import SwiftUI

@main
struct MyRingsWithCDApp: App {
    @StateObject var model = MyViewModel()
    @StateObject var coreDataManager = CoreDataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .environment(\.managedObjectContext, coreDataManager.persistentContainer.viewContext)
        }
    }
}
