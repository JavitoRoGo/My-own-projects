//
//  CoffeeApp.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 17/12/21.
//

import SwiftUI

@main
struct CoffeeApp: App {
    @StateObject private var capsuleModel = CapsuleModel()
    @StateObject private var machineModel = MachineModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(capsuleModel)
                .environmentObject(machineModel)
        }
    }
}
