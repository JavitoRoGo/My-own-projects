//
//  CoffeeForMacApp.swift
//  CoffeeForMac
//
//  Created by Javier Rodríguez Gómez on 9/3/22.
//

import SwiftUI

@main
struct CoffeeForMacApp: App {
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
