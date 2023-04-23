//
//  ContentView.swift
//  MyRingsWithCD
//
//  Created by Javier Rodríguez Gómez on 16/12/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("", systemImage: "clock")
                }
            DataChartView()
                .tabItem {
                    Label("", systemImage: "calendar")
                }
            TrainChartView()
                .tabItem {
                    Label("", systemImage: "figure.walk")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
