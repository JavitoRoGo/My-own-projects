//
//  ContentView.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 17/12/21.
//

import SwiftUI

struct ContentView: View {
    @State private var selectionTab: Tab = .coffee
    
    enum Tab {
        case coffee
        case machine
        case year
    }
    
    var body: some View {
        TabView(selection: $selectionTab) {
            CapsuleList()
                .tabItem {
                    Label("Cápsulas", systemImage: "cup.and.saucer")
                }
            
            MachineList()
                .tabItem {
                    Label("Máquinas", systemImage: "fuelpump")
                }
            
            YearList()
                .tabItem {
                    Label("Año", systemImage: "calendar")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CapsuleModel())
            .environmentObject(MachineModel())
    }
}
