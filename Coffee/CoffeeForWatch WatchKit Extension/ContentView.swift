//
//  ContentView.swift
//  CoffeeForWatch WatchKit Extension
//
//  Created by Javier Rodríguez Gómez on 9/3/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CapsuleList()) {
                    Text("Cápsulas")
                }
                NavigationLink(destination: MachineList()) {
                    Text("Máquinas")
                }
            }
            .navigationTitle("Coffee")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
