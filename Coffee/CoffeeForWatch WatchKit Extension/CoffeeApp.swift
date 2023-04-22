//
//  CoffeeApp.swift
//  CoffeeForWatch WatchKit Extension
//
//  Created by Javier Rodríguez Gómez on 9/3/22.
//

import SwiftUI

@main
struct CoffeeApp: App {
    @StateObject var capsuleModel = CapsuleModel()
    @StateObject var machineModel = MachineModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(capsuleModel)
            .environmentObject(machineModel)
        }
    }
}
